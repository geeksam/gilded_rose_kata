class NormalItem < SimpleDelegator
  def tick
    adjust_quality_before_aging
    age
    adjust_quality_after_aging
    enforce_quality_constraints
  end

  private

  def adjust_quality_before_aging
    self.quality -= 1
  end

  def age
    self.sell_in -= 1
  end

  def adjust_quality_after_aging
    if sell_in < 0
      self.quality -= 1
    end
  end

  def max_quality
    50
  end

  def enforce_quality_constraints
    if quality < 0
      self.quality = 0
    end
    if quality > max_quality
      self.quality = max_quality
    end
  end
end

