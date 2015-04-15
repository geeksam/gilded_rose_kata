class BackstagePass < NormalItem
  private

  def adjust_quality_before_aging
    self.quality += 1
    if sell_in < 11
      self.quality += 1
    end
    if sell_in < 6
      self.quality += 1
    end
  end

  def adjust_quality_after_aging
    if sell_in < 0
      self.quality = 0
    end
  end
end
