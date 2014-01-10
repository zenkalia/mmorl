require 'spec_helper'

describe Item do
  let(:room){ Room.create( fixtures: '.' * 1600 ) }
  let(:user){ User.create( room: room, row: 1, col: 1, email: 'chilldude420@geemail.com', password: 'tupac_lives' ) }

  describe 'validations' do
    describe 'item count' do
      before do
        26.times do
          user.items << Item.create
        end
      end
      subject { user.items << Item.create }
      it 'raises an invalid record exception' do
        expect( subject ).to be_false
      end
    end
  end
end
