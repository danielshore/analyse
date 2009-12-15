gem 'oauth'
require 'oauth/consumer'

require 'twitter'

class QuestionController < ApplicationController
  #before_filter :login_required
  #,:only => [:new]
  #skip_before_filter :verify_authenticity_token 
  def authorize(action)
    consumer_key="D4AzEJ8ZUUdVTk63bLFg"
    consumer_secret="0l8avYCVO33T8A4uFyvwgmcYKCk6cRhA6CJZAQ4XNM"
    consumer = OAuth::Consumer.new(
      consumer_key, 
      consumer_secret, 
      {:site => 'http://twitter.com'}
    )
    url = "http://127.0.0.1:3000/question/callback?a=#{action}"
    $request_token = consumer.get_request_token(:oauth_callback => url)
    session[:token] = $request_token.token
    session[:secret] = $request_token.secret
    redirect_to $request_token.authorize_url
  end
  
  def callback
    @access_token = $request_token.get_access_token({:oauth_verifier => params[:oauth_verifier]})
    output=""
    output<<@access_token.params["oauth_token"]
    output<<"<br>"
    output<<@access_token.params["oauth_token_secret"]
    oauth = Twitter::OAuth.new(session[:token],session[:secret])
    oauth.authorize_from_access(@access_token.params["oauth_token"],@access_token.params["oauth_token_secret"])
    $client = Twitter::Base.new(oauth)
    session['screen_name']=@access_token.params["screen_name"]
    redirect_to(:action=>params[:a])
  end
  
  def index
    
    
    
    #@tweets = current_user.twitter.get('/statuses/friends_timeline')  
    @questions=Question.find(:all,:conditions=>"parent_id=0",:order=>"created_at desc")
    @title="Recent Questions"
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  def q
    
    qid=params[:qid]
    @q=Question.find(qid)
    @answers=Question.find(:all,:conditions=>"parent_id=#{@q.id}",:order=>"created_at desc")
    @title=@q.text
    #respond_to do |format|
    #  index.html # index.html.erb
    #end
    respond_to do |format|
      format.html
    end
  end
  
  def add_text
    #$client=nil
    if $client==nil
      session['params']=params
      authorize("add_text")
    else
      
      params=session['params']
      output=""
      output<<"Message from #{session['screen_name']}"
      #fs=$client.follower_ids
      #fs.each do |f|
      #  output<<f.to_s<<"<br>"
      #end
      render :text=>output
    end
  end
  
end