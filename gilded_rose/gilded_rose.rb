require 'delegate'

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      GildedRoseFactory.create(item).update
    end
  end
end

class GildedRoseFactory
  def self.create(item)
    case item.name
    when "Backstage passes to a TAFKAL80ETC concert"
      BackstagePasses.new(item)
    when "Aged Brie"
      AgedBrie.new(item)
    when "Sulfuras, Hand of Ragnaros"
      SulfurasItem.new(item)
    else
      OtherItem.new(item)
    end
  end
end

class ItemWrapper
  attr_accessor :item

  def initialize(item)
    @item = item
  end

  def increase_quality
    item.quality += 1 if item.quality < 50
  end

  def decrease_quality
    item.quality -= 1 if item.quality > 0
  end

  def decrease_sell_in
    item.sell_in -= 1
  end

  def is_expired
    item.sell_in < 0
  end
end

class OtherItem < ItemWrapper
  def update
    decrease_sell_in
    decrease_quality
    decrease_quality if is_expired
  end
end

class SulfurasItem < ItemWrapper
  def update
  end
end

class AgedBrie < ItemWrapper
  def update
    decrease_sell_in
    increase_quality
    increase_quality if is_expired
  end
end

class BackstagePasses < ItemWrapper
  def update
    decrease_sell_in
    increase_quality
    increase_quality if is_ten_days_to_sell?
    increase_quality if is_five_days_to_sell?
    item.quality = 0 if is_expired
  end

  def is_five_days_to_sell?
    item.sell_in < 6
  end

  def is_ten_days_to_sell?
    item.sell_in < 11
  end
end
