class TopicsController < ApplicationController
  before_action :set_topic, only: %i[show edit update]
  def index
    @pagy, @topics = pagy(Topic.all, items: 10)
  end

  def show
    @posts = Post.new
    @tags = Tag.all
  end

  def new
    @topic = Topic.new
  end

  def edit; end

  def create
    @topic = Topic.new(topic_params)
    respond_to do |format|
      if @topic.save
        format.html { redirect_to @topic, notice: 'Topic was successfully created.'}
        format.json { render :show, status: :created, location: @topic }
      else
        format.html { render :new }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @topic.update(topic_params)
        format.html { redirect_to @topic, notice: 'Topic was successfully updated.'}
        format.json { render :show, status: :ok, location: @topic }
      else
        format.html { render :edit }
        format.json { render json: @topic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

    respond_to do |format|
      @topic = Topic.find(params[:id])
      @topic.destroy
      format.html { redirect_to topics_url, notice: 'Topic was successfully destroyed.'}
      format.json { head :no_content }
    rescue ActiveRecord::RecordNotFound
      format.html{ redirect_to topics_url,  notice: 'Record not found.' }
    end
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def topic_params
    params.require(:topic).permit(:title)
  end

end
