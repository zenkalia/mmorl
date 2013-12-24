require 'spec_helper'

# +-----
# |   1
# | @ #2
# |   #<-3

describe User do
  let(:room) { Room.create() }
  let(:user) { User.create(room: room, row: 2, col: 2) }
  before do
    Fixture.create(char: '#', row: 2, col: 4, solid: true)
    Fixture.create(char: '#', row: 3, col: 4, solid: true)
  end

  describe :can_see? do
    it 'lets you see things you can see' do
      user.can_see?(1,4).should be_true
    end
    it 'blocks things behind walls' do
      user.can_see?(2,5).should be_false
    end
    it 'lets you see existing walls' do
      user.can_see?(3,4).should be_true
    end
  end
end
