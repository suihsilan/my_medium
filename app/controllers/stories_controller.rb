class StoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_story, only: [:edit, :update, :destroy]
  
  def index
    @stories = current_user.stories.order(created_at: :desc)
  end

  def new
    @story = current_user.stories.new
  end

  def create
    @story = current_user.stories.new(story_params)
    # @story.status = 'published' if params[:publish]
    @story.publish! if params[:publish]

    if @story.save
      if params[:publish]
        redirect_to stories_path, notice: '已成功發布一則故事！'
      else
        redirect_to edit_story_path(@story), notice: '故事已儲存！'
      end
    else
      render :new
    end
  end

  def edit
    # @story = Story.find(params[:id])
    #  @story = Story.friendly.find(params[:slug])
  end

  def update
    @story = Story.friendly.find(params[:slug])
    # @story = Story.find(params[:id])
    if @story.update(story_params)
      case
      when params[:publish]
        @story.publish!
        redirect_to stories_path, notice: '故事已發佈！'
      when params[:unpublish]
        @story.unpublish!
        redirect_to stories_path, notice: '故事已下架！'
      else
        redirect_to edit_story_path(@story), notice: '故事已儲存草稿'
      end
    else
      render :edit
    end
  end

  def destroy
    @story.destroy
    # @story.update(deleted_at: Time.now)
    redirect_to stories_path, notice: '該篇故事已經刪除！'
  end
 
  private
  def find_story
      @story = current_user.stories.friendly.find(params[:slug])
  end
  
  def story_params
    params.require(:story).permit(:title, :content)
  end
end
