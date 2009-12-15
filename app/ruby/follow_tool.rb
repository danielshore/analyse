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

def commas(x)
  str = x.to_s.reverse
  str.gsub!("([0-9]{3})","\\1,")
  str.gsub(",$","").reverse
end

def update_relationship(source_id,client)
  puts "Updating the relationship"
  begin
    r=Relationship.find(:first,:conditions=>"source_id=#{source_id}")
    if r==nil
      r=Relationship.new
    end
    r.source_id=source_id
    r.source_username=client.user(source_id).screen_name
    r.updated=Time.now
    r.followers=client.follower_ids(:id=>r.source_id)
    r.following=client.friend_ids(:id=>r.source_id)
    r.save
  rescue => e
    puts "Error: #{e}"
  end
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

accounts="koogaloo_com,JamesonCultFilm,LondonNet,LDNoffers,HaveFunDoGood,tiredoflondon,LondonForLondon,londoneating,TimeOutLondon,Whereiskoogaloo,Spoonfed,VLbusiness,we_are_london,FairtradeLondon,planbbrixton,southbanklondon,MuseumofLondon,legionoldstreet,ianvisits,londontonight,LondonMarriott,TheNotebook,lastminute_com,se1,visitlondonweb,londonart,visit_london,LDNTwestival,QypeLondon,LondonSearch,digitalweek,tent_london,LondonCityAir,londonweather,TheatreTickets,forbiddenlondon,BBCLondon949,Londonist,ImLondonBridge,collectiveldn,squaremealvande,pingpongdimsum,UK_London,HeartLondon,londonnewsnow,LondonersList,londonwestend,LondonShopping,southbankcentre,DaysOutInLondon,ArtsLondon,VCCP,HowToEnjoyCoUk,LondonClubs,LondonLyric,VinoInLondon,PrideLondon,eOfficeLondon,designlondon,roundhouseLDN,TimeOutBigSmoke,ViewLondon,standardnews,pete_walter,gluelondon,anniemole,socialising,MoMoLondon,LON_unlike,matterlondon,toptable,OgilvyPRLondon,ICALondon,iknitlondon,happn_in_london,thatlondon,london_news,NCVO,breakingldnnews,tastelondon,BarbicanCentre,bbhlondon,ClimateCampLdn,TimeOutEatDrink,LondonFashionWk,usembassylondon,tweetalondoncab,LO2012,MagnersUK,lewiswebb,Selfridges,JazCummins,L_D_F,wxlondon,visitengland,LibertyLndnGirl,RSAEvents,ShortlistMag,KOKOLondon,LibertyLondon,LondonU,BBCTravelAlert,DomesticSluts,thelondonpaper,nutritionist,London2012team,londonsymphony,redpages,secretcinema,LondonPrint,TBWALONDON,events_london,BFI,lfpress,BNILondon,Media_Trust,benrmatthews,guideguardian,Twentertain_Me,hwallop,inbritain,towerbridge,Marthalanefox,RobinGrant,vikkichowney,MsMarmitelover,gatc,Garminos,NationalTheatre,litmanlive,eatlikeagirl,Bash,Fashion_Monitor,alexispetridis,BitchBuzz,VisitBritain,guardianfood,Smithhotels,nesta_uk,NaiveLondonGirl,o2sbe,The_O2,NewMediaAge,LloydDavis,ObsMusicMonthly,prgeek,WiredUK,Drapers,TimeOutFilm,badjournalism,danlondon,stevebridger,kate_day,uktraveloffers,MarkBorkowski,V_and_A,TelegraphTravel,Nero,Whatleydude,holymolydotcom,DarenBBC,IABUK,LondonElek,hermioneway,queenofshops,Film4,Rubber_Republic,media_guardian,RuthBarnett,tim,PrincesTrust,Hitwise_UK,marieclaireuk,dominiccampbell,roughtradeshops,UKTI,GoodPubGuide,British_Airways,britishlibrary,arusbridger,pressgazette,BBCNewsnight,CosmopolitanUK,emilybell,brands4london,DMiliband,digitalbritain,TheWordMagazine,katebevan,thestage,shanerichmond,vogue_london,AmnestyUK,EdMilibandMP,HolyMolyNews,rorysutherland,LiveNationUK,britishmuseum,indiaknight"
#accounts="JamesonCultFilm,tiredoflondon"
#accounts="bindiyayagnik"
#LondonNet,
ids=[]
Twitter_user.find(:all,:select=>"user_id",:conditions=>"").each do |u|
  ids<<u.user_id
