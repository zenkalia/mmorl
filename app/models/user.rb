require 'matrix'

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  belongs_to :room

  validate :not_standing_on_wall

  after_initialize do
    self.room = Room.first || Room.create
  end

  def move(dr, dc)
    self.row += dr
    self.col += dc
    self.save!
  rescue ActiveRecord::RecordInvalid
    self.reload
  end

  def visible_fixtures
    self.room.visible_to(self)
  end

  def can_see?(target_row, target_col)
    target = Vector[target_row, target_col]
    consider = trigger = Vector[self.row, self.col]
    diff = target - consider
    trigger_step = Vector[0.999999, 0.999999]
    carry = Vector[0, 0]
    step = diff.normalize.map(&:round)

    if diff[0].abs > diff[1].abs
      carry += Vector[0, diff[1] / diff[1].abs] if diff[1] != 0
      trigger_step = Vector[diff[0].abs / diff[1].abs.to_f - 0.000001, trigger_step[1]]
    else
      carry += Vector[diff[0] / diff[0].abs, 0] if diff[0] != 0
      trigger_step = Vector[trigger_step[0], diff[1].abs / diff[0].abs.to_f - 0.000001]
    end

    trigger += trigger_step / 2

    while consider != target
      return false if Fixture.where(row: consider[0], col: consider[1], solid: true).any?
      if consider[0] > trigger[0] or consider[1] > trigger[1]
        consider += carry
        trigger += trigger_step
      else
        consider += step
      end
    end
    return true
  end

  private
  def not_standing_on_wall
    errors.add(:row, 'not an open cell') if self.room.get_fixture(self.row, self.col) == '#'
  end
end
