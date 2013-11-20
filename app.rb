require 'sinatra'
require 'mysql2'

# configure
set :public_folder, File.dirname(__FILE__) + '/assets'


client = Mysql2::Client.new(host: "localhost", username: "root", password: "", database: "beer")


get '/' do
  haml :index
end
