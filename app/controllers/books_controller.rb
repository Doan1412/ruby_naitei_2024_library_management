class BooksController < ApplicationController
  before_action :is_admin_role?, only: %i(destroy)
  before_action :load_book, only: %i(destroy)
  def index
    @category = Category.find_by(id: params[:category])
    @total_books = filtered_books.count
    @keywords = params[:search]
    @pagy, @books = pagy(filtered_books)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show; end

  def destroy
    if @book.destroy
      flash[:success] = t "noti.book_delete_success"
    else
      flash[:danger] = t "noti.book_delete_fail"
    end
    redirect_to books_path
  end

  private
  def filtered_books
    Book.filter_by_category(@category)
        .filter_by_search(params[:search])
        .sorted_by(params[:sort])
  end

  def load_book
    @book = Book.find_by(id: params[:id])
    return if @book

    flash[:danger] = t "noti.book_not_found"
    redirect_to books_path
  end
end
