class UpdateBrie < UpdateItem
  def self.can_update?(item)
    item.name == 'Aged Brie'
  end

  private

  def adjust_quality
    item.quality += 1
  end

  def adjust_quality_after_expiration
    item.quality += 1
  end
end



class UpdateBackstagePasses < UpdateItem
  def self.can_update?(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  private

  def adjust_quality
    urgency_factor =
      case item.sell_in
      when (0..5)  ; 3
      when (6..10) ; 2
      else         ; 1
      end
    item.quality += urgency_factor
  end

  def adjust_quality_after_expiration
    item.quality = 0
  end
end



class UpdateSulfuras < UpdateItem
  def self.can_update?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  private

  def adjust_quality
  end

  def adjust_sell_in
  end

  def expired?
    false
  end

  def enforce_quality_constraints
  end
end



class UpdateConjuredItem < UpdateItem
  def self.can_update?(item)
    item.name == 'Conjured Mana Cake'
  end

  private

  def adjust_quality
    item.quality -= 2
  end

  def adjust_quality_after_expiration
    item.quality -= 2
  end
end
