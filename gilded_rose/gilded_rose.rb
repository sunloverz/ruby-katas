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

  def increase_quality
    @quality += 1
  end

  def decrease_quality
    @quality -= 1
  end

  def decrease_sell_in
    @sell_in -= 1
  end
end

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      case item.name
      when "Backstage passes to a TAFKAL80ETC concert"
        BackstagePasses.update(item)
      when "Aged Brie"
        AgedBrie.update(item)
      when "Sulfuras, Hand of Ragnaros"
      else
        OtherItem.update(item)
      end
    end
  end
end

class ItemWrapper < SimpleDelegator

end

module ItemModule
  def is_expired(item)
    item.sell_in < 0
  end

  def is_quality_less_fifty(item)
    item.quality < 50
  end
end

class OtherItem
  extend ItemModule

  def self.update(item)
    item.decrease_sell_in
    decrease_quality_if_has_one(item)
    decrease_quality_if_expired(item)
  end

  def self.decrease_quality_if_expired(item)
    if has_quality(item) && is_expired(item)
      item.decrease_quality
    end
  end

  def self.decrease_quality_if_has_one(item)
    if has_quality(item)
      item.decrease_quality
    end
  end

  def self.has_quality(item)
    item.quality > 0
  end
end

class AgedBrie
  extend ItemModule

  def self.update(item)
    item.decrease_sell_in
    increase_quality_if_less_fifty(item)
    increase_quality_if_not_expired(item)
  end

  def self.increase_quality_if_not_expired(item)
    if is_quality_less_fifty(item) && is_expired(item)
      item.increase_quality
    end
  end

  def self.increase_quality_if_less_fifty(item)
    if is_quality_less_fifty(item)
      item.increase_quality
    end
  end
end

class BackstagePasses
  extend ItemModule

  def self.update(item)
    item.decrease_sell_in
    if is_quality_less_fifty(item)
      item.increase_quality
      increase_quality_if_ten_days(item)
      increase_quality_if_five_days(item)
      drop_quality_after_concert(item)
    end
  end

  def self.drop_quality_after_concert(item)
    if is_expired(item)
      item.quality = 0
    end
  end

  def self.increase_quality_if_ten_days(item)
    if is_ten_days_to_sell(item) && is_quality_less_fifty(item)
      item.increase_quality
    end
  end

  def self.increase_quality_if_five_days(item)
    if is_five_days_to_sell(item) && is_quality_less_fifty(item)
      item.increase_quality
    end
  end

  def self.is_five_days_to_sell(item)
    item.sell_in < 6
  end

  def self.is_ten_days_to_sell(item)
    item.sell_in < 11
  end
end
