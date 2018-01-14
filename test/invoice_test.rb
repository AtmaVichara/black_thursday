require 'time'
require_relative 'test_helper'
require_relative '../lib/invoice'

class InvoicesTest < Minitest::Test

  attr_reader :invoice

  def setup
    invoice_data = {:id          => 6,
                    :customer_id => 7,
                    :merchant_id => 8,
                    :status      => "pending",
                    :created_at  => "2012-01-07 15:15:22 -0700",
                    :updated_at  => "2018-01-07 15:15:22 -0700"}
    parent = mock("repository")
    @invoice = Invoice.new(invoice_data, parent)
  end

  def test_it_has_attributes
    assert_equal 6, invoice.id
    assert_equal 7, invoice.customer_id
    assert_equal 8, invoice.merchant_id
    assert_equal :pending, invoice.status
    assert_equal Time.parse("2012-01-07 15:15:22 -0700"), invoice.created_at
    assert_equal Time.parse("2018-01-07 15:15:22 -0700"), invoice.updated_at
  end

  def test_it_returns_items_by_id_in_invoice_items
    ii = mock('invoice_item')
    ii_2 = mock('invoice_item2')
    ii_3 = mock('invoice_item3')
    invoice.invoice_repo.stubs(:find_invoice_items_by_id).returns([ii, ii_2, ii_3])

    assert_equal [ii, ii_2, ii_3], invoice.invoice_items
  end

  def test_it_returns_transactions_by_invoice_id
    item1 = mock('item')
    item2 = mock('item2')
    item3 = mock('item3')
    ii = stub(item_id: [item1, item2, item3])
    invoice.invoice_repo.stubs(:find_invoice_items_by_id).returns([ii])
    invoice.invoice_repo.stubs(:find_item_by_id).returns(ii.item_id)

    assert_equal [item1, item2, item3], invoice.items.flatten(1)
  end

  def test_it_returns_customers_by_invoice_id
    c = mock('customer')
    ii = stub(customer_id: c)
    invoice.invoice_repo.stubs(:find_customer_by_customer_id).returns(ii.customer_id)

    assert_equal c, invoice.customer
  end

  def test_it_returns_merchant_by_merchant_id
    m = mock('merchant')
    invoice.invoice_repo.stubs(:find_merchant_by_merchant_id).returns(m)

    assert_equal m, invoice.merchant
  end

  def test_it_returns_success_for_is_paid_in_full
    tr = mock('transaction')
    invoice.invoice_repo.stubs(:find_transactions_by_invoice_id).returns(tr)

    assert_equal tr, invoice.transactions
  end

  def test_it_is_paid_in_full
    tr_1 = stub(result: 'success')
    tr_2 = stub(result: 'failed')
    tr_3 = stub(result: 'failed')

    invoice.invoice_repo.stubs(:find_transactions_by_invoice_id).returns([tr_1, tr_2, tr_3])

    assert_equal true, invoice.is_paid_in_full?

    invoice.invoice_repo.stubs(:find_transactions_by_invoice_id).returns([tr_2, tr_3])

    assert_equal false, invoice.is_paid_in_full?
  end

  def test_it_returns_total_dollar_amount_for_invoice
    ii = stub(unit_price: 1500,
              quantity: 2)
    ii_2 = stub(unit_price: 1000,
               quantity: 2)
    ii_3 = stub(unit_price: 500,
               quantity: 4)
    invoice.invoice_repo.stubs(:find_invoice_items_by_id).returns([ii, ii_2, ii_3])

    assert_equal 7000, invoice.total
  end

end
