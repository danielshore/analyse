require 'rubygems'
require 'hpricot'
require 'twitter'
require 'mysql'
require 'active_record'
require 'open-uri'
require 'net/http'
require "yaml"
require "timeout"


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

class Tweet < ActiveRecord::Base   
end

class Tweetold < ActiveRecord::Base   
end

class Link < ActiveRecord::Base   
end

class Followerlog < ActiveRecord::Base   
end
title=""
url=""
httpauth = Twitter::HTTPAuth.new('ldn','footba1l2')
client = Twitter::Base.new(httpauth)
puts "Finding winners"
usernames="miss_lucifer|glennyt|melstarrs|clippy|ladyloki"
if 1==1
  #Tweet.find(:all,:conditions=>"text like '%#LDN24%'",:order=>"rand()",:limit=>9).each do |t|
  usernames.split("|").each do |u|
    puts u
    #puts t.screen_name,t.text
    #client.direct_message_create(t.screen_name,"Congratulations you have won a copy of 24 Hours London! Please contact Yannick@prospera.co.uk to arrange delivery.")
    client.direct_message_create(u,"Congratulations you have won tickets to Spinal Tap tomorrow! Please contact mauricio.samayoa@wearesocial.net to arrange.")
    
  end
end