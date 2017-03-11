Dir['lib/**/*.rb'].each { |f| require f }

MyServer.new.listen
