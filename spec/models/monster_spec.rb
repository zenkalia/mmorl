require 'spec_helper'

describe Monster do
  let(:room){ Room.create( fixtures: '.' * 1600 ) }
  let(:user){ User.create( room: room, row: 1, col: 1, email: 'chilldude420@geemail.com', password: 'tupac_lives' ) }
  let(:monster){ Monster.create( room: room, row: 3, col: 1, slug: 'goblin', target: user ) }
  describe '.move_toward_target' do
    subject{ monster.move_toward_target! }

    it 'changes your row' do
      expect{ subject }.to change{ monster.row }.from(3).to(2)
    end
  end
end