end

non_london_ids=[]
Twitter_user.find(:all,:select=>"user_id",:conditions=>"location is null or last_tweet is not null").each do |u|
  non_london_ids<<u.user_id
end

follow_exclude=[]
Follow.find(:all,:select=>"twitter_id",:conditions=>"account='LDN'").each do |u|
  follow_exclude<<u.twitter_id
end

as=client.follower_ids
as.each do |f|
  follow_exclude<<f.to_i
end

bs=client.friend_ids
bs.each do |f|
  follow_exclude<<f.to_i
end

gap=as.size-bs.size-100
puts "Gap: #{gap}"
follow_count=0
puts "Starting targets"
targets=Hash.new
#targets=[]
counter=0
accounts.split(",").sort_by{rand}.each do |username|
  puts "Target"
  puts username
  begin
    fs=client.follower_ids(:screen_name=>username)
    fs.each do |follower|
      #if !follow_exclude.include?(follower.to_i) && !ids.include?(follower.to_i)
      #puts follower
      if targets[follower.to_i]!=nil
        targets[follower.to_i]=targets[follower.to_i]+1
      else
        targets[follower.to_i]=1
      end
      
    #end
    end
    counter=counter+1
    if counter>400
      break
    end
  rescue
  end
end
puts "Targets ended"
targets=targets.sort {|a,b| b[1]<=>a[1]}

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

targets.each do |follower|
    
    #if !non_london_ids.include?(follower[0].to_i) && !follow_exclude.include?(follower[0].to_i)
    #if !ids.include?(follower[0].to_i) && 
    if !follow_exclude.include?(follower[0].to_i) && !non_london_ids.include?(follower[0].to_i)
      begin
        u=readUser(follower[0].to_i,client)
      rescue =>e
        puts e
        if e.to_s.include?("404") || e.to_s.include?("Unauthorized")
          u=Twitter_user.new
          u.user_id=follower[0].to_i
          u.save
          u=nil
        end     
      end
      ids<<follower[0].to_i
    else
      #u=Twitter_user.find(:first,:conditions=>"user_id=#{follower[0]}")  
    end
    if u!=nil 
      puts follower
      #puts "U not nil"
      #puts u.user_id
      if !follow_exclude.include?(u.user_id.to_i)
        #puts "Follow candidate"
        begin
          #puts u.location
          if u.location.include?("London") || u.location.include?("51")
            if u.last_tweet==nil
              u.last_tweet=client.user_timeline(:id=>u.user_id).first.created_at
              u.save
            end
            if u.last_tweet>Time.now-60*60*24*3 && u.statuses_count>20 and u.followers_count>10
              puts "Tweeted in last day and is from London"
              puts u.screen_name
              begin
                f=Follow.new
                f.account="LDN"
                f.twitter_id=u.user_id
                f.date_friended=Time.now
                client.friendship_create(u.user_id)
                f.save
                puts "Followed #{u.user_id}"
                follow_exclude<<u.user_id
                follow_count=follow_count+1
                if follow_count>gap
                  exit
                end
              rescue => e
                puts e
                if e.to_s.include?("follow")
                  exit
                end
                
                
                
                
              end
            end
          end
        
        rescue => e
          puts e
        end
      end  
    end
  
end

