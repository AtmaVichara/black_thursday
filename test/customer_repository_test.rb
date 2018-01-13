require_relative 'test_helper'
require_relative "../lib/customer_repository"

class CustomerRepositoryTest < Minitest::Test

  attr_reader :customer

  def setup
    parent = mock("sales_engine")
    @customer = CustomerRepository.new("./test/fixtures/customers_sample.csv", parent)
  end

  def test_it_exists
    assert_instance_of CustomerRepository, customer
  end

  def test_all_returns_all_customers_and_customers_is_filled
    customer.all.each do |c|
      assert_instance_of Customer, c
    end
  end

  def test_it_returns_correct_id
    found_id_1 = customer.find_by_id(4)
    found_id_2 = customer.find_by_id(233342)

    assert_instance_of Customer, found_id_1
    assert_equal "Leanne", found_id_1.first_name
    assert_equal "Braun", found_id_1.last_name
    assert_nil found_id_2
  end

  def test_it_finds_all_by_first_name
    found_customers_1 = customer.find_all_by_first_name("Joey")
    found_customers_2 = customer.find_all_by_first_name("BOMBASTIC!")

    assert_equal 2, found_customers_1.count
    found_customers_1.each do |c|
      assert_instance_of Customer, c
      assert_equal true, c.first_name.include?("Joey")
    end
    assert_equal [], found_customers_2
    assert_nil found_customers_2.first
  end

  def test_it_finds_all_by_last_name
    found_customers_1 = customer.find_all_by_last_name("Ondricka")
    found_customers_2 = customer.find_all_by_last_name("BOMBASTIC!!!")

    assert_equal 2, found_customers_1.count
    found_customers_1.each do |c|
      assert_instance_of Customer, c
      assert_equal true, c.last_name.include?("Ondricka")
    end
    assert_equal [], found_customers_2
    assert_nil found_customers_2.first
  end

  def test_it_finds_all_invoices_by_customer_id
    invoice_1 = mock('invoice')
    invoice_2 = mock('invoice2')
    invoice_3 = mock('invoice3')
    customer.se.stubs(:find_invoices_by_customer_id).returns([invoice_1, invoice_2, invoice_3])

    assert_equal [invoice_1, invoice_2, invoice_3], customer.find_all_invoices_by_id(4)
  end

end
