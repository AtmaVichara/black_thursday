require 'csv'
require_relative '../lib/invoice'



class InvoiceRepository

  attr_reader :invoices_csv,
              :invoices,
              :se

  def initialize(csv_file, se)
    @invoices_csv = csv_file#CSV.open csv_file, headers: true, header_converters: :symbol
    @invoices = []
    @se = se
    invoices_csv.each do |row|
      id    =  row[:id]
      customer_id  =  row[:customer_id]
      merchant_id =  row[:merchant_id]
      status    =   row [:status]
      created_at =  Time.parse(row[:created_at])
      updated_at = Time.parse(row[:updated_at])
      @invoices << Invoice.new({
        id: id,
        customer_id: customer_id,
        merchant_id: merchant_id,
        status:   status,
        created_at: created_at,
        updated_at: updated_at,
        invoice_repo: self
        })
    end
   @invoices
  end

  def all
    @invoices
  end

  def find_by_id(number)
    @invoices.find do |num|
      num.id.to_i == number
    end
  end

  def find_all_by_customer_id(number)
    @invoices.find_all do |num|
      num.customer_id.to_i == number
    end
  end

  def find_all_by_merchant_id(number)
    @invoices.find_all do |num|
      num.merchant_id.to_i == number
    end
  end

  def find_all_by_status(status_input)
    @invoices.find_all do |num|
      num.status == status_input
    end
  end

  def inspect
    "#<#{self.class} #{@invoices.size} rows>"
  end

end
