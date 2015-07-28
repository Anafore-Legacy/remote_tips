ENV['RACK_ENV'] = 'test'

require 'rubygems'
require 'bundler/setup'
Bundler.require(:default, :test)

require_relative '../robot_arena'

VCR.configure do |c|
  c.cassette_library_dir = "spec/cassettes"
  c.hook_into :webmock
  c.default_cassette_options = { :record => :new_episodes }
  c.configure_rspec_metadata!
end

WebMock.allow_net_connect!