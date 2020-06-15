# frozen_string_literal: true

# CommentsController
class CommentsController < ApplicationController
  before_action :load_post, only: %i[show edit update create user_comment_rating destroy]
  before_action :load_comment, only: %i[show edit update user_comment_rating destroy]
  before_action :load_tags, only: %i[create update]
  authorize_resource only: %i[edit update show destroy]


  def create
    @ratings = @post.ratings.group(:ratings).count
    @rating = Rating.new
    @comment = @post.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      flash[:notice] = 'comment was successfully created'
      redirect_to topic_post_path(@post.topic_id, @post)
    else
      render 'posts/show'
    end
  end

  def destroy
    @comment.destroy
    redirect_to topic_post_path(@post.topic_id, @post)
    flash[:notice] = 'Comment was successfully destroyed'
  end

  def edit;
  end

  def show
    @tags = Tag.new
    @user_comment_ratings = @comment.user_comment_ratings.all
    @comments = @post.comments.all
  end

  def update
    @ratings = @post.ratings.group(:ratings).count
    if @comment.update(comment_params)
      flash[:notice] = 'comment was successfully updated'
      redirect_to topic_post_path(@post.topic_id, @post)
    else
      render 'comments/edit'
    end

  end

  def user_comment_rating
    @user_comment_rating = @comment.user_comment_ratings.new(load_user_comment)
    if @comment.user_comment_ratings.where(user_id: current_user.id).present?
      flash[:alert] = 'User already given rating'
      redirect_to topic_post_comment_path(@post.topic_id, @post, @comment)
    else
      @user_comment_rating.update(user_id: current_user.id)
      flash[:notice] = 'Rating added successfully'
      redirect_to topic_post_comment_path(@post.topic_id, @post, @comment)
    end
  end

  private

  def load_comment
    @comment = @post.comments.find(params[:id] || params[:comment_id])
  end

  def load_post
    @post = Post.find(params[:post_id])
  end

  def load_tags
    @tags = Tag.all
  end

  def load_user_comment
    params.require(:user_comment_rating).permit(:star)
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end


end
