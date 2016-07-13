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
end
