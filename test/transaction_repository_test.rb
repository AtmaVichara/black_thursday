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
    skip
    transaction = TransactionRepository.new("./test/fixtures/transactions_sample.csv", "se")
    found_id = transaction.find_all_by_credit_card_number(4068631943231473)

    assert_equal 2, found_id.count
    refute_equal 1, found_id.count
  end

  def test_it_finds_all_by_result
    skip
    transaction = TransactionRepository.new("./test/fixtures/transactions_sample.csv", "se")
    found_id = transaction.find_all_by_result("success")

    assert_equal 8, found_id.count
    refute_equal 4, found_id.count
  end

  def test_it_finds_invoices_by_id
    skip
    se = SalesEngine.from_csv({
      :merchants => "./test/fixtures/merchants_sample.csv",
      :invoices => "./test/fixtures/invoices_sample.csv",
      :transactions => "./test/fixtures/transactions_sample.csv"
    })
    found_transaction = se.transactions.find_invoice_by_id(2179)

    assert_equal 12334633, found_transaction.merchant_id
    refute_equal 12222222, found_transaction.merchant_id
    assert_equal :returned, found_transaction.status
    assert_equal 433, found_transaction.customer_id
    refute_equal :shipped, found_transaction.status
  end

end
