class Book
  attr_reader(:title, :bookid)
  define_method(:initialize) do |attributes|
    @title = attributes[:title]
    @bookid = attributes[:bookid]
  end

  define_method(:==) do |another_book|
    self.title() == another_book.title() && self.bookid() == another_book.bookid()
  end

  define_singleton_method(:all) do
    returned_books = DB.exec("SELECT * FROM books;")
    books = []
    returned_books.each() do |book|
      title = book["title"]
      bookid = book["bookid"].to_i()
      books.push(Book.new({title: title, bookid: bookid}))
    end
    books
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO books (title) VALUES ('#{@title}') RETURNING bookid;")
    @bookid = result.first["bookid"].to_i()
  end

  define_singleton_method(:find_by_id) do |bookid|
    found_book = nil
    Book.all().each() do |book|
      if book.bookid() == bookid
        found_book = book
      end
    end
    found_book
  end

  define_singleton_method(:find_by_title) do |title|
    found_book = nil
    Book.all().each() do |book|
      if book.title() == title
        found_book = book
      end
    end
    found_book
  end

  # define_singleton_method(:find_by_author) do |author|
  #   found_books = DB.exec("Select * from books join author")
  #
  #
  # end

  define_method(:update) do |attributes|
    @title = attributes[:title]
    @bookid = self.bookid()
    DB.exec("UPDATE books SET title = '#{@title}' WHERE bookid = #{@bookid};")

    attributes.fetch(:authorids, []).each do |authorid|
      DB.exec("INSERT INTO bookauthors (bookid, authorid) VALUES (#{@bookid}, #{authorid})")
    end
  end

  define_method(:delete) do
    @bookid = self.bookid()
    DB.exec("DELETE FROM books WHERE bookid = #{@bookid};")
  end

end
