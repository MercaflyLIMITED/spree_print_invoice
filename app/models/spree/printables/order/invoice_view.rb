module Spree
  class Printables::Order::InvoiceView < Printables::Invoice::BaseView
    def_delegators :@printable,
                   :email,
                   :bill_address,
                   :ship_address,
                   :tax_address,
                   :item_total,
                   :total,
                   :payments,
                   :shipments,
                   :note

    def items
      array = printable.line_items.map do |item|
        Spree::Printables::Invoice::Item.new(
          sku: item.variant.sku,
          name: item.variant.name + ' '+ taxon_name(item),
          options_text: item.variant.options_text,
          price: item.display_price,
          quantity: item.quantity,
          total: item.display_total,
          position: item.variant.stock_items.first.shelf_position,
          left: item.variant.stock_items.first.count_on_hand,
          iva: item.tax_category.nil? ? '': item.tax_category.name,
        )
      end
      array.sort { |x, y| x.position && y.position ? x.position <=> y.position: x.position  ? -1 : 1 }

    end

    def firstname
      printable.tax_address.firstname
    end

    def lastname
      printable.tax_address.lastname
    end

    private

    def taxon_name(item)
      taxon_id = item.variant.product.taxons.where(:depth => 1).ids.first
      name = ''
      if taxon_id.nil?
        name = ''
      elsif taxon_id == 1020 #酒水饮料
        name = 'BEBIDAD'
      elsif taxon_id == 1088 #蔬果肉类
        name = 'VERDURA ASIATICO'
      elsif taxon_id == 1089 #熟食冷盘
        name = 'SNACK'
      elsif taxon_id == 1022 #零食小吃
        name = 'SNACK'
      elsif taxon_id == 1019 #厨房调味
        name = 'CODIMENTO ASIATICO'
      elsif taxon_id == 1023 #干货罐头
        name = 'ALIMENTOS ASIATICO'
      elsif taxon_id == 1026 #冷冻食品
        name = 'ALIMENTOS ASIATICO'
      elsif taxon_id == 1024 #米类豆类
        name = 'PRODUCTOS DE ARROZ'
      elsif taxon_id == 1025 #面类粉类
        name = 'ALIMENTOS ASIATICO'
      elsif taxon_id == 1021 #酱菜腐乳
        name = 'ALIMENTOS ASIATICO'
      end
      return name
    end

    def all_adjustments
      printable.all_adjustments.eligible
    end
  end
end
