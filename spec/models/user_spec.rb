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
      let(:monster){ Monster.create(slug: :goblin, row: 1, col: 2, room: room) }
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
        expect{ subject }.to change{ user.health }.by( -monster.damage )
      end
    end
  end
end
