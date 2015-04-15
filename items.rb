require 'delegate'

class ItemIdentifier < SimpleDelegator
  def self.wrapper_for(item)
    type = self.new(item)
    case
    when type.brie?           ; Brie
    when type.sulfuras?       ; Sulfuras
    when type.backstage_pass? ; BackstagePass
    else                      ; NormalItem
    end
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
end

class NormalItem < SimpleDelegator
  alias item __getobj__

  def adjust_quality_before_aging
    item.quality -= 1
  end

  def adjust_quality_after_aging
    if sell_in < 0
      item.quality -= 1
    end
  end

  def age
    item.sell_in -= 1
  end

  def max_quality
    50
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

class Sulfuras < NormalItem
  def adjust_quality_before_aging
  end

  def adjust_quality_after_aging
  end

  def age
  end

  def max_quality
    80
  end
end

class BackstagePass < NormalItem
  def adjust_quality_before_aging
    item.quality += 1
    if sell_in < 11
      item.quality += 1
    end
    if sell_in < 6
      item.quality += 1
    end
  end

  def adjust_quality_after_aging
    if sell_in < 0
      item.quality = 0
    end
  end
end

class Brie < NormalItem
  def adjust_quality_before_aging
    item.quality += 1
  end

  def adjust_quality_after_aging
    if sell_in < 0
      item.quality += 1
    end
  end
end

def wrap_item(item)
  wrapper_class = ItemIdentifier.wrapper_for(item)
  wrapper_class.new(item)
end

