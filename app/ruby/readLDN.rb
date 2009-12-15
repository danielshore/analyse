require 'rubygems'
require 'hpricot'
require 'twitter'
require 'mysql'
require 'active_record'
require 'open-uri'
require 'net/http'
require "yaml"

db=3

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

if db==3
ActiveRecord::Base.establish_connection(  
:adapter=> 'mysql',
:host=> 'db1.c0om0daowkw7.us-east-1.rds.amazonaws.com',
:username=> 'admin',
:password=> 'secret',
:database=> 'db1',
:port=> 3306)
end




class Tweet < ActiveRecord::Base   
end

class Link < ActiveRecord::Base   
end

class Followerlog < ActiveRecord::Base   
end

def readTweet(tweet1,search,followers,c)
  puts "Reading tweet"
  t=Tweet.new()
  #puts tweet1.inspect
  #puts tweet.id
  t.tweet_id=tweet1.id
  t.created_at=tweet1.created_at
  t.geo=tweet1.geo
  t.in_reply_to_screen_name=tweet1.in_reply_to_screen_name
  t.in_reply_to_status_id=tweet1.in_reply_to_status_id
  t.in_reply_to_user_id=tweet1.in_reply_to_user_id
  t.source=tweet1.source
  t.text=tweet1.text
  if t.text[0,1]=="@"
    t.message_type="Message"
  else
    if (t.text.include?("RT ") || t.text.include?("RT:") || (t.text.include?("via") && t.text.include?("@")))
      t.message_type="Retweet"
    else
      t.message_type="Tweet"
    end
  end
  t.truncated=tweet1.truncated
  #t.user=tweet1.user
  t.user_created=tweet1.user.created_at
  t.created_at=tweet1.created_at
  t.user_description=tweet1.user.description
  t.favourites_count=tweet1.user.favourites_count
  t.followers_count=tweet1.user.followers_count
  t.following=tweet1.user.following
  t.friends_count=tweet1.user.friends_count
  t.geo_enabled=tweet1.user.geo_enabled
  t.user_id=tweet1.user.id
  if followers.include?(t.user_id)
      t.follower=1
  else
    t.follower=0
  end
  t.location=tweet1.user.location
  t.name=tweet1.user.name
  t.notifications=tweet1.user.notifications
  t.protected=tweet1.user.protected
  t.profile_image_url=tweet1.user.profile_image_url
  t.screen_name=tweet1.user.screen_name
  t.statuses_count=tweet1.user.statuses_count
  t.time_zone=tweet1.user.time_zone
  t.url=tweet1.user.url
  t.utc_offset=tweet1.user.utc_offset
  t.verified=tweet1.user.verified
  t.client_account=c[1]
  t.search=search
  #puts t.inspect
  t.save
end

if 1==1
auths=[]
auths<<[Twitter::HTTPAuth.new('The_Macallan','s0ngb1rd'),"The_Macallan"]
auths<<[Twitter::HTTPAuth.new('JamesonCultFilm','pa55w0rd'),'JamesonCultFilm']
auths<<[Twitter::HTTPAuth.new('HaveFunDoGood','leapanywhere'),'HaveFunDoGood']
auths<<[Twitter::HTTPAuth.new('LDN','footba1l2'),'LDN']

auths.each do |c|
  begin
    puts c[1]
    client = Twitter::Base.new(c[0])
    followers=[]
    fs=client.follower_ids
    fs.each do |f|
      followers<<f
    end
    puts "Creating follower log"
    f=Followerlog.new;
    f.created_at=Time.now
    f.client_account=c[1]
    f.follower_string=YAML::dump(followers)
    f.save
    ids=[]
    Tweet.find(:all,:select=>"tweet_id",:conditions=>"client_account='#{c[1]}' and search=1",:order=>"created_at desc",:limit=>20000).each do |t|
      ids<<t.tweet_id
    end
    counter=0
    for i in (1..5)
      
      puts i
      client.replies(:page =>i,:count=>200).each do |tweet1| 
        if !ids.include?(tweet1.id)
          readTweet(tweet1,1,followers,c)
          counter=counter+1
        end
      end
      if counter==0 && i==2 && c[1]!="LDN"
        break
      end
    end
    ids=[]
    Tweet.find(:all,:select=>"tweet_id",:conditions=>"client_account='#{c[1]}' and search=0",:order=>"created_at desc",:limit=>20000).each do |t|
      ids<<t.tweet_id
    end
    counter=0
    for i in (1..16)
      
      puts i
      client.friends_timeline(:page =>i,:count=>200).each do |tweet1| 
        if !ids.include?(tweet1.id)
          readTweet(tweet1,0,followers,c)
        end
      end
      if counter==0 && i==2 && c[1]!="LDN"
        break
      end
    end
  rescue Exception=>e
       puts "Error: "+e
   end
end
end

