require 'spec_helper'

describe MoviesHelper do
  describe "highlight_if_current_column(column)" do
    it "returns expected class if table is sorted by given column" do
      allow(session).to receive(:[]).with(:sort_by).and_return 'title'

      expect(helper.highlight_if_current_column(:title)).to eq('hilite')
    end
    it "returns nil if table is not sorted by given column" do
      allow(session).to receive(:[]).with(:sort_by).and_return 'release_date'

      expect(helper.highlight_if_current_column(:title)).to be_nil
    end
    it "returns nil if table is not sorted at all" do
      expect(helper.highlight_if_current_column(:title)).to be_nil
    end
  end
end
