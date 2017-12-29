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
          left: item.variant.stock_items.first.count_on_hand,
          iva: iva_rate(item),
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

    def iva_rate(item)
      if ship_address.country.iso == 'CH'
        return '0%'
      end

      ads = item.adjustments.where(:source_type => 'Spree::TaxRate')
      if ads.count > 0
        amount = ads.first.try(:source).try(:amount)
        if amount
          return (amount * 100).to_s + '%'
        end
      else
        ''
      end
      ''
    end

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
