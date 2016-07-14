require('spec_helper')

describe(Patron) do
  describe("#name") do
    it("should return the name of the patron") do
      test_patron = Patron.new({name: 'Mike', patronid: nil})
      expect(test_patron.name()).to(eq('Mike'))
    end
  end

  describe("#==") do
    it("is the same patron if it has the same name") do
      patron1 = Patron.new({name: "Mike", patronid: nil})
      patron2 = Patron.new({name: "Mike", patronid: nil})
      expect(patron1).to(eq(patron2))
    end
  end

  describe('.all') do
    it('is empty at first') do
      expect(Patron.all()).to(eq([]))
    end
  end

  describe("#save") do
    it('adds a patron to the array of saved patrons') do
      test_patron = Patron.new({name: 'Mike', patronid: nil})
      test_patron.save()
      expect(Patron.all()).to(eq([test_patron]))
    end
  end

  describe(".find_by_id") do
    it('returns a patron by its id') do
      test_patron = Patron.new({name: 'Mike', patronid: nil})
      test_patron.save()
      expect(Patron.find_by_id(test_patron.patronid())).to(eq(test_patron))
    end
  end

  describe('#books') do
    it('returns all the books and due_date for a patron') do
      test_patron = Patron.new({name: 'Mike', patronid: nil})
      test_patron.save()
      test_book = Book.new({title: 'Death', bookid: nil})
      test_book.save()
      test_book.checkout(test_patron.patronid)
      expect(test_patron.books()).to eq([[test_book, Date.today.next_month.to_s]])
    end
  end
end
