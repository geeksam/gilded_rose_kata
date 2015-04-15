class Brie < NormalItem
  private

  def adjust_quality_before_aging
    self.quality += 1
  end

  def adjust_quality_after_aging
    if sell_in < 0
      self.quality += 1
    end
  end
end
