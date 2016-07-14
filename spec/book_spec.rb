require('spec_helper')

describe(Book) do
  describe("#title") do
    it("should return the title of the book") do
      test_book = Book.new({title: 'Mike', bookid: nil})
      expect(test_book.title()).to(eq('Mike'))
    end
  end

  describe("#==") do
    it("is the same book if it has the same title") do
      book1 = Book.new({title: "Mike", bookid: nil})
      book2 = Book.new({title: "Mike", bookid: nil})
      expect(book1).to(eq(book2))
    end
  end

  describe('.all') do
    it('is empty at first') do
      expect(Book.all()).to(eq([]))
    end
  end

  describe("#save") do
    it('adds a book to the array of saved books') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      expect(Book.all()).to(eq([test_book]))
    end
  end

  describe(".find_by_id") do
    it('returns a book by its id') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      expect(Book.find_by_id(test_book.bookid())).to(eq(test_book))
    end
  end

  describe(".find_by_title") do
    it('returns a book by its title') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      expect(Book.find_by_title(test_book.title())).to(eq([test_book]))
    end
  end

  # describe(".find_by_author") do
  #   it('returns a book by its author') do
  #     test_book = Book.new({title: 'THe Odyssey', bookid: nil})
  #     test_book.save()
  #     test_author = Author.new({name: 'Mike', authorid: nil})
  #     test_author.save()
  #     expect(Book.find_by_author(test_author.name())).to(eq(test_book))
  #   end
  # end

  describe("#update") do
    it('lets you update a book in the database') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_book.update({title: 'The Ilyad'})
      expect(test_book.title()).to(eq('The Ilyad'))
      expect(Book.all()).to(eq([test_book]))
    end

    it "adds authorid and bookid to authors-books table" do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_author = Author.new({name: 'Matt', authorid: nil})
      test_author.save()
      test_book.update({authorids: [test_author.authorid()]})
      expect(test_book.authors).to(eq([test_author]))
    end
  end

  describe("#delete") do
    it('lets you delete a book in the database') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_book.delete()
      expect(Book.all()).to(eq([]))
    end
  end

  describe('#checkedout?') do
    it('returns true if a book is checked out') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      expect(test_book.checkedout?()).to(eq(false))
    end
  end

  describe('#checkout') do
    it('checks a book out') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_book.checkout(1)
      expect(test_book.checkedout?).to eq(true)
    end
  end

  describe('#overdue?') do
    it('returns true if a book is overdue') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_patron = Patron.new({name: "Joey"})
      test_patron.save()
      DB.exec("INSERT INTO checkouts (bookid, patronid, checkout_date, due_date, checkedin) VALUES (#{test_book.bookid.to_i}, #{test_patron.patronid.to_i}, '#{Date.today.prev_year.to_s}', '#{Date.today.prev_year.next_month.to_s}', 'f');")
      expect(test_book.overdue?).to eq(true)
    end

    it('returns false if a book is not overdue') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_patron = Patron.new({name: "Joey"})
      test_patron.save()
      DB.exec("INSERT INTO checkouts (bookid, patronid, checkout_date, checkedin) VALUES (#{test_book.bookid.to_i}, #{test_patron.patronid.to_i}, '#{Date.today}', 'f');")
      expect(test_book.overdue?).to eq(false)
    end
  end
end
