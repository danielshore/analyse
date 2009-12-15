require 'rubygems'  
require 'hpricot'  
require 'open-uri'  
require 'mysql'
require 'rubygems'  
require 'active_record'
require 'twitter'

ActiveRecord::Base.establish_connection(  
:adapter=> 'mysql',
:host=> 'db1.c0om0daowkw7.us-east-1.rds.amazonaws.com',
:username=> 'admin',
:password=> 'secret',
:database=> 'db1',
:port=> 3306)

class Relationship < ActiveRecord::Base   
end

class Twitter_user < ActiveRecord::Base   
end

class Follow < ActiveRecord::Base   
end



httpauth = Twitter::HTTPAuth.new('ldn','footba1l2')
client = Twitter::Base.new(httpauth)

Twitter::Search.new('filter:links').geocode(51,0,"50km").per_page(200).each do |r| 
  puts r.text
  puts r.created_at
end