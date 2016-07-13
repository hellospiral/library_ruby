require("sinatra")
require("sinatra/reloader")
also_reload("lib/**/*.rb")
require("./lib/author")
require("./lib/book")
require("./lib/patron")
require('pg')

DB = PG.connect({:dbname => "library_test"})

get('/') do
  erb(:index)
end

get('/books/new') do
  erb(:book_form)
end

post('/books') do
  name = params.fetch('name')
  book = Book.new({title: name})
  book.save()
  erb(:success)
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

get('/books/:id') do
  @book = Book.find_by_id(params.fetch("id").to_i())
  @authors = @book.authors()
  erb(:book)
end

get('/books/:id/edit') do
  @book = Book.find_by_id(params.fetch("id").to_i())
  erb(:edit_book_form)
end

patch('/books/:id') do
  @book = Book.find_by_id(params.fetch('id').to_i())
  title = params['title']
  @book.update({title: title})
  @authors = @book.authors()
  erb(:book)
end

delete('/books/:id') do
  @book = Book.find_by_id(params.fetch("id").to_i())
  @book.delete()
  @books = Book.all()
  erb(:books)
end

get('/patrons/new') do
  erb(:patron_form)
end

get('/patrons') do
  @patrons = Patron.all()
  erb(:patrons)
end

post('/patrons') do
  name = params.fetch('name')
  patron = Patron.new({name: name})
  patron.save()
  erb(:success)
end

get('/books/:id/author/new') do
  @book = Book.find_by_id(params['id'].to_i)
  erb(:author_form)
end

post('/books/:id/authors') do
  name = params.fetch('name')
  author = Author.new({name: name})
  author.save()
  @book = Book.find_by_id(params.fetch('bookid').to_i())
  @book.update({authorids: [author.authorid]})
  @authors = @book.authors()
  erb(:book)
end

post('/books/search_result') do
  search_by = params[:search_by]
  search_term = params['search_term']
  if search_by == 'Title'
    @books = Book.find_by_title(search_term)
  elsif search_by == "Author"
    @books = Book.find_by_author(search_term)
  end
  erb(:books)
end
