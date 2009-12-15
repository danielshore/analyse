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

httpauth = Twitter::HTTPAuth.new('ldn','footba1l2')
client = Twitter::Base.new(httpauth)

followers=[]
fs=client.follower_ids
#fs.each do |f|
  #puts f
#  followers<<f
#end

#15.23
if 1==0
  Follow.find(:all,:order=>"date_friended asc",:conditions=>"").each do |followed|
    if fs.include?(followed.twitter_id)
      puts "Followed back"
      followed.following=1
    else
      puts "Not followed back"
      followed.following=0
    end
    followed.save
  end
end  
i=0
Follow.find(:all,:order=>"date_friended asc",:conditions=>"following=0 and date_unfriended is null").each do |followed|
  begin
    client.friendship_destroy(followed.twitter_id)
    followed.date_unfriended=Date.today
    followed.save
    i=i+1
    puts "Unfollowed "+followed.twitter_id.to_s 
    if i>450
      exit
    end
  rescue => e
    puts e
    if e.to_s.include?("not friends")
      followed.date_unfriended=Date.today
      followed.save
    end
      
  end
  
end
