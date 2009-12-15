require 'rubygems'  
require 'hpricot'  
require 'open-uri'  
require 'mysql'
require 'rubygems'  
require 'active_record'
require 'twitter'

db=1

if db==1
ActiveRecord::Base.establish_connection(  
:adapter  => 'mysql',   
:database => 'danielshore_rooms_development',   
:username => 'danielshore',   
:password => 'eik5fei3thah',   
:host     => 'sqlreadwrite.brightbox.net')
end

if db==2
ActiveRecord::Base.establish_connection(  
:adapter=> 'mysql',
:host=> '127.0.0.1',
:username=> 'danielshore',
:password=> 'eik5fei3thah',
:database=> 'danielshore_rooms_development',
:port=> 3307)
end

class Relationship < ActiveRecord::Base   
end

class Twitter_user < ActiveRecord::Base   
end

class Follow < ActiveRecord::Base   
end

def readUser(user_id,client)
  puts "Loading user"
  u=Twitter_user.find(:first,:conditions=>"user_id=#{user_id}")
  if u==nil
    ud=client.user(user_id)
    u=Twitter_user.new
    u.user_id=user_id
    u.screen_name=ud.screen_name
    u.user_created=ud.created_at
    u.user_description=ud.description
    u.favourites_count=ud.favourites_count
    u.followers_count=ud.followers_count
    u.following=ud.following
    u.friends_count=ud.friends_count
    u.geo_enabled=ud.geo_enabled
    u.user_id=ud.id
    u.location=ud.location
    u.name=ud.name
    u.notifications=ud.notifications
    u.protected=ud.protected
    u.profile_image_url=ud.profile_image_url
    u.screen_name=ud.screen_name
    u.statuses_count=ud.statuses_count
    u.time_zone=ud.time_zone
    u.url=ud.url
    u.utc_offset=ud.utc_offset
    u.verified=ud.verified
    u.updated=Time.now
    #begin
    #  u.last_tweet=client.user_timeline(:id=>ud.id).first.created_at
    #rescue =>e
    #  puts e
    #end
    u.save
  end
  return u
end


httpauth = Twitter::HTTPAuth.new('ldn','footba1l2')
client = Twitter::Base.new(httpauth)

ids=[]
Twitter_user.find(:all,:select=>"user_id").each do |u|
  ids<<u.user_id
end
if ARGV[0]!=nil
  account=ARGV[0]
else
  account="AbsolutUK"
end
source_id=client.user_timeline(:screen_name=>account).first.user.id
puts source_id

#Load follower information
if 1==1
  fs=client.follower_ids(:screen_name=>account)
  #update_relationship(source_id,client)
  fs.each do |follower|
    puts follower
    if !ids.include?(follower.to_i)
      u=readUser(follower,client)
      ids<<u.user_id
    end
  end
  fs=client.friend_ids(:screen_name=>account)
  fs.each do |follower|
    puts follower
    if !ids.include?(follower.to_i)
      u=readUser(follower,client)
      ids<<u.user_id
    end
  end
end