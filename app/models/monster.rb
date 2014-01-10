class Monster < ActiveRecord::Base
  belongs_to :room
  validates :room, presence: true

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
    self.save
    msgs = ["You hit #{self.name} for #{user.damage} damage."]
    msgs << "#{self.name.capitalize} died!" if self.health < 1
    msgs
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
