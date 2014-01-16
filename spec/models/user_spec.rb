require 'spec_helper'

describe User do
  let(:room){ Room.create( fixtures: '.' * 1600 ) }
  let(:user){ User.create( room: room, row: 1, col: 1, email: 'chilldude420@geemail.com', password: 'tupac_lives' ) }
  describe '#move' do
    let(:dr) { 0 }
    let(:dc) { 0 }
    subject{ user.move(dr, dc) }
    describe 'moving to an open space' do
      let(:dc){ 1 }
      it 'changes your column' do
        expect{ subject }.to change{ user.col }.from(1).to(2)
      end
      it 'does not change your row' do
        expect{ subject }.to_not change{ user.row }
      end
    end
    describe 'you should not be able to move off the map' do
      let(:dc){ -1 }
      it 'does not change your column' do
        expect{ subject }.to_not change{ user.col }
      end
      it 'does not change your row' do
        expect{ subject }.to_not change{ user.row }
      end
    end
    describe 'walls should stop you' do
      let(:dr){ 1 }
      let(:room){ Room.create( fixtures: '.' + '#' * 1599 ) }
      it 'does not change your column' do
        expect{ subject }.to_not change{ user.col }
      end
      it 'does not change your row' do
        expect{ subject }.to_not change{ user.row }
      end
    end
    describe 'enemies should get fucked up' do
      let(:dc){ 1 }
      let(:monster){ Monster.create(slug: 'goblin', row: 1, col: 2, room: room) }
      before { monster }
      it 'does not change your column' do
        expect{ subject }.to_not change{ user.col }
      end
      it 'does not change your row' do
        expect{ subject }.to_not change{ user.row }
      end
      it 'causes you to hit the monster' do
        expect{ subject; monster.reload }.to change{ monster.health }.by( -user.damage )
      end
      it 'causes the monster to hit back' do
        expect{ subject; user.reload }.to change{ user.health }.by( -monster.damage )
      end
    end
  end
  describe '.enter' do
    let(:exit_room){ Room.create( fixtures: '.' * 1600 ) }
    let(:portal) { Portal.create( char: '>', entry_room: room, entry_row: user.row, entry_col: user.col,
                                     exit_room: exit_room, exit_row: 3, exit_col: 3 ) }
    before { portal }
    it 'should move you to that room' do
      user.enter
      expect( user.room ).to eq(exit_room)
      expect( user.row ).to eq(portal.exit_row)
      expect( user.col ).to eq(portal.exit_col)
    end
  end
  describe '.pickup' do
    let(:item) { Item.create( slug: :short_sword, room: user.room, row: user.row, col: user.col ) }
    subject { user.pickup }
    it 'takes the item off the floor' do
      expect{ subject; item.reload }.to change{item.room}.to(nil)
    end
    it 'puts the item in the users inventory' do
      expect{ subject; item.reload }.to change{item.user}.to(user)
    end
    context 'with no room' do
      before do
        26.times do
          user.items << Item.create
        end
      end
      it 'leaves the item on the floor' do
        expect{ subject; item.reload }.not_to change{item.room}
      end
      it 'puts the item in the users inventory' do
        expect{ subject; item.reload }.not_to change{item.user}
      end
    end
  end
end
