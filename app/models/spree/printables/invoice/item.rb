module Spree
  class Printables::Invoice::Item
    extend Spree::DisplayMoney

    attr_accessor :index, :sku, :name, :options_text, :price, :quantity, :total, :position, :left, :iva

    money_methods :price, :total

    def initialize(args = {})
      args.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end
