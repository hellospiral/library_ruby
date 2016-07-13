require('spec_helper')

describe(Author) do
  describe("#name") do
    it("should return the name of the author") do
      test_author = Author.new({name: 'Mike', authorid: nil})
      expect(test_author.name()).to(eq('Mike'))
    end
  end

  describe("#==") do
    it("is the same author if it has the same name") do
      author1 = Author.new({name: "Mike", authorid: nil})
      author2 = Author.new({name: "Mike", authorid: nil})
      expect(author1).to(eq(author2))
    end
  end

  describe('.all') do
    it('is empty at first') do
      expect(Author.all()).to(eq([]))
    end
  end

  describe("#save") do
    it('adds a author to the array of saved authors') do
      test_author = Author.new({name: 'Mike', authorid: nil})
      test_author.save()
      expect(Author.all()).to(eq([test_author]))
    end
  end

  describe(".find_by_id") do
    it('returns a author by its id') do
      test_author = Author.new({name: 'Mike', authorid: nil})
      test_author.save()
      expect(Author.find_by_id(test_author.authorid())).to(eq(test_author))
    end
  end


end
