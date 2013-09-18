# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/../spec_helper'

describe Comment do
  fixtures :comments, :users, :assets
  context "validation" do 
    it "should be valid when made by user" do
      comments(:valid_comment_on_asset_by_user).should be_valid
    end
  
    it "should be valid when made by guest" do
      comments(:valid_comment_on_asset_by_guest).should be_valid
    end
  
    it "should be valid even if spam" do
      comments(:spam_comment_on_asset_by_guest).should be_valid
    end
    
    it "should be valid without a user_id" do 
      comments(:comment_on_update).should be_valid
    end
  end
  
  context "saving" do
    
    it "should save with just a body and a commentable" do 
      comment = assets(:valid_mp3).comments.new(:body => 'test')
      comment.save.should be_true      
    end
    
    it "should store user_id when commenting on an asset" do
      comment = assets(:valid_mp3).comments.new(:body => 'test')
      comment.save.should be_true    
      comment.user_id.should == assets(:valid_mp3).user_id
    end
    
    it "should not save a dupe (same content/ip)" do
      body = comments(:valid_comment_on_asset_by_user).body
      ip = comments(:valid_comment_on_asset_by_user).remote_ip
      comment2 = Comment.new(:body => body, :remote_ip => ip, :commentable_type => 'Asset', :commentable_id => '1')
      comment2.save.should be_false
    end
    
    it "should deliver a mail to the user if it was an asset comment" do 
      comment = assets(:valid_mp3).comments.new(:body => 'test')
      expect {comment.save}.to change{ActionMailer::Base.deliveries.size}.by(1)
    end
    
    it "should not be delivering mail for non-asset comments" do 
      comment = Comment.new(:body => "awesome blog post", :commentable_type => 'Update', :commentable_id => 1)
      expect {comment.save}.not_to change{ActionMailer::Base.deliveries.size}
      
    end
  end
  
  context "private and guests" do 
    
  end
  
  context "spam" do 
    
  end
end

