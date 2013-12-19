require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'
ActiveRecord::Base.logger = Logger.new(STDOUT)

# configures the database
require_relative 'config/environments'

# models included
require_relative 'models/post'
require_relative 'models/user'
require_relative 'models/comment'

#
enable :sessions

set :environment, :development

get '/' do 
  @users = User.all
  @posts = Post.all
  p @posts
  erb :index
end

get '/post/:id' do 
  id = params[:id].to_i
  @post = Post.find(id)
  p "ID: #{id}"
  p params
  p @post
  erb :show
end

get '/post/:id/edit' do 
  id = params[:id].to_i
  @post = Post.find(id)
  p "ID: #{id}"
  p params
  p @post
  erb :edit
end

post '/update' do
  id = params[:id].to_i 
  post = Post.find(id)

  post.title = params[:title]
  post.body = params[:body]
  post.save!
  redirect "/"
end

post '/delete/:id' do 
  id = params[:id]
  Post.delete(id)
  redirect "/"
end

post '/create' do 
  title = params[:title]
  body = params[:body]
  user_id = params[:user_id].to_i
  # create_new_post(title, body)
  user = User.find(user_id)
  Post.create(title: title, body: body, user: user)
  redirect '/'
end

# Ethan's HTTP method handler
post '/new_user' do
  
  first_name = params[:first_name]
  last_name = params[:last_name]
  username = params[:username].downcase
  bio = params[:bio]
  user = User.create(first_name: first_name, last_name: last_name, username: username, bio: bio)
  
  # Matt P.'s Way

  # user = User.new
  # user.first_name = params[:first_name]
  # user.last_name = params[:last_name]
  # user.username = params[:username].downcase
  # user.bio = params[:bio]
  # user.save!

  # Yet another Way:

  # user = {}
  # user[:first_name] = params[:first_name]
  # user[:last_name] = params[:last_name]
  # user[:username] = params[:username].downcase
  # user[:bio] = params[:bio]
  # User.create(user)


  redirect '/'
end