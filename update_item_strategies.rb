class UpdateBrie < UpdateItem
  def self.can_update?(item)
    item.name == 'Aged Brie'
  end

  private

  def unexpired_quality_adjustment
    1
  end

  def expired_quality_adjustment
    1
  end
end



class UpdateBackstagePasses < UpdateItem
  def self.can_update?(item)
    item.name == 'Backstage passes to a TAFKAL80ETC concert'
  end

  private

  def unexpired_quality_adjustment
    case item.sell_in
    when (0..5)  ; 3
    when (6..10) ; 2
    else         ; 1
    end
  end

  def expired_quality_adjustment
    -1 * item.quality # additive inverse
  end
end



class UpdateSulfuras < UpdateItem
  def self.can_update?(item)
    item.name == 'Sulfuras, Hand of Ragnaros'
  end

  private

  def unexpired_quality_adjustment
    0
  end

  def aging_adjustment
    0
  end

  def expired_quality_adjustment
    0
  end

  def enforce_quality_constraints
  end
end

