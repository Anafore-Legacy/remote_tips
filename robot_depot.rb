require 'json'

class RobotDepot < Sinatra::Application
  set :database, nil

  helpers do
    def validate(robot)
      %w(plastic steel).include?(params[:material]) &&
        %w(small medium large).include?(params[:size])
    end

    def add_robot(new_robot)
      new_robot['grade'] = rand
      settings.database << new_robot
      new_robot
    end
  end

  post '/robots' do
    payload = JSON.parse(request.body.read)
    add_robot(payload).to_json
  end

  get '/robots/:id' do
    robot = settings.database.find {|r| r['name'] == params[:id] }
    if robot
      robot.to_json
    else
      halt 404
    end
  end

  delete '/robots/:id' do
    index = settings.database.find_index {|r| r['name'] == params[:id] }
    if index
      settings.database.delete_at(index).to_json
    else
      halt 404
    end
  end
end