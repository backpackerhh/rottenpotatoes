require 'spec_helper'

describe Movie do
  describe ".all_ratings" do
    it "returns an array of ratings" do
      expect(described_class.all_ratings).to match_array(%w[G PG PG-13 R NC-17])
    end
  end

  describe "#other_movies_from_same_director" do
    let(:inception) { Movie.create!(title: 'Inception', director: 'Christopher Nolan') }

    it "finds other movies from the same director" do
      memento = Movie.create!(title: 'Memento', director: 'Christopher Nolan')

      expect(inception.other_movies_from_same_director).to eq([memento])
    end
    it "is empty whithout movies from same director" do
      memento = Movie.create!(title: 'Memento')

      expect(inception.other_movies_from_same_director).to be_empty
    end
  end
end
