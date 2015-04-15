require 'delegate'

require_relative 'items/normal_item'
require_relative 'items/sulfuras'
require_relative 'items/backstage_pass'
require_relative 'items/brie'

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

def wrap_item(item)
  wrapper_class = ItemIdentifier.wrapper_for(item)
  wrapper_class.new(item)
end

