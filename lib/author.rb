class Author
  attr_reader(:name, :authorid)
  define_method(:initialize) do |attributes|
    @name = attributes[:name]
    @authorid = attributes[:authorid] || nil
  end

  define_method(:==) do |another_author|
    self.name() == another_author.name() && self.authorid() == another_author.authorid()
  end

  define_singleton_method(:all) do
    returned_authors = DB.exec("SELECT * FROM authors;")
    authors = []
    returned_authors.each() do |author|
      name = author["name"]
      authorid = author["authorid"].to_i()
      authors.push(Author.new({name: name, authorid: authorid}))
    end
    authors
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO authors (name) VALUES ('#{@name}') RETURNING authorid;")
    @authorid = result.first()["authorid"].to_i()
  end

  define_singleton_method(:find_by_id) do |authorid|
    found_author = nil
    Author.all().each() do |author|
      if author.authorid() == authorid
        found_author = author
      end
    end
    found_author
  end

  define_method(:update) do |attributes|
    @name = attributes.fetch(:name, @name)
    result = DB.exec("UPDATE authors SET name = '#{@name}' WHERE authorid = #{@authorid}")
  end
end
