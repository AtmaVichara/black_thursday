require_relative '../lib/merchant'
require_relative '../lib/csv_parser'
require 'csv'

class MerchantRepository

  include CsvParser

  attr_reader :merchants,
              :se

  def initialize(csv_file, se)
    @merchants = []
    @se = se
    parser(csv_file).each { |row| @merchants << Merchant.new(row, self) }
  end

  def inspect
    "#<#{self.class} #{@merchants.size} rows>"
  end

  def all
    @merchants
  end

  def find_by_id(id)
    @merchants.find do |merchant|
      merchant if merchant.id == id
    end
  end

  def find_by_name(name)
    @merchants.find do |merchant|
      merchant if merchant.name.downcase == name.downcase
    end
  end

  def find_all_by_name(name)
    @merchants.find_all do |merchant|
      merchant if merchant.name.downcase.include?(name.downcase)
    end
  end

  def find_item(id)
    se.find_item_by_merchant_id(id)
  end

  def items_per_merchant
    merchants.map { |merchant| merchant.items.count }
  end

  def invoices_per_merchant
    merchants.map { |merchant| merchant.invoices.count }
  end

  def find_invoice(id)
    se.invoices.find_all_by_merchant_id(id)
  end

end
