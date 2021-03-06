require_relative 'test_helper'
require_relative "../lib/transaction_repository"

class TransactionRepositoryTest < Minitest::Test

  attr_reader :tr_repo

  def setup
    parent = ('sales_engine')
    @tr_repo = TransactionRepository.new("./test/fixtures/transactions_sample.csv", parent)
  end

  def test_it_exists
    assert_instance_of TransactionRepository, tr_repo
  end

  def test_transactions_all_and_transactions_is_filled
    tr_repo.all.each do |tr|
      assert_instance_of Transaction, tr
    end
  end

  def test_it_returns_transaction_by_id
    tr = tr_repo.find_by_id(4)
    nil_tr = tr_repo.find_by_id(34)

    assert_instance_of Transaction, tr
    assert_equal 4, tr.id
    assert_nil nil_tr
  end

  def test_it_finds_all_by_invoice_id
    transactions = tr_repo.find_all_by_invoice_id(2179)
    nil_tr = tr_repo.find_all_by_invoice_id(23422)

    assert_equal 2, transactions.count
    transactions.each do |tr|
      assert_instance_of Transaction, tr
      assert_equal 2179, tr.invoice_id
    end
    assert_equal [], nil_tr
  end

  def test_it_finds_all_by_card_number
    transactions = tr_repo.find_all_by_credit_card_number(4068631943231473)
    nil_tr = tr_repo.find_all_by_credit_card_number(4068624534253334)

    assert_equal 2, transactions.count
    transactions.each do |tr|
      assert_instance_of Transaction, tr
      assert_equal 4068631943231473, tr.credit_card_number
    end
    assert_equal [], nil_tr
    assert_nil nil_tr.first
  end

  def test_it_finds_all_by_result
    succ_transactions = tr_repo.find_all_by_result("success")
    failed_transactions = tr_repo.find_all_by_result("failed")
    nil_transactions = tr_repo.find_all_by_result("pending")

    assert_equal 8, succ_transactions.count
    assert_equal 2, failed_transactions.count
    succ_transactions.each do |tr|
      assert_instance_of Transaction, tr
      assert_equal 'success', tr.result
    end
    failed_transactions.each do |tr|
      assert_instance_of Transaction, tr
      assert_equal 'failed', tr.result
    end
    assert_equal [], nil_transactions
  end

  def test_it_finds_invoices_by_invoice_id
    invoice_1 = mock('invoice')
    invoice_2 = mock('invoice2')
    invoice_3 = mock('invoice3')
    tr_repo.se.stubs(:find_invoices_by_invoice_id).returns([invoice_1, invoice_2, invoice_3])

    assert_equal [invoice_1, invoice_2, invoice_3], tr_repo.find_invoice_by_invoice_id(4)
  end

end
