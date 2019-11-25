class TweetsController < ApplicationController

  get '/tweets' do
    if logged_in?
      @tweets = Tweet.all
      erb :'/tweets/index'
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'/tweets/new'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    if logged_in? && params[:tweet][:content] != ""
      @tweet = Tweet.create(params[:tweet])
      @tweet.user = current_user
      @tweet.save
      flash[:message] = "Tweet successfully created."
      redirect "/tweets/#{@tweet.id}"
    elsif logged_in? && params[:tweet][:content] == ""
      flash[:message] = "Please enter content to post a tweet."
      redirect "/tweets/new"
    else
      redirect "/login"
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by_id(params[:id])
      erb :'/tweets/show'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && @tweet.user == current_user
      erb :'/tweets/edit'
    elsif logged_in? && @tweet.user != current_user
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by_id(params[:id])
    if params[:tweet][:content] != ""
      @tweet.update(params[:tweet])
      flash[:message] = "Tweet successfully updated."
      redirect "/tweets/#{@tweet.id}"
    elsif params[:tweet][:content] == ""
      flash[:message] = "Please enter content to update tweet."
      redirect "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by_id(params[:id])
    if logged_in? && @tweet.user == current_user
      @tweet.delete
      flash[:message] = "Tweet successfully deleted."
      redirect "/tweets"
    else
      redirect "/login"
    end
  end

end
