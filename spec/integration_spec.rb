require('capybara/rspec')
require('./app')

Capybara.app = Sinatra::Application
set(:show_exceptions, false)

describe('the root path', {:type => :feature}) do
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

describe('the create a book path', {:type => :feature}) do
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
    # save_and_open_page
    click_link('Edit')
    fill_in('title', :with => "Bacon Boy")
    click_button("Update Book")
    expect(page).to have_content("Bacon Boy")
  end
end
