class BooksController < ApplicationController

  before_action :is_matching_login_user, only: [:edit,:update]

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
   if @book.save
    flash[:notice] = "You have created book successfully."
    redirect_to book_path(@book.id)
   else
    @books = Book.all
    render :index
   end
  end

  def index
    # @books = Book.all
    @book = Book.new
     to = Time.current.at_end_of_day #現在日時を取得
     from = (to - 6.day).at_beginning_of_day #時刻を23:59:59に設定

    @books = Book.includes(:favorited_users). #Bookモデルのデータを取得
     sort_by {|x| #値を 1つずつ xという変数に代入して、昇順に並び替える
      x.favorited_users.includes(:favorites).where(created_at: from...to).size
     }.reverse

     #各Bookインスタンス(x)が持つ favorited_users のうち、favoritesのcreated_atが fromから toの間にあるものの数を取得
     #.reverse →sort_byメソッドは値を昇順に並び替え

    @user = current_user

     unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
     end
  end

  def show
    @book2 = Book.find(params[:id])
     unless ViewCount.find_by(user_id: current_user.id, book_id: @book2.id)
      current_user.view_counts.create(book_id: @book2.id)
     end
    @book = Book.new
    @user = @book2.user
    @post_comment = PostComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
    flash[:notice] = "You have updated book successfully."
     redirect_to book_path(@book.id)
    else
     render :edit
    end
  end

  def destroy
   @book = Book.find(params[:id])
   @book.destroy
    redirect_to books_path
  end


  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def is_matching_login_user
    @book = Book.find(params[:id])
    unless @book.user.id == current_user.id
      redirect_to books_path
    end
  end

end
