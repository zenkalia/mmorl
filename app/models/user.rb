require 'matrix'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :room
  has_many :items

  validate :not_standing_on_wall

  after_initialize do
    self.room = Room.first || Room.create if self.new_record?
  end

  def move(dr, dc)
    meta_monsters = Monster.where(room: self.room, row: self.row + dr, col: self.col + dc)
    return attack(meta_monsters.first) if meta_monsters.any?
    self.row += dr
    self.col += dc
    self.save!
  rescue ActiveRecord::RecordInvalid
    self.reload
    return ['You bump into a wall.']
  end

  def visible_fixtures
    self.room.visible_to(self)
  end

  def attack(monster)
    msgs = []
    msgs += monster.take_damage_from(self)
    msgs += take_damage_from(monster) if monster.alive?
    msgs
  end

  def take_damage_from(monster)
    self.health -= monster.damage
    self.save
    ["#{monster.name.capitalize} hit you for #{monster.damage} damage."]
  end

  def damage
    1
  end

  private
  def not_standing_on_wall
    errors.add(:row, 'not an open cell') if self.room.get_fixture(self.row, self.col) == '#' or self.row < 1 or self.row > 20 or self.col < 1 or self.col > 80
  end
end
