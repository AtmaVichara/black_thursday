require_relative 'test_helper'
require_relative "../lib/merchant_repository"
require_relative "../lib/sales_engine"

class MerchantRepositoryTest < Minitest::Test

  attr_reader :merchant_repo

  def setup
    parent = mock('merchant_repo')
    @merchant_repo = MerchantRepository.new("./test/fixtures/merchants_sample.csv", parent)
  end

  def test_it_exists
    assert_instance_of MerchantRepository, merchant_repo
  end

  def test_Merchants_is_filled
    merchant_repo.all.each do |merchant|
      assert_instance_of Merchant, merchant
    end
  end

  def test_it_returns_matches_by_id
    found_merchant = merchant_repo.find_by_id(12334185)
    nil_merchant = merchant_repo.find_by_id(22222222)

    assert_instance_of Merchant, found_merchant
    assert_equal 12334185, found_merchant.id
    assert_equal "Madewithgitterxx", found_merchant.name
    assert_nil nil_merchant
  end

  def test_it_returns_matches_by_name
    found_merchant = merchant_repo.find_by_name("FlavienCouche")
    nil_merchant = merchant_repo.find_by_name("BOMBASTIC!!!!")

    assert_equal "FlavienCouche", found_merchant.name
    assert_equal 12334195, found_merchant.id
    assert_nil nil_merchant
  end

  def test_it_returns_matches_for_all_by_name
    found_merchants = merchant_repo.find_all_by_name("an")

    assert_equal 1, found_merchants.count
    found_merchants.each do |merchant|
      assert_instance_of Merchant, merchant
      assert_includes found_merchants.first.name.downcase, "an"
    end
  end

  def test_it_returns_items_for_a_merchant
    item_1 = mock('item')
    item_2 = mock('item')
    item_3 = mock('item')
    merchant_repo.se.stubs(:find_item_by_merchant_id).returns([item_1, item_2, item_3])

    assert_equal [item_1, item_2, item_3], merchant_repo.find_item(3)
  end

  def test_it_grabs_array_of_items
    se = SalesEngine.from_csv({
      :items     => "./test/fixtures/items_sample.csv",
      :merchants => "./test/fixtures/merchants_sample.csv",
    })
    found_merchants = se.merchants.items_per_merchant

    assert_equal [1, 3, 1, 10, 2, 3, 1], found_merchants
    assert_equal 7, found_merchants.count
  end

  def test_it_grabs_array_of_invoices
    se = SalesEngine.from_csv({
      :merchants => "./test/fixtures/merchants_sample.csv",
      :invoices => "./test/fixtures/invoices_sample.csv"
    })
    found_merchants = se.merchants.invoices_per_merchant

    assert_equal [9, 2, 1, 1, 1, 1, 1], found_merchants
    assert_equal 7, found_merchants.count
  end

  def test_it_finds_invoices_by_id
    se = SalesEngine.from_csv({
      :merchants => "./test/fixtures/merchants_sample.csv",
      :invoices => "./test/fixtures/invoices_sample.csv"
    })
    found_merchants = se.merchants.find_invoice(12334141)

    assert_equal 641, found_merchants.first.id
    assert_equal :shipped, found_merchants.first.status
    assert_equal 9, found_merchants.count
  end

end
