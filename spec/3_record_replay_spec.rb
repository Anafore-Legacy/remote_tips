require 'spec_helper'

describe RobotArena, :vcr do
  def arena_for(*robots)
    RobotArena.new.tap do |arena|
      robots.each {|robot| arena.enter(robot) }
    end
  end

  describe 'fight' do
    let(:sissy) { {material: 'plastic', size: 'medium', name: 'sissy'} }
    let(:toughie) { sissy.merge(material: 'steel', name: 'toughie') }
    let(:your_robot) { toughie.merge(name: 'Big_Mutha') }
    let(:arena) { arena_for(sissy,toughie,your_robot) }

    after do
      arena.delete_all
    end

    def fight
      arena.fight
    end

    it 'will return one of the passed robot names' do
      expect(%w(sissy toughie Big_Mutha)).to include(fight.name)
    end
  end
end
