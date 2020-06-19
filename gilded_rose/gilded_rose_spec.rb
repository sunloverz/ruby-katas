require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe "#update_quality" do
    before do
      @items = [
          Item.new("foo", 0, 0),
          Item.new("Aged Brie", 2, 0),
          Item.new("Aged Brie", 2, 50),
          Item.new("Sulfuras, Hand of Ragnaros", 0, 40),
          Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 10),
          Item.new("Backstage passes to a TAFKAL80ETC concert", 5, 10),
          Item.new("Backstage passes to a TAFKAL80ETC concert", -1, 10),
          Item.new("Sulfuras, Hand of Ragnaros", 1, 1),
      ]
      @gilded_rose = GildedRose.new(@items)
      @gilded_rose.update_quality
    end

    it "does not change the name" do
      expect(@items[0].name).to eq "foo"
    end

    it "quality item is never negative" do
      @gilded_rose.update_quality
      expect(@items[0].quality).to be >= 0
    end

    it "Aged Brie increases in Quality the older it gets" do
      @gilded_rose.update_quality
      expect(@items[1].quality).to eq 2
    end

    it "The Quality of an item is never more than 50" do
      @gilded_rose.update_quality
      @gilded_rose.update_quality
      expect(@items[2].quality).to be <= 50
    end

    it "Sulfuras never has to be sold or decreases in Quality" do
      @gilded_rose.update_quality
      expect(@items[3].sell_in).to be 0
      expect(@items[3].quality).to be 40
    end

    it "Backstage passes quality increases by 2 when there are 10 days or less" do
      @gilded_rose.update_quality
      expect(@items[4].quality).to be 14
    end

    it "Backstage passes quality increases by 3 when there are 5 days or less" do
      expect(@items[5].quality).to be 13
    end

    it "Backstage passes quality drops to 0 after the concert" do
      expect(@items[6].quality).to be 0
    end

    it "Sulfuras never has to be sold or decreases in Quality" do
      @gilded_rose.update_quality
      expect(@items[7].quality).to be 1
      expect(@items[7].sell_in).to be 1
    end
  end
end
