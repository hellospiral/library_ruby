class Book
  attr_reader(:title, :bookid)
  define_method(:initialize) do |attributes|
    @title = attributes[:title]
    @bookid = attributes[:bookid] || nil
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
    result = DB.exec("SELECT * from books WHERE title LIKE '%#{title}%'")
    found_books = []
    result.each do |book|
      title = book['title']
      bookid = book['bookid'].to_i
      found_books.push(Book.new({title: title, bookid: bookid}))
    end
    found_books
  end

  define_singleton_method(:find_by_author) do |author|
    result = DB.exec("SELECT b.* FROM authors a JOIN booksauthors ba ON a.authorid = ba.authorid JOIN books b ON ba.bookid = b.bookid WHERE a.name LIKE '%#{author}%';")
    found_books = []
    result.each do |book|
      title = book['title']
      bookid = book['bookid'].to_i
      found_books.push(Book.new({title: title, bookid: bookid}))
    end
    found_books
  end

  define_method(:update) do |attributes|
    @title = attributes.fetch(:title, @title)
    DB.exec("UPDATE books SET title = '#{@title}' WHERE bookid = #{@bookid};")

    attributes.fetch(:authorids, []).each do |authorid|
      DB.exec("INSERT INTO booksauthors (bookid, authorid) VALUES (#{@bookid}, #{authorid});")
    end
  end

  define_method(:delete) do
    @bookid = self.bookid()
    DB.exec("DELETE FROM books WHERE bookid = #{@bookid};")
  end

  define_method(:authors) do
    book_authors = []
    results = DB.exec("SELECT a.authorid, a.name FROM booksauthors ba JOIN authors a on ba.authorid = a.authorid WHERE ba.bookid = #{self.bookid()};")
    results.each() do |result|
      author_id = result['authorid'].to_i()
      name = result["name"]
      book_authors.push(Author.new({name: name, authorid: author_id}))
    end
    book_authors
  end

end
