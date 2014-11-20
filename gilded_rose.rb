def update_quality(items)
  items.each do |item|
    UpdateItem.call(item)
  end
end

class UpdateItem
  def self.call(item)
    factory = factory_for(item)
    factory.new(item).call
  end

  def self.inherited(subclass)
    @subclasses ||= []
    @subclasses << subclass
  end

  def self.factory_for(item)
    factory = @subclasses.detect { |factory| factory.can_update?(item) }
    factory || self
  end

  def self.can_update?(item)
    fail NotImplemented, "subclass responsibility"
  end



  def initialize(item)
    @item = item
  end

  MIN_QUALITY = 0
  MAX_QUALITY = 50

  BRIE             = 'Aged Brie'
  BACKSTAGE_PASSES = 'Backstage passes to a TAFKAL80ETC concert'
  SULFURAS         = 'Sulfuras, Hand of Ragnaros'

  def call
    adjust_quality
    adjust_sell_in
    adjust_quality_after_expiration
    enforce_quality_constraints
  end

  private
  attr_reader :item

  def adjust_quality
    item.quality -= 1
  end

  def adjust_sell_in
    item.sell_in -= 1
  end

  def adjust_quality_after_expiration
    return unless expired?
    item.quality -= 1
  end

  def expired?
    item.sell_in < 0
  end

  def enforce_quality_constraints
    item.quality = [ item.quality, MAX_QUALITY ].min
    item.quality = [ item.quality, MIN_QUALITY ].max
  end
end

class UpdateBrie < UpdateItem
  def self.can_update?(item)
    item.name == BRIE
  end

  private

  def adjust_quality
    item.quality += 1
  end

  def adjust_quality_after_expiration
    return unless expired?
    item.quality += 1
  end
end

class UpdateBackstagePasses < UpdateItem
  def self.can_update?(item)
    item.name == BACKSTAGE_PASSES
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
    return unless expired?
    item.quality = 0
  end
end

class UpdateSulfuras < UpdateItem
  def self.can_update?(item)
    item.name == SULFURAS
  end

  private

  def adjust_quality
  end

  def adjust_sell_in
  end

  def adjust_quality_after_expiration
  end

  def enforce_quality_constraints
  end
end

# DO NOT CHANGE THINGS BELOW -----------------------------------------

Item = Struct.new(:name, :sell_in, :quality)

# We use the setup in the spec rather than the following for testing.
#
# Items = [
#   Item.new("+5 Dexterity Vest", 10, 20),
#   Item.new("Aged Brie", 2, 0),
#   Item.new("Elixir of the Mongoose", 5, 7),
#   Item.new("Sulfuras, Hand of Ragnaros", 0, 80),
#   Item.new("Backstage passes to a TAFKAL80ETC concert", 15, 20),
#   Item.new("Conjured Mana Cake", 3, 6),
# ]

