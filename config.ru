require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require './robot_depot'

RobotDepot.settings.database = []
run RobotDepot