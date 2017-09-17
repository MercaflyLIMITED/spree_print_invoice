include Forwardable

module Spree
  class Printables::Invoice::BaseView < Printables::BaseView
    extend Forwardable
    extend Spree::DisplayMoney

    attr_reader :printable

    money_methods :item_total, :total

    def bill_address
      raise NotImplementedError, 'Please implement bill_address'
    end

    def ship_address
      raise NotImplementedError, 'Please implement ship_address'
    end

    def tax_address
      raise NotImplementedError, 'Please implement tax_address'
    end

    def items
      raise NotImplementedError, 'Please implement items'
    end

    def item_total
      raise NotImplementedError, 'Please implement item_total'
    end

    def adjustments
      adjustments = []
      all_adjustments.group_by(&:label).each do |label, adjustment_group|
        adjustments << Spree::Printables::Invoice::Adjustment.new(
          label: label,
          amount: adjustment_group.map(&:amount).sum
        )
      end
      adjustments
    end

    def ivas
      ivas = []
      all_adjustments.where(:source_type => 'Spree::TaxRate').group_by(&:label).each do |label, adjustment_group|
        total_amount = adjustment_group.map(&:adjustable).map(&:amount).sum
        rate = adjustment_group.first.source.amount

        ivas << Spree::Printables::Invoice::Iva.new(
          base: (total_amount / (1 + rate)).to_s,
          discount: '0',
          rate: (rate * 100).to_s + '%',
          iva: adjustment_group.map(&:amount).sum
        )
      end

      promotion_total = - all_adjustments.where(:source_type => 'Spree::PromotionAction').map(&:amount).sum
      ivas = ivas.sort_by(&:rate)
      ivas.each do |iva|
        if promotion_total > 0

          total = iva.base.to_f + iva.iva.to_f

          discount = promotion_total > total ? total: promotion_total
          iva.discount = discount
          iva.iva = iva.iva - discount * (iva.rate.to_f / 100 ).to_f

          promotion_total -= total
        end
      end

    end

    def shipments
      raise NotImplementedError, 'Please implement shipments'
    end

    def payments
      raise NotImplementedError, 'Please implement payments'
    end

    def shipping_methods
      shipments.map(&:shipping_method).map(&:name)
    end

    def admin_shipping_methods

      if total_weight > 4500 && shipments.first.shipping_method.admin_name == 'MRW-SPAIN'
        return ['RAPIDO EXPRRES']
      elsif total_weight <= 4500 && shipments.first.shipping_method.admin_name == 'MRW-SPAIN'
        return ['MRW']
      end
      shipments.map(&:shipping_method).map(&:admin_name)
    end

    def number
      printable.number
    end

    def after_save_actions
      increase_invoice_number! if use_sequential_number?
    end

    def order_note
      if printable.admin_note.nil?
        (printable.completed_at + 2.hours).strftime("ANTES DE LAS %F %H:%M")
      else
        'Note:' + printable.admin_note
      end
    end

    private

    def increase_invoice_number!
      Spree::PrintInvoice::Config.increase_invoice_number!
    end

    def use_sequential_number?
      @_use_sequential_number ||=
        Spree::PrintInvoice::Config.use_sequential_number?
    end
  end
end
