require 'rubygems'  
require 'hpricot'  
require 'open-uri'  
require 'mysql'
require 'rubygems'  
require 'active_record'
require 'twitter'

db=2

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
    begin  
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
      u.last_tweet=client.user_timeline(:id=>ud.id).first.created_at
      u.save
    rescue =>e
      puts e
    end
   
  else
    begin
      u.last_tweet=client.user_timeline(:id=>user_id).first.created_at
      u.save
    rescue =>e
      puts e
    end
  end
  return u
end

#ids=[]
#Twitter_user.find(:all,:conditions=>"last_tweet is null",:select=>"user_id").each do |t|
#  ids<<t.user_id
#end

ids=[]
Twitter_user.find(:all,:conditions=>"last_tweet<'2009-9-30 16:56:16'",:select=>"user_id").each do |t|
  ids<<t.user_id
end

httpauth = Twitter::HTTPAuth.new('ldn','footba1l2')
client = Twitter::Base.new(httpauth)

bs=client.friend_ids
bs.each do |f|
  if ids.include?(f.to_i)
    begin
      puts "Dropping #{f}"
      client.friendship_destroy(f.to_i)
    rescue =>e
      puts e
    end
      
    #readUser(f,client)
  end
end

