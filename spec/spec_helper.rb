require 'rubygems'
require 'bundler/setup'

require 'rspec'

require 'shortest_path' # and any other gems you need

Dir[File.expand_path(File.join(File.dirname(__FILE__),'support','**','*.rb'))].each {|f| require f}

RSpec.configure do |config|
  # some (optional) config here
end
