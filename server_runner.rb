require 'bundler/setup'
Bundler.require(:default)

Dir['lib/**/*.rb'].each { |f| require_relative f }
Dir['lib/*.rb'].each { |f| require_relative f }

MyServer.new.listen
