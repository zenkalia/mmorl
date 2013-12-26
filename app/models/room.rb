class Room < ActiveRecord::Base
  has_many :users
  has_many :fixtures

  after_create do
    (1..20).each do |row|
      (1..80).each do |col|
        if rand > 0.8
          Fixture.create(room: self, char: '#', solid: true, bgc: 'black', fgc: 'white', row: row, col: col)
        else
          Fixture.create(room: self, char: '.', solid: false, bgc: 'black', fgc: 'white', row: row, col: col)
        end
      end
    end
  end
end
