require 'spec_helper'
require 'webmock/rspec'

class Tourney
  attr_accessor :arena

  def initialize(first,second)
    @first = first
    @second = second
    @arena = RobotArena.new
  end

  def fight_in_arena
    arena.enter(@first)
    arena.enter(@second)
    arena.fight
  end
end

describe Tourney do
  describe 'fight_in_arena' do
    let(:sissy) { {material: 'plastic', size: 'medium', name: 'sissy'} }
    let(:your_robot) { sissy.merge(material: 'steel', name: 'Big_Mutha') }
    let(:tourney) { Tourney.new(sissy,your_robot) }

    it 'will return a robot as winner' do
      expect(tourney.arena).to receive(:enter).twice
      expect(tourney.arena).to receive(:fight).and_return(RobotArena::Robot.new(your_robot.to_json))
      expect(tourney.fight_in_arena).to be_a(RobotArena::Robot)
    end
  end
end
