class Monster < ActiveRecord::Base
  belongs_to :room
  validates :room, presence: true

  NAME_HASH = {
    goblin: 'a goblin'
  }

  STR_HASH = {
    goblin: 1
  }

  def name
    NAME_HASH[self.slug] || '??????'
  end

  def str
    STR_HASH[self.slug] || 0
  end
end
