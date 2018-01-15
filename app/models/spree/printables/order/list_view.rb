module Spree
  class Printables::Order::ListView < Printables::Invoice::BaseView
    def_delegators :@printable,
                   :email,
                   :bill_address,
                   :ship_address,
                   :tax_address,
                   :item_total,
                   :total,
                   :payments,
                   :shipments,
                   :note,
                   :total_weight

    def items
      array = printable.line_items.map do |item|
        Spree::Printables::Invoice::Item.new(
            index: 0,
            sku: item.variant.sku,
            name: item.variant.name + ' '+ (item.tax_category.try(:description) || ''),
            options_text: item.variant.options_text,
            price: item.display_price,
            quantity: item.quantity,
            total: item.display_total,
            position: item.variant.stock_items.first.shelf_position,
            shelf: item.variant.stock_items.first.shelf,
            )
      end

      array = array.sort { |x, y| x.shelf.try(:position) && y.shelf.try(:position) ? x.shelf.try(:position) <=> y.shelf.try(:position): x.shelf.try(:position)  ? -1 : 1 }
      index = 0
      array.each do |item|
        index = index + 1
        item.index = index
      end
    end

    def firstname
      printable.tax_address.firstname
    end

    def lastname
      printable.tax_address.lastname
    end

    private

    def all_adjustments
      printable.all_adjustments.eligible
    end
  end
end
