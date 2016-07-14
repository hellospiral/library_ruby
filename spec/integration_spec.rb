require('capybara/rspec')
require('./app')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('the root path', {type: :feature}) do
  it('views the home page') do
    visit('/')
    expect(page).to have_content("Add a Book")
    expect(page).to have_content("Add a Patron")
  end

  it('renders the new book form') do
    visit('/')
    click_link("Add a Book")
    expect(page).to have_content("Name of Book")
  end
end

describe('the create a book path', {type: :feature}) do
  it('adds a book') do
    visit('/books/new')
    fill_in("name", :with => "The Odyssey")
    click_button("Add Book")
    expect(page).to have_content("Success!")
  end

  it('lists all book') do
    test_book = Book.new({title: "The Odyssey", bookid: nil})
    test_book.save()
    visit('/books')
    expect(page).to have_content("The Odyssey")
  end

  it('says when a book is overdue') do
    test_book = Book.new({title: "The Odyssey", bookid: nil})
    test_book.save()
    test_patron = Patron.new({name: "Joey"})
    test_patron.save()
    DB.exec("INSERT INTO checkouts (bookid, patronid, checkout_date, checkedin) VALUES (#{test_book.bookid.to_i}, #{test_patron.patronid.to_i}, '#{Date.today.prev_year}', 'f');")
    visit('/books')
    expect(page).to have_content('over due')
  end

  it('views a particular book') do
    test_book = Book.new({title: "The Odyssey", bookid: nil})
    test_book.save()
    visit('/books')
    click_link(test_book.title())
    expect(page).to have_content(test_book.title())
  end

  it('updates the title of a book') do
    test_book = Book.new({title: "The Odyssey", bookid: nil})
    test_book.save()
    visit('/books')
    click_link(test_book.title())
    click_link('Edit')
    fill_in('title', :with => "Bacon Boy")
    click_button("Update Book")
    expect(page).to have_content("Bacon Boy")
  end

  it('deletes a book') do
    test_book = Book.new({title: "The Odyssey", bookid: nil})
    test_book.save()
    visit('/books')
    click_link(test_book.title())
    click_button('Delete')
    expect(page).to have_no_content("The Odyssey")
  end

  it('says when a book has been checked out') do
    test_book = Book.new({title: "The Odyssey", bookid: nil})
    test_book.save()
    test_patron = Patron.new({name: "Joey"})
    test_patron.save()
    test_book.checkout(test_patron.patronid.to_i)
    visit('/books/' + test_book.bookid.to_s)
    expect(page).to have_content('The Odyssey has been checked out')

  end
end

describe('the patron path', {type: :feature}) do
  it('creates a patron and lists it out') do
    visit('/')
    click_link('Add a Patron')
    fill_in('name', :with => "Bucky")
    click_button('Add Patron')
    click_link('Return Home')
    click_link('View all Patrons')
    expect(page).to have_content('Bucky')
  end

  it('shows no books are checked out for a patron the first time') do
    test_patron = Patron.new({name: "Joey"})
    test_patron.save()
    visit('/patrons/' + test_patron.patronid().to_s)
    expect(page).to have_content("You haven't checked out any books")
  end
end

describe('the author path', {type: :feature}) do
  it('adds an author to a book') do
    test_book = Book.new({title: 'weird stuff'})
    test_book.save()
    visit('/books')
    click_link('weird stuff')
    click_link('Add Author')
    fill_in('name', :with => 'Joey')
    click_button('Add Author')
    expect(page).to have_content("Joey")
  end
end

describe('the search path', {type: :feature}) do
  it('searches for a book by title and displays it') do
    test_book = Book.new({title: 'weird stuff'})
    test_book.save()
    visit('/')
    fill_in('search_term', :with => 'weird stuff')
    click_button('search')
    expect(page).to have_content('weird stuff')
  end

  it('searches for a book by author') do
    test_book = Book.new({title: 'weird stuff'})
    test_book.save()
    test_author = Author.new({name: "Bucky"})
    test_author.save()
    test_book.update({authorids: [test_author.authorid]})
    visit('/')
    fill_in('search_term', :with => 'Bucky')
    choose('Author')
    click_button('search')
    expect(page).to have_content('weird stuff')
  end
end

describe('the patrons books path', {type: :feature}) do
  it('displays all the books a patron has checked out and their due date') do
    test_patron = Patron.new({name: "Joey"})
    test_patron.save()
    test_book = Book.new({title: 'weird stuff'})
    test_book.save()
    visit('/books/' + test_book.bookid().to_s)
    select('Joey')
    click_button('Checkout')
    expect(page).to have_content('weird stuff - Due Date: ' + Date.today.next_month.to_s)
  end


end
