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
slug=client.lists.lists[0].slug


accounts="LondonShopping,London2012,MayorOfLondon,koogaloo_com,JamesonCultFilm,LondonNet,LDNoffers,HaveFunDoGood,tiredoflondon,LondonForLondon,londoneating,TimeOutLondon,Whereiskoogaloo,Spoonfed,VLbusiness,we_are_london,FairtradeLondon,planbbrixton,southbanklondon,MuseumofLondon,legionoldstreet,ianvisits,londontonight,LondonMarriott,TheNotebook,lastminute_com,se1,visitlondonweb,londonart,visit_london,LDNTwestival,QypeLondon,LondonSearch,digitalweek,tent_london,LondonCityAir,londonweather,TheatreTickets,forbiddenlondon,BBCLondon949,Londonist,ImLondonBridge,collectiveldn,squaremealvande,pingpongdimsum,UK_London,HeartLondon,londonnewsnow,LondonersList,londonwestend,LondonShopping,southbankcentre,DaysOutInLondon,ArtsLondon,VCCP,HowToEnjoyCoUk,LondonClubs,LondonLyric,VinoInLondon,PrideLondon,eOfficeLondon,designlondon,roundhouseLDN,TimeOutBigSmoke,ViewLondon,standardnews,pete_walter,gluelondon,anniemole,socialising,MoMoLondon,LON_unlike,matterlondon,toptable,OgilvyPRLondon,ICALondon,iknitlondon,happn_in_london,thatlondon,london_news,NCVO,breakingldnnews,tastelondon,BarbicanCentre,bbhlondon,ClimateCampLdn,TimeOutEatDrink,LondonFashionWk,usembassylondon,tweetalondoncab,LO2012,MagnersUK,lewiswebb,Selfridges,JazCummins,L_D_F,wxlondon,visitengland,LibertyLndnGirl"

accounts.split(",").sort_by{rand}.each do |username|
 source_id=client.user_timeline(:screen_name=>username).first.user.id
 client.list_add_member("LDN", slug, source_id)
 
end
