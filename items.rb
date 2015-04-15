require 'delegate'

class ItemWrapper < SimpleDelegator
  alias item __getobj__

  def adjust_quality_before_aging
    if normal?
      item.quality -= 1
    end

    if brie?
      item.quality += 1
    end

    if backstage_pass?
      item.quality += 1
      if sell_in < 11
        item.quality += 1
      end
      if sell_in < 6
        item.quality += 1
      end
    end
  end

  def adjust_quality_after_aging
    if normal? && sell_in < 0
      item.quality -= 1
    end

    if backstage_pass? && sell_in < 0
      item.quality = 0
    end

    if brie? && sell_in < 0
      item.quality += 1
    end
  end

  def max_quality
    sulfuras? ? 80 : 50
  end

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

  def age
    if !sulfuras?
      item.sell_in -= 1
    end
  end

  def enforce_quality_constraints
    if quality < 0
      item.quality = 0
    end
    if quality > max_quality
      item.quality = max_quality
    end
  end
end

def wrap_item(item)
  ItemWrapper.new(item)
end

