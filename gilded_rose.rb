def update_quality(items)
  items.each do |item|
    UpdateItem.new(item).call
  end
end

class UpdateItem
  def initialize(item)
    @item = item
  end

  MIN_QUALITY = 0
  MAX_QUALITY = 50

  BRIE             = 'Aged Brie'
  BACKSTAGE_PASSES = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS         = 'Sulfuras, Hand of Ragnaros'

  def call
    if item.name != BRIE && item.name != BACKSTAGE_PASSES
      if item.name != SULFURAS
        item.quality -= 1
      end
    else
      item.quality += 1
      if item.name == BACKSTAGE_PASSES
        if item.sell_in < 11
          item.quality += 1
        end
        if item.sell_in < 6
          item.quality += 1
        end
      end
    end

    if item.name != SULFURAS
      item.sell_in -= 1
    end

    if item.sell_in < 0
      if item.name != BRIE
        if item.name != BACKSTAGE_PASSES
          if item.name != SULFURAS
            item.quality -= 1
          end
        else
          item.quality = item.quality - item.quality
        end
      else
        item.quality += 1
      end
    end

    enforce_min_quality
    enforce_max_quality
  end

  private
  attr_reader :item

  def enforce_max_quality
    return if item.name == SULFURAS
    item.quality = [ item.quality, MAX_QUALITY ].min
  end

  def enforce_min_quality
    return if item.name == SULFURAS
    item.quality = [ item.quality, MIN_QUALITY ].max
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

