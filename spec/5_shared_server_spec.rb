require 'spec_helper'

require_relative '../robot_depot'

describe RobotArena do
  let(:database) { [] }
  let!(:shared_server) do
    ShamRack.at("robot-depot.herokuapp.com").rackup do
      run RobotDepot
    end.tap do |srv|
      srv.settings.database = database
    end
  end

  after do
    ShamRack.unmount_all
  end

  def arena_for(*robots)
    RobotArena.new.tap do |arena|
      robots.each {|robot| arena.enter(robot) }
    end
  end

  describe 'fight' do
    let(:sissy) { {material: 'plastic', size: 'medium', name: 'sissy'} }
    let(:toughie) { sissy.merge(material: 'steel', name: 'toughie') }
    let(:your_robot) { toughie.merge(name: 'Big_Mutha') }

    def fight
      arena_for(sissy,toughie,your_robot).fight
    end

    it 'returns one of the passed robot names' do
      expect(%w(sissy toughie Big_Mutha)).to include(fight.name)
    end

    it 'stores all the passed robots' do
      expect { fight }.to change { shared_server.settings.database.map {|r| r['name'] } }.from([]).to(%w(sissy toughie Big_Mutha))
    end
  end
end
