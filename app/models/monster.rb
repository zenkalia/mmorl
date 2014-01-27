class Monster < ActiveRecord::Base
  belongs_to :room
  belongs_to :target, class_name: 'User', foreign_key: 'target_id'

  validates :room, presence: true
  validate :not_standing_on_wall
  validate :not_standing_on_user

  NAME_HASH = {
    'goblin' => 'the goblin'
  }

  STR_HASH = {
    'goblin' => 1
  }

  HEALTH_HASH = {
    'goblin' => 4
  }

  after_initialize do
    self.health = HEALTH_HASH[self.slug] || 1 if self.new_record?
  end

  before_save do
    self.destroy if self.health < 1
  end

  def take_damage_from(user)
    self.health -= user.damage
    self.target = user
    self.save

    ChatMessage.create( user: user,
                 public_body: "#{user.nick.capitalize} hit #{self.name} for #{user.damage} damage.",
                        body: "You hit #{self.name} for #{user.damage} damage." )
    ChatMessage.create( public_body: "#{self.name.capitalize} died!" ) if self.health < 1
    []
  end

  def tick
    if target and target.man_distance(self.row, self.col) < 2
      target.take_damage_from(self)
    else
      move_toward_target!
      []
    end
  end

  def move_toward_target!
    return unless self.room == target.room
    candidates = [[-1,-1], [-1,0], [-1,1], [0,-1], [0,1], [1,-1], [1,0], [1,1]]

    candidates.sort! do |a,b|
      target.man_distance(self.row + a[0], self.col + a[1]) <=> target.man_distance(self.row + b[0], self.col + b[1])
    end

    candidates.each do |c|
      if self.room.monster_get_cha(self.row + c[0], self.col + c[1]) == '.'
        self.row += c[0]
        self.col += c[1]
        self.save
        return
      end
    end
  rescue ActiveRecord::RecordInvalid
    []
  end

  def name
    NAME_HASH[self.slug] || '??????'
  end

  def damage
    STR_HASH[self.slug] || 0
  end

  def alive?
    self.persisted?
  end

  private
  def not_standing_on_wall
    errors.add(:row, 'not an open cell') if self.room.get_fixture(self.row, self.col) == '#' or self.row < 1 or self.row > 20 or self.col < 1 or self.col > 80
  end

  def not_standing_on_user
    errors.add(:row, 'not an open cell') if self.room.monster_get_cha(self.row, self.col) == '@'
  end
end
