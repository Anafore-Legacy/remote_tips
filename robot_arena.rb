class RobotArena
  class Robot < Hashie::Mash
    def initialize(robot_json)
      super(JSON.parse(robot_json))
    end

    def delete
      RestClient.delete(resource_url)
    end

    private

    def resource_url
      RobotArena.url_for_path("/robots/#{name}")
    end
  end

  attr_reader :robots

  def self.url_for_path(path)
    URI.parse('http://robot-depot.herokuapp.com').tap {|u| u.path = path }.to_s
  end

  def initialize
    @robots = []
  end

  def enter(robot)
    robot_json = begin
      RestClient.get(self.class.url_for_path("/robots/#{robot[:name]}"))
    rescue RestClient::ResourceNotFound
      RestClient.post(self.class.url_for_path('/robots'), robot.to_json)
    end

    @robots << Robot.new(robot_json)
  end

  def fight
    @robots.sort_by(&:grade).last
  end

  def delete_all
    @robots.each(&:delete)
  end
end