require 'delegate'

class ItemWrapper < SimpleDelegator
  alias item __getobj__

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

