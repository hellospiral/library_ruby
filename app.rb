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
  book = Book.new({title: name, bookid: nil})
  book.save()
  erb(:success)
end

get('/books') do
  @books = Book.all()
  erb(:books)
end

get('/books/:id') do
  @book = Book.find_by_id(params.fetch("id").to_i())
  erb(:book)
end

get('/books/:id/edit') do
  @book = @book = Book.find_by_id(params.fetch("id").to_i())
  erb(:edit_book_form)
end

patch('/books/:id') do
  title = params.fetch('title')
  @book = Book.find_by_id(params.fetch('id').to_i())
  @book.update({title: title})
  erb(:book)

end
