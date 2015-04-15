require 'delegate'

class ItemWrapper < SimpleDelegator
  alias item __getobj__

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

class NormalItem < ItemWrapper
  def adjust_quality_before_aging
    item.quality -= 1
  end
end

class Sulfuras < ItemWrapper
  def adjust_quality_before_aging
  end
end

class BackstagePass < ItemWrapper
  def adjust_quality_before_aging
    item.quality += 1
    if sell_in < 11
      item.quality += 1
    end
    if sell_in < 6
      item.quality += 1
    end
  end
end

class Brie < ItemWrapper
  def adjust_quality_before_aging
    item.quality += 1
  end
end

def wrap_item(item)
  wrapper = ItemWrapper.new(item)
  case
  when wrapper.brie?           ; Brie.new(item)
  when wrapper.sulfuras?       ; Sulfuras.new(item)
  when wrapper.backstage_pass? ; BackstagePass.new(item)
  else                         ; NormalItem.new(item)
  end
end

