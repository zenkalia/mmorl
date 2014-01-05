class Room < ActiveRecord::Base
  has_many :users
  has_many :items
  has_many :monsters

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
    fixtures = []
    (user.row-1..user.row+1).each do |row|
      (user.col-1..user.col+1).each do |col|
        fixtures << {
          cha: get_cha(row, col, user),
          row: row,
          col: col
        }
      end
    end
    fixtures
  end

  def get_cha(row, col, user)
    meta_users = self.users.select{ |u| u.row == row and u.col == col and u != user}
    return '@' if meta_users.any?
    meta_monsters = self.monsters.select{ |m| m.row == row and m.col == col}
    return 'g' if meta_monsters.any?
    meta_items = self.items.select{ |i| i.row == row and i.col == col}
    return ')' if meta_items.any?
    get_fixture(row, col)
  end

  def get_fixture(row, col)
    return nil if row < 1 or row  > 20 or col < 1 or col > 80
    self.fixtures[(row-1)*80 + col-1]
  end
end
