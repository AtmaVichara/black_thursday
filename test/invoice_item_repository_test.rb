require_relative '../lib/invoice_item_repository'
require_relative '../test/test_helper'

class InvoiceItemRepositoryTest < Minitest::Test

  attr_reader :ir

  def setup
    parent = mock('sales_engine')
    @ir = InvoiceItemRepository.new("./test/fixtures/invoice_items_sample.csv", parent)
  end

  def test_it_exists
    assert_instance_of InvoiceItemRepository, ir
  end

  def test_invoice_items_is_filled
    assert_equal 22, ir.invoice_items.count
    ir.all.each do |invoice_item|
      assert_instance_of InvoiceItem, invoice_item
    end
  end

  def test_it_returns_invoice_item_by_id
    invoice_item = ir.find_by_id(4)
    nil_item = ir.find_by_id(6890)

    assert_instance_of InvoiceItem, invoice_item
    assert_nil nil_item
  end

  def test_it_returns_all_items_by_id
    invoice_items = ir.find_all_by_item_id(263454779)
    nil_items = ir.find_all_by_item_id(23232323)

    invoice_items.each do |invoice_item|
      assert_instance_of InvoiceItem, invoice_item
      assert_equal 263454779, invoice_item.item_id
    end
    assert_equal [], nil_items
    assert_nil nil_items.first
  end

  def test_it_returns_all_invoice_items_by_invoice_id
    invoice_items = ir.find_all_by_invoice_id(1)
    nil_items = ir.find_all_by_invoice_id(23)

    invoice_items.each do |invoice_item|
      assert_instance_of InvoiceItem, invoice_item
      assert_equal 1, invoice_item.invoice_id
    end
    assert_equal [], nil_items
    assert_nil nil_items.first
  end

end
