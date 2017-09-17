module Spree
  class Printables::Invoice::Iva
    extend Spree::DisplayMoney

    attr_accessor :base, :discount, :rate, :iva

    money_methods :base, :discount, :iva

    def initialize(args = {})
      args.each do |key, value|
        send("#{key}=", value)
      end
    end
  end
end