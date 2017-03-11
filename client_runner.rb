Dir['lib/**/*.rb'].each { |f| require f }

MyClient.new(ARGV[0]).start
