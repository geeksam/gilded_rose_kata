class ItemUpdater
  def call(item)
    self.item = item
    update_quality_before_aging
    age_item
    update_quality_after_aging
    enforce_quality_constraints
  end

  private
  attr_accessor :item

  def update_quality_before_aging
  end

  def age_item
    item.sell_in -= 1
  end

  def update_quality_after_aging
  end

  def enforce_quality_constraints
    item.quality = 50 if item.quality > 50
    item.quality =  0 if item.quality <  0
  end
end

class NormalItemUpdater < ItemUpdater
  def update_quality_before_aging
    item.quality -= 1
  end

  def update_quality_after_aging
    if item.sell_in < 0
      item.quality -= 1
    end
  end
end

class LegendaryItemUpdater < ItemUpdater
  def call(item)
    # Refused Bequest
  end
end

class AgedItemUpdater < ItemUpdater
  def update_quality_before_aging
    item.quality += 1
  end

  def update_quality_after_aging
    if item.sell_in < 0
      item.quality += 1
    end
  end
end

class BackstagePassItemUpdater < ItemUpdater
  def update_quality_before_aging
    item.quality += 1
    if item.sell_in < 11
      item.quality += 1
    end
    if item.sell_in < 6
      item.quality += 1
    end
  end

  def update_quality_after_aging
    if item.sell_in < 0
      item.quality = item.quality - item.quality
    end
  end
end

def update_quality(items)
  items.each do |item|
    klass = \
      case item.name
      when /Sulfuras, Hand of Ragnaros/                ; LegendaryItemUpdater
      when /Aged Brie/                                 ; AgedItemUpdater
      when /Backstage passes to a TAFKAL80ETC concert/ ; BackstagePassItemUpdater
      else                                             ; NormalItemUpdater
      end
    updater = klass.new
    updater.call(item)
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

