require 'rubygems'
require 'hpricot'
require 'twitter'
require 'mysql'
require 'active_record'
require 'open-uri'
require 'net/http'
require "yaml"
require "timeout"


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
title=""
url=""
puts "Finding links"
if 1==1
Tweet.find(:all,:conditions=>"text like '%http%' and tweet_id not in (select tweet_id from links)",:order=>"created_at desc",:limit=>5000).each do |t|
  #puts t.text
  puts t.created_at
  t.text.split(" ").each do |text|
    if text.include?("http")
      #puts text.strip.gsub("(","").gsub(")","")
      if text.rindex('.')==text.length-1
        text=text.chomp
      end
      l=Link.new
      l.follower=t.follower
      l.title=title.strip.gsub("\t","")
      l.posted=t.created_at
      l.username=t.screen_name
      l.short_url=text
      l.tweet_id=t.tweet_id
      l.client_account=t.client_account
      l.text=t.text
      l.save
      puts "Added"
    end   
  end
end
end
Link.connection.execute("select short_url from (select short_url,count(distinct username) as c from links where url is null group by short_url order by count(distinct username) desc) as testing where c>1").each do |l|
  puts l[0]
  responded=0
  begin
    Timeout.timeout 10 do  
     
      url = Net::HTTP.get_response(URI.parse(l[0].strip.gsub("(","").gsub(")",""))).to_hash['location'].to_s
      if url==""
        url=l[0]
      end
      puts url
      doc=Hpricot(open(url))
      #puts doc
      title=(doc/"title").inner_text
      puts title
      responded=1
      Link.update_all({:title=>title},"short_url='#{l[0]}'")
      Link.update_all({:url=>url},"short_url='#{l[0]}'")
      #Link.update_all(:url=>url,"short_url=test")
      #Link.update_all (:url => url,"short_url = '#{l[0]}'")
      
    end
  rescue Timeout::Error
    puts "Timed out"
    responded=0
  rescue Exception=>e
    puts "Error: "+e
    responded=0
  end

  
  
end