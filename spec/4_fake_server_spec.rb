require 'spec_helper'

describe RobotArena do
  let!(:fake_server) do
    ShamRack.at("robot-depot.herokuapp.com").sinatra do
      set :show_exceptions, false
      set :raise_errors, true
      set :robots, []

      helpers do
        def add_robot(new_robot)
          new_robot['grade'] = %w(plastic steel).index(new_robot['material'])*10+%w(small medium large).index(new_robot['size'])
          settings.robots << new_robot
          new_robot
        end
      end

      post '/robots' do
        payload = JSON.parse(request.body.read)
        add_robot(payload).to_json
      end

      get '/robots/:id' do
        robot = settings.robots.find {|r| r['name'] == params[:id] }
        if robot
          robot.to_json
        else
          halt 404
        end
      end
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

    context "when your robot is hella cool compared to the others" do
      let(:your_robot) { {material: 'steel', size: 'large', name: 'Big_Mutha'} }

      it "will return your robot, the victor" do
        expect(fight.name).to eq('Big_Mutha')
      end
    end

    context "when your robot is hella lame compared to the others" do
      let(:your_robot) { {material: 'plastic', size: 'small', name: 'Big_Mutha'} }

      it "will not return your robot, the loser" do
        expect(fight.name).not_to eq('Big_Mutha')
      end
    end

    context 'when the robots are already in the depot' do
      before do
        fight
      end

      it 'does not store new robots' do
        expect { fight }.not_to change { fake_server.settings.robots.count }
      end
    end
  end
end
