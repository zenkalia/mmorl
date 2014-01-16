class Monster < ActiveRecord::Base
  belongs_to :room
  validates :room, presence: true
  belongs_to :target, class_name: 'User', foreign_key: 'target_id'

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
    self.target ||= user
    self.save
    msgs = ["You hit #{self.name} for #{user.damage} damage."]
    msgs << "#{self.name.capitalize} died!" if self.health < 1
    msgs
  end

  def tick
    if target and target.man_distance(self.row, self.col) < 2
      target.take_damage_from(self)
    else
      ["#{self.name.capitalize} gets a turn."]
    end
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
end
