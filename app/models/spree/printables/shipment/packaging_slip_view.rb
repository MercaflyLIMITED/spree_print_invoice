module Spree
  class Printables::Shipment::PackagingSlipView < Printables::Invoice::BaseView
    def_delegators :@printable,
                   :email,
                   :bill_address,
                   :ship_address,
                   :tax_address,
                   :item_total,
                   :total,
                   :payments,
                   :shipment,
                   :note,
                   :total_weight


    def items
      array = @shipment.manifest.map do |m|
        item = m.line_item
        Spree::Printables::Invoice::Item.new(
          sku: item.variant.sku,
          name: item.product.master.name + ' ',
          options_text: item.variant.options_text,
          price: item.display_price,
          quantity: item.quantity,
          total: item.display_total,
          position: item.variant.stock_items.first.shelf_position,
          left: item.variant.stock_items.first.count_on_hand,
        )
      end
      array.sort { |x, y| x.position && y.position ? x.position <=> y.position: x.position  ? -1 : 1 }
    end

    def initialize(shipment)
      @shipment = shipment
    end

    def display_number
      @shipment.number
    end

    def date
      @shipment.shipped_at
    end

    def shipment
      @shipment
    end

    def firstname
      @shipment.order.ship_address.first_name
    end

    def lastname
      ''
    end

    def email
      ''
    end

    def total
      0
    end

    def number
      @shipment.number
    end

    def after_save_actions
    end
  end
end
