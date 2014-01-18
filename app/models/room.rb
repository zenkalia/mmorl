require 'matrix'

class Room < ActiveRecord::Base
  has_many :users
  has_many :items
  has_many :monsters
  has_many :memories
  has_many :chat_messages
  has_many :entry_portals, class_name: 'Portal', foreign_key: 'entry_room_id'
  has_many :exit_portals, class_name: 'Portal', foreign_key: 'exit_room_id'

  after_create do
    return if self.fixtures
    self.fixtures = ''
    1600.times do
      if rand > 0.8
        self.fixtures << '#'
      else
        self.fixtures << '.'
      end
    end
    self.save
  end

  def visible_to(user)
    memory = Memory.where(user: user, room: self).first
    memory_fixtures = memory.fixtures.clone
    fixtures = []
    vision_range = 3
    (user.row-vision_range..user.row+vision_range).each do |row|
      (user.col-vision_range..user.col+vision_range).each do |col|
        if self.can_see?(row, col, user) and user.man_distance(row, col) <= vision_range
          c = get_cha(row, col, user)
          fixtures << {
            cha: c,
            row: row,
            col: col
          }
          memory_index = (row-1)*80 + col - 1
          memory_fixtures[memory_index] = c if memory_fixtures[memory_index] and c
        end
      end
    end
    memory.fixtures = memory_fixtures
    memory.save
    fixtures
  end

  def can_see?(row, col, user)
    target = Vector[row, col]
    consider = Vector[user.row, user.col]
    diff = target - consider
    lateral = (diff[0].abs - diff[1].abs).abs
    diagonal = (diff.to_a.map{|v| v.abs}.max - lateral).abs
    flat_diff = Vector[diff[0] == 0 ? 0 : diff[0]/diff[0].abs,
                       diff[1] == 0 ? 0 : diff[1]/diff[1].abs]

    lateral_step = diff[0].abs > diff[1].abs ? Vector[flat_diff[0], 0]
                                             : Vector[0, flat_diff[1]]
    diagonal_step = flat_diff

    lateral_steps = Array.new(lateral, :lateral)
    diagonal_steps = Array.new(diagonal, :diagonal)
    if lateral == 0
      steps = diagonal_steps
    elsif diagonal == 0
      steps = lateral_steps
    elsif lateral > diagonal
      steps = lateral_steps.pop(diagonal)
      steps = steps.zip(diagonal_steps).flatten.compact
      while lateral_steps.count > 0
        steps = steps.zip(lateral_steps.pop(diagonal)).flatten.compact
      end
    else
      steps = diagonal_steps.pop(lateral)
      steps = steps.zip(lateral_steps).flatten.compact
      while diagonal_steps.count > 0
        steps = steps.zip(diagonal_steps.pop(lateral)).flatten.compact
      end
    end

    steps.each do |s|
      return true if consider == target
      fixture = self.get_fixture(consider[0], consider[1])
      return false if fixture == '#' or fixture == nil
      consider += s == :lateral ? lateral_step : diagonal_step
    end

    return true
  end

  def get_cha(row, col, user)
    meta_users = self.users.select{ |u| u.row == row and u.col == col and u != user }
    return '@' if meta_users.any?
    meta_monsters = self.monsters.select{ |m| m.row == row and m.col == col and m.persisted? and m.alive? }
    return 'g' if meta_monsters.any?
    meta_items = self.items.select{ |i| i.row == row and i.col == col }
    return ')' if meta_items.any?
    meta_portals = self.entry_portals.select{ |p| p.entry_row == row and p.entry_col == col }
    return meta_portals.first.char if meta_portals.any?
    get_fixture(row, col)
  end

  def get_fixture(row, col)
    return nil if row < 1 or row  > 20 or col < 1 or col > 80
    self.fixtures[(row-1)*80 + col-1]
  end
end
