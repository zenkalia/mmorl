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
  describe 'item letters' do
    it 'assigns letters in alphabetical order' do
      item = Item.create
      user.items << item # pick up an item
      expect(item.letter).to eq('a')
      second_item = Item.create
      user.items << second_item # pick up a second item
      expect(second_item.letter).to eq('b')
      item.user = nil
      item.room = room
      item.row = user.row
      item.col = user.col
      item.save # drop the first item FIXME
      expect(item.letter).to eq(nil)
      expect(second_item.letter).to eq('b')
      third_item = Item.create
      user.items << third_item # pick up a third item
      expect(third_item.letter).to eq('a')
    end
  end
end
