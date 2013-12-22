class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :room

  validate :not_standing_on_wall

  def move(dr, dc)
    self.row += dr
    self.col += dc
    self.save
  end

  private
  def not_standing_on_wall
    Fixture.where(room: self.room, row: self.row, col: self.col).each do |f|
      errors.add(:row, 'not an open cell') if f.solid
    end
  end
end
