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

  def can_see?(target_row, target_col)
    r = trigger_r = self.row
    c = trigger_c = self.col
    dr = target_row - r
    dc = target_col - c
    step_dr = step_dc = carry_dr = carry_dc = 0
    step_trigger_dr = step_trigger_dc = 1 - 0.000001
    if dr.abs > dc.abs
      step_dr = dr / dr.abs if dr != 0
      carry_dc = dc / dc.abs if dc != 0
      step_trigger_dr = dr.abs / dc.abs.to_f - 0.000001
    else
      step_dc = dc / dc.abs if dc != 0
      carry_dr = dr / dr.abs if dr != 0
      step_trigger_dc = dc.abs / dr.abs.to_f - 0.000001
    end

    trigger_r += step_trigger_dr / 2
    trigger_c += step_trigger_dc / 2

    while r != target_row or c != target_col
      return false if Fixture.where(row: r, col: c, solid: true).any?
      if r > trigger_r or c > trigger_c
        r += carry_dr
        c += carry_dc
        trigger_r += step_trigger_dr
        trigger_c += step_trigger_dc
      else
        r += step_dr
        c += step_dc
      end
    end
    return true
  end

  private
  def not_standing_on_wall
    Fixture.where(room: self.room, row: self.row, col: self.col).each do |f|
      errors.add(:row, 'not an open cell') if f.solid
    end
  end
end
