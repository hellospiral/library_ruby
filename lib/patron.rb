class Patron
  attr_reader(:name, :patronid)
  define_method(:initialize) do |attributes|
    @name = attributes[:name]
    @patronid = attributes[:patronid] || nil
  end

  define_method(:==) do |another_patron|
    self.name() == another_patron.name() && self.patronid() == another_patron.patronid()
  end

  define_singleton_method(:all) do
    returned_patrons = DB.exec("SELECT * FROM patrons;")
    patrons = []
    returned_patrons.each() do |patron|
      name = patron["name"]
      patronid = patron["patronid"].to_i()
      patrons.push(Patron.new({name: name, patronid: patronid}))
    end
    patrons
  end

  define_method(:save) do
    result = DB.exec("INSERT INTO patrons (name) VALUES ('#{@name}') RETURNING patronid;")
    @patronid = result.first()["patronid"].to_i()
  end

  define_singleton_method(:find_by_id) do |patronid|
    found_patron = nil
    Patron.all().each() do |patron|
      if patron.patronid() == patronid
        found_patron = patron
      end
    end
    found_patron
  end

  define_method(:books) do
    result = DB.exec("SELECT b.*, c.due_date FROM checkouts c JOIN books b on c.bookid = b.bookid WHERE patronid = #{@patronid.to_i};")
    returned_books = []
    result.each do |book|
      bookid = book['bookid'].to_i
      title = book['title']
      due_date = book['due_date'].to_s
      returned_books.push([Book.new({bookid: bookid, title: title}), due_date])
    end
    returned_books
  end
end
