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

  def test_it_finds_item_by_item_id
    item = mock('item')
    invoice_repo.se.stubs(:find_item_by_id).returns(item)

    assert_equal item, invoice_repo.find_item_by_id(4)
  end

  def test_it_grabs_all_items
    item_1 = mock('items1')
    item_2 = mock('items2')
    item_3 = mock('items3')
    invoice_repo.se.stubs(:grab_all_items).returns([item_1, item_2, item_3])

    assert_equal 3, invoice_repo.grab_all_items.count
    assert_equal [item_1, item_2, item_3], invoice_repo.grab_all_items
  end

end
