require_relative 'test_helper'
require_relative '../lib/invoice_repository'
require_relative '../lib/sales_engine'

class InvoiceRepositoryTest < Minitest::Test

  attr_reader :invoice_repo

  def setup
    parent = mock('sales_engine')
    @invoice_repo = InvoiceRepository.new("./test/fixtures/invoices_sample.csv", parent)
  end

  def test_it_exists
    assert_instance_of InvoiceRepository, invoice_repo
  end

  def test_it_returns_all_invoices
    assert_equal 20, invoice_repo.all.count
    invoice_repo.all.each do |invoice|
      assert_instance_of Invoice, invoice
    end
  end

  def test_it_finds_by_id
    invoice = invoice_repo.find_by_id(641)
    nil_invoice = invoice_repo.find_by_id(2342)

    assert_instance_of Invoice, invoice
    assert_equal 641, invoice.id
    assert_nil nil_invoice
  end

  def test_it_finds_all_customers_id
    invoices = invoice_repo.find_all_by_customer_id(528)
    nil_invoices = invoice_repo.find_all_by_customer_id(52823)

    assert_equal 1, invoices.count
    invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal 528, invoice.customer_id
    end
    assert_equal [], nil_invoices
  end

  def test_it_finds_all_merchant_id
    invoices = invoice_repo.find_all_by_merchant_id(12334141)
    nil_invoices = invoice_repo.find_all_by_merchant_id(22222222)

    assert_equal 9, invoices.count
    invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal 12334141, invoice.merchant_id
    end
    assert_equal [], nil_invoices
  end

  def test_it_finds_all_invoice_id
    invoices = invoice_repo.find_all_by_invoice_id(1053)

    assert_equal 4, invoices.count
    invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal 1053, invoice.id
    end 
  end

  def test_it_finds_all_by_status
    shipped_invoices = invoice_repo.find_all_by_status(:shipped)
    pending_invoices = invoice_repo.find_all_by_status(:pending)
    returned_invoices = invoice_repo.find_all_by_status(:returned)

    assert_equal 13, shipped_invoices.count
    shipped_invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal :shipped, invoice.status
    end
    assert_equal 3, pending_invoices.count
    pending_invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal :pending, invoice.status
    end
    assert_equal 4, returned_invoices.count
    returned_invoices.each do |invoice|
      assert_instance_of Invoice, invoice
      assert_equal :returned, invoice.status
    end
  end

  def test_it_finds_merchant_by_merchant_id
    merchant = mock('merchant')
    invoice_repo.se.stubs(:find_merchant_by_id).returns(merchant)

    assert_equal merchant, invoice_repo.find_merchant_by_merchant_id(3)
  end

  def test_it_grabs_array_of_invoices
    skip
    se = SalesEngine.from_csv({
      :merchants => "./test/fixtures/merchants_sample.csv",
      :invoices => "./test/fixtures/invoices_sample.csv"
    })
    found_merchants = se.merchants.grab_array_of_invoices

    assert_equal [8, 2, 1, 1, 1, 1, 1], found_merchants
    assert_equal 7, found_merchants.count
  end

  def test_it_grabs_all_items
    skip
    se = SalesEngine.from_csv({
      invoices: "./test/fixtures/invoices_sample.csv",
      invoice_items: "./test/fixtures/invoice_items_sample.csv",
      customers: "./test/fixtures/customers_sample.csv",
      merchants: "./test/fixtures/merchants_sample.csv",
      items: "./test/fixtures/items_sample.csv"
    })
    result = se.invoices.grab_all_items

    assert_equal 25, result.count
  end

end
