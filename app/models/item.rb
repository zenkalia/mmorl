class Item < ActiveRecord::Base
  belongs_to :room
  belongs_to :user

  validate :in_exactly_one_room_or_user


  NAME_HASH = {
    short_sword: 'Short Sword'
  }

  def name
    NAME_HASH[self.slug] || '??????'
  end

  private
  def in_exactly_one_room_or_user
    errors.add(:room, 'must be in exactly one room or user') unless (self.user or self.room) and !(self.user and self.room) # xor
    return if errors.any?
    not_standing_on_wall if self.room
  end

  def not_standing_on_wall
    errors.add(:row, 'not an open cell') if self.room.get_fixture(self.row, self.col) == '#'
  end
end
