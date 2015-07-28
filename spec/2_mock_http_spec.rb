require 'spec_helper'
require 'webmock/rspec'

describe RobotArena do
  def arena_for(*robots)
    RobotArena.new.tap do |arena|
      robots.each {|robot| arena.enter(robot) }
    end
  end

  around do |ex|
    VCR.turned_off do
      WebMock.disable_net_connect!
      ex.run
      WebMock.allow_net_connect!
    end
  end

  describe 'fight' do
    let(:sissy) { {material: 'plastic', size: 'medium', name: 'sissy'} }
    let(:your_robot) { sissy.merge(material: 'steel', name: 'Big_Mutha') }

    before do
      #No existing robots
      stub_request(:get, /robot-depot.herokuapp.com\/robots\/.+/)
        .to_return(status: [404, 'Not found!'])

      #The two robots we create
      stub_request(:post, 'robot-depot.herokuapp.com/robots')
        .to_return(body: sissy.merge(grade: 0).to_json)
        .then.to_return(body: your_robot.merge(grade: 10).to_json)
    end

    def fight
      arena = RobotArena.new
      arena.enter(sissy)
      arena.enter(your_robot)
      arena.fight
    end

    it 'will return the better graded robot' do
      expect(fight.name).to eq('Big_Mutha')
    end
  end
end
