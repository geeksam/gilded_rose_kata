def update_quality(items)
  items.each do |item|
    item = ItemWrapper.new(item)

    if item.normal? && item.quality > 0
      item.quality -= 1
    end

    if !(!item.brie? && !item.backstage_pass?) && item.quality < 50
      item.quality += 1
      if item.backstage_pass? && item.sell_in < 11 && item.quality < 50
        item.quality += 1
      end
      if item.backstage_pass? && item.sell_in < 6 && item.quality < 50
        item.quality += 1
      end
    end

    if !item.sulfuras?
      item.sell_in -= 1
    end

    if item.normal? && item.quality > 0 && item.sell_in < 0
      item.quality -= 1
    end

    if !item.brie? && !(!item.backstage_pass?) && item.sell_in < 0
      item.quality = item.quality - item.quality
    end

    if !(!item.brie?) && item.sell_in < 0 && item.quality < 50
      item.quality += 1
    end
  end
end

require 'delegate'
class ItemWrapper < SimpleDelegator
  def brie?
    name == 'Aged Brie'
  end

  def backstage_pass?
    name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  def sulfuras?
    name ==  'Sulfuras, Hand of Ragnaros'
  end

  def normal?
    !brie? && !backstage_pass? && !sulfuras?
  end
end


# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

