require_relative 'test_helper'
require_relative "../lib/sales_engine"



class SalesEngineTest < Minitest::Test

  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({
      :items          => "./test/fixtures/items_sample.csv",
      :merchants      => "./test/fixtures/merchants_sample.csv",
      :invoices       => "./test/fixtures/invoices_sample.csv",
      :invoice_items  => "./test/fixtures/invoice_items_sample.csv",
      :customers      => "./test/fixtures/customers_sample.csv",
      :transactions   => "./test/fixtures/transactions_sample.csv"
    })
  end

  def test_it_exists
    assert_instance_of SalesEngine, se
  end

  def test_it_has_default_csvs
    default = {items: './data/blanks/items_blank.csv',
               merchants: './data/blanks/merchants_blank.csv',
               invoices: './data/blanks/invoices_blank.csv',
               invoice_items: './data/blanks/invoice_items_blank.csv',
               customers: './data/blanks/customers_blank.csv',
               transactions: './data/blanks/transactions_blank.csv'}

    assert_equal se.default_csvs, default
  end

  def test_it_merges_into_default_csvs
    new_csv = {items: './data/items.csv'}
    merged_csvs = se.merge_in_given_csvs(new_csv)

    assert_equal './data/items.csv', merged_csvs[:items]
    assert_equal './data/blanks/merchants_blank.csv', merged_csvs[:merchants]
    assert_equal './data/blanks/invoices_blank.csv', merged_csvs[:invoices]
    assert_equal './data/blanks/invoice_items_blank.csv', merged_csvs[:invoice_items]
    assert_equal './data/blanks/customers_blank.csv', merged_csvs[:customers]
    assert_equal './data/blanks/transactions_blank.csv', merged_csvs[:transactions]
  end

  def test_it_has_attributes
    assert_instance_of InvoiceRepository, se.invoices
    assert_instance_of ItemRepository, se.items
    assert_instance_of MerchantRepository, se.merchants
    assert_instance_of InvoiceItemRepository, se.invoice_items
    assert_instance_of CustomerRepository, se.customers
    assert_instance_of TransactionRepository, se.transactions
  end

  def test_it_returns_items_by_merchant_id
    items = se.find_item_by_merchant_id(12334195)
    nil_items = se.find_item_by_merchant_id(23423523)

    assert_equal 10, items.count
    items.each do |i|
      assert_instance_of Item, i
      assert_equal 12334195, i.merchant_id
    end
    assert_equal [], nil_items
  end

  def test_it_returns_merchants_by_id
    merchant = se.find_merchant_by_id(12334195)
    nil_merch = se.find_merchant_by_id(23423523)

    assert_instance_of Merchant, merchant
    assert merchant.id == 12334195
    assert_nil nil_merch
  end

  def test_it_returns_array_of_items_per_merchant
    items_per = se.items_per_merchant

    assert_equal 7, items_per.count
    assert_equal [1, 3, 1, 10, 2, 3, 1], items_per
  end

  def test_it_returns_array_of_invoices_per_merchant
    invoices_per = se.invoices_per_merchant

    assert_equal 7, invoices_per.count
    assert_equal [9, 2, 1, 1, 1, 1, 1], invoices_per
  end

  def test_it_find_invoices_by_customer_id
    invoices = se.find_invoices_by_customer_id(157)
    no_invoices = se.find_invoices_by_customer_id(3)

    assert_equal 2, invoices.count
    invoices.each do |i|
      assert_instance_of Invoice, i
      assert_equal 157, i.customer_id
    end
    assert_equal [], no_invoices
  end

  def test_it_returns_invoices_by_invoice_id
    invoice = se.find_invoices_by_invoice_id(2821)

    assert_instance_of Invoice, invoice
    assert_equal 2821, invoice.id
  end

  def test_it_grabs_all_merchants
    merchants = se.grab_all_merchants

    merchants.each do |merchant|
      assert_instance_of Merchant, merchant
    end
  end

  def test_it_grabs_all_items
    items = se.grab_all_items

    items.each do |item|
      assert_instance_of Item, item
    end
  end

  def test_it_grabs_all_invoices
    invoices = se.grab_all_invoices

    invoices.each do |invoice|
      assert_instance_of Invoice, invoice
    end
  end

end
