class Memory < ActiveRecord::Base
  belongs_to :user
  belongs_to :room

  after_initialize do
    self.fixtures = ' ' * 1600 if self.new_record?
  end

  def get_fixture(row, col)
    return nil if row < 1 or row  > 20 or col < 1 or col > 80
    self.fixtures[(row-1)*80 + col-1]
  end

  def visible
    fixtures = []
    vision_range = user.vision_range
    (user.row-vision_range..user.row+vision_range).each do |row|
      (user.col-vision_range..user.col+vision_range).each do |col|
        if self.room.can_see?(row, col, user) and user.man_distance(row, col) <= vision_range
          c = get_fixture(row, col)
          fixtures << {
            cha: c,
            row: row,
            col: col
          } if c
        end
      end
    end
    fixtures
  end
end
