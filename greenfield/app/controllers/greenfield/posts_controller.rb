module Greenfield
  class PostsController < Greenfield::ApplicationController
    include Listens

    before_filter :create_and_edit_unless_post_exists, :only => [:show, :edit]
    before_filter :require_login, :only => [:edit, :update]

    def show
      @post = find_post
      respond_to do |format|
        format.html do
          @page_title = "#{@post.user.display_name} - #{@post.title}"
        end

        format.mp3 do
          listen(@post.asset, register: false)
        end
      end
    end

    def edit
      @post = find_post
      @post.attached_assets.build
    end

    def update
      @post = find_post
      if @post.update_attributes(params[:post])
        redirect_to user_post_path(@post.user, @post)
      else
        render :edit
      end
    end

    protected

    def create_and_edit_unless_post_exists
      if find_asset.user == current_user && !find_asset.greenfield_post
        post = find_asset.build_greenfield_post
        post.save!(:validate => false)
        redirect_to edit_user_post_path(post.user, post)
      end
    end

    def find_post
      find_asset.greenfield_post or raise ActiveRecord::RecordNotFound
    end

    def find_asset
      id = params[:asset_permalink] || params[:post_id] || params[:id]
      @find_asset ||= Asset.find_by!(:permalink => id)
    end

    def require_login
      if find_post.user != current_user
        flash[:message] = "You'll need to login to do that"
        super(find_post.user)
      end
    end
  end
end
