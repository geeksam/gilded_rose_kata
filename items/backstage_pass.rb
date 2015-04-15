class BackstagePass < NormalItem
  private

  def adjust_quality_before_aging
    case sell_in
    when 0..5  ; self.quality += 3
    when 6..10 ; self.quality += 2
    else       ; self.quality += 1
    end
  end

  def adjust_quality_after_aging
    if sell_in < 0
      self.quality = 0
    end
  end
end
