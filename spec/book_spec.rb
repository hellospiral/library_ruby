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
      expect(Book.find_by_title(test_book.title())).to(eq(test_book))
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

    # it "adds authorid and bookid to authors-books table" do
    #
    # end
  end

  describe("#delete") do
    it('lets you delete a book in the database') do
      test_book = Book.new({title: 'Mike', bookid: nil})
      test_book.save()
      test_book.delete()
      expect(Book.all()).to(eq([]))
    end
  end
end
