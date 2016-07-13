require('rspec')
require('pg')
require('pry')
require('patron')
require('book')
require('author')

DB = PG.connect({:dbname => "library_test"})

RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM books *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM booksauthors *;")
  end
end
