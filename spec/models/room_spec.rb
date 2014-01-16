require 'spec_helper'

describe Room do
  let(:room){ Room.create( fixtures: '..#' + '.' * 1597 ) }
  let(:user_row){ 1 }
  let(:user_col){ 4 }
  let(:user){ User.create( room: room, row: user_row, col: user_col, email: 'chilldude420@geemail.com', password: 'tupac_lives' ) }
  let(:row){ 1 }
  let(:col){ 1 }

  describe '.can_see?' do
    subject{ room.can_see?(row, col, user) }

    it 'does not let you see through walls' do
      expect(subject).to be_false
    end

    context 'you can kind of see around corners' do
      let(:user_row){ 2 }
      it 'lets you see' do
        expect(subject).to be_true
      end
    end

    context 'stright shots are tight' do
      let(:col){ 40 }
      it 'lets you see' do
        expect(subject).to be_true
      end
    end
  end
end
