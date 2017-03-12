require 'bundler/setup'
Bundler.require(:default)
require 'active_support/all'

Dir['lib/**/*.rb'].each { |f| require_relative f }
Dir['lib/*.rb'].each { |f| require_relative f }

fail 'Nickname not given' unless ARGV[0].present?

MyClient.new(ARGV[0]).start
