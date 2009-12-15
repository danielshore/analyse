class LinkController < ApplicationController
  def index
    output=""
    links=Hash.new
    if params[:q]=="ZZZ"
      $q=nil
      params[:q]=nil
    end
    if $q!=nil
      output<<"Filter of #{$q} - <a href='/link?q=ZZZ'>Remove</a><br><br>"
      params[:q]=$q
    end
    if params[:q]!=nil
      output<<"Filter of #{$q} - <a href='/link?q=ZZZ'>Remove</a><br><br>"
      query="and text like '%#{params[:q]}%'"
      $q=params[:q]
    else
      query=""
      $q=nil
    end
    
    Link.find(:all,:select=>"*,count(distinct username) as c,id",:group => :url,:order=>"count(distinct username) desc",:limit=>100,:conditions=>"url not in (select url from linkexcludes) AND username not in (select username from blacklists) and posted>'#{(Time.now-60*60*6).strftime('%Y-%m-%d %H:%M:%S')}' #{query}").each do |l|

      output<<"<b>"<<l.title<<"</b><br>"
      output<<"<a href='#{l.url}'>#{l.url}</a><br><a href='/link/remove?id=#{l.id}'>Remove</a><br><a href='/link/spam?id=#{l.id}'>Spam</a><br>"
      output<<l.c<<"<br>"
      
      output<<"<hr>"
      #links[l[0]]=l[1]
    end
    #links=links.sort {|a,b| b[1]<=>a[1]}
    #links.each do |l|
      
    render :text => output
  end
  
  def tweet_search
    @search_term=params['search']
    @client_account=params['account']
    
    
    if @search_term!=nil && @client_account!=nil
      query="1=1"
      @search_term.split(" ").each do |q|
        query<<" AND text like '%#{q}%'"
      end
      @tweets=Tweet.find(:all,:conditions=>"#{query} and search=0 and client_account='#{@client_account}' and follower=1",:order=>"created_at desc",:limit=>250)
    else 
      @tweets=nil
    end
    @accounts=Tweet.find(:all,:select=>"distinct client_account")
    render :partial => "tweets" 
  end
  
  def recent_links
    @client_account=params['account']
    
    
    if @client_account!=nil
      @links=Link.find(:all,:conditions=>"client_account='#{@client_account}' and follower=1",:order=>"posted desc",:limit=>250)
    else 
      @links=nil
    end
    @accounts=Tweet.find(:all,:select=>"distinct client_account")
    render :partial => "recent_links" 
  end
  
  def remove
    url=Link.find(params[:id]).url
    le=Linkexclude.find(:first,:conditions=>"url='#{url}'")
    if le==nil
      le=Linkexclude.new
    end
    le.url=url
    le.save
    index
  end
  
  def spam
    url=Link.find(params[:id]).url
    le=Linkexclude.find(:first,:conditions=>"url='#{url}'")
    if le==nil
      le=Linkexclude.new
    end
    le.url=url
    le.save
    Link.find(:all,:conditions=>"url='#{url}'").each do |l|
      if Blacklist.find(:first,:conditions=>"username='#{l.username}'")==nil
        b=Blacklist.new
        b.username=l.username
        b.save
      end
    end
    index
  end
  
end