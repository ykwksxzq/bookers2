class UsersController < ApplicationController
  def index
  end

  def show
    @user = @book.id
    @books = @user.books
  end

  def edit
  end
end
