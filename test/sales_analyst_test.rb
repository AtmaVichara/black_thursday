require_relative 'test_helper'
require_relative '../lib/sales_analyst'

class SalesAnalystTest < Minitest::Test

  attr_reader :sales_analyst

  def setup

    @se = SalesEngine.new({
      :items         => "./test/fixtures/items_sample.csv",
      :merchants     => "./test/fixtures/merchants_sample.csv",
      :invoices      => "./test/fixtures/invoices_sample.csv",
      :invoice_items => "./test/fixtures/invoice_items_sample.csv",
      :customers     => "./test/fixtures/customers_sample.csv",
      :transactions  => "./test/fixtures/transactions_sample.csv"
    })
    @sales_analyst = SalesAnalyst.new(@se)
  end

  def test_it_exists
    assert_instance_of SalesAnalyst, sales_analyst
  end

  def test_it_returns_average
    assert_equal 3.71, sales_analyst.average_items_per_merchant
    refute_equal 0.43, sales_analyst.average_items_per_merchant
  end

  def test_it_returns_item_price_standard_deviation
    assert_equal 230.66, sales_analyst.item_price_standard_deviation
  end

  def test_it_returns_standard_deviation
    assert_equal 3.3, sales_analyst.average_items_per_merchant_standard_deviation
  end

  def test_it_returns_array_of_item_totals_for_merchants
    assert_equal [1, 3, 1, 10, 2, 3, 1], sales_analyst.number_of_items_per_merchant
  end

  def test_it_returns_merchants_with_highest_item_count
    assert_equal 1, sales_analyst.merchants_with_high_item_count.count
    assert_instance_of Merchant, sales_analyst.merchants_with_high_item_count.first
  end

  def test_it_returns_top_merchants_by_invoice_count
    assert_equal 1, sales_analyst.top_merchants_by_invoice_count.count
    assert_instance_of Merchant, sales_analyst.top_merchants_by_invoice_count.first
  end

  def test_it_returns_bottom_merchants_by_invoice_count
    double_deviation = (sales_analyst.average_invoices_per_merchant_standard_deviation * 2)
    mean = sales_analyst.average_invoices_per_merchant - double_deviation

    assert_equal (-3.2399999999999998), mean
    assert_equal 0, sales_analyst.bottom_merchants_by_invoice_count.count
  end

  def test_it_returns_average_price_of_merchants_items
    assert_equal 0.2999e2, sales_analyst.average_item_price_for_merchant(12334105)
  end

  def test_it_returns_average_invoices_per_merchant
    assert_equal 2.86, sales_analyst.average_invoices_per_merchant
  end

  def test_it_returns_standard_deviation_for_invoices
    assert_equal 3.05, sales_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_it_returns_status_of_invoices_as_percentage
    assert_equal 15.0, sales_analyst.invoice_status(:pending)
    assert_equal 65.0 , sales_analyst.invoice_status(:shipped)
    assert_equal 20.0, sales_analyst.invoice_status(:returned)
  end

  def test_it_returns_group_invoices_by_day
    days = ["Sunday", "Monday", "Wednesday", "Thursday", "Friday", "Tuesday", "Saturday"]

    assert_equal 7, sales_analyst.group_invoices_by_day.count
    sales_analyst.group_invoices_by_day.values.each do |value|
      value.each do |v|
        assert_instance_of Invoice, v
      end
    end
    sales_analyst.group_invoices_by_day.keys.each do |key|
      assert days.include?(key)
    end
  end

  def test_it_returns_average_invoices_per_day
    assert_equal 2, sales_analyst.average_invoices_per_day
  end

  def test_it_returns_average_invoices_per_day_standard_deviation
    assert_equal 2.65, sales_analyst.average_invoices_per_day_standard_deviation
  end

  def test_it_returns_top_days_by_invoice_count
    assert_equal ["Friday", "Tuesday"], sales_analyst.top_days_by_invoice_count
  end

  def test_it_returns_group_by_status
    status = [:shipped, :pending, :returned]

    assert_equal 3, sales_analyst.group_by_status.count
    sales_analyst.group_by_status.keys.each do |key|
      assert status.include?(key)
    end
    sales_analyst.group_by_status.values.each do |value|
      value.each do |v|
        assert_instance_of Invoice, v
      end
    end
  end

  def test_it_returns_array_of_invoices_per_day
    assert_equal [2, 7, 6, 1, 2, 1, 1], sales_analyst.invoices_per_day
  end

  def test_average_invoices_per_day_standard_deviation
    assert_equal 3.05, sales_analyst.average_invoices_per_merchant_standard_deviation
  end

  def test_it_returns_total_revenue_by_date
    assert_equal 0.2023211e5, sales_analyst.total_revenue_by_date(Time.parse('2009-12-09'))
  end

  def test_it_grabs_invoice_by_date
    invoice = sales_analyst.grab_invoice_by_date(Time.parse('2009-12-09'))

    assert_instance_of Invoice, invoice.first
    assert_equal 3, invoice.first.id
    assert_equal (Time.parse('2009-12-09')).to_i, invoice.first.created_at.to_i
  end

  def test_it_grabs_invoice_item_by_date
    invoice_items = sales_analyst.grab_invoice_items_by_invoice_date(Time.parse('2009-12-09'))

    assert_equal 5, invoice_items.count
    invoice_items.each do |ii|
      assert_instance_of InvoiceItem, ii
      assert_equal 3, ii.invoice_id
    end
  end

  def test_it_returns_top_earners
    assert_equal 7, sales_analyst.top_revenue_earners.count
    sales_analyst.top_revenue_earners.each do |merchant|
      assert_instance_of Merchant, merchant
    end
    assert_equal "jejum", sales_analyst.top_revenue_earners.first.name
  end

  def test_it_grabs_merchants_with_only_one_item
    assert_equal 3, sales_analyst.merchants_with_only_one_item.count
    sales_analyst.merchants_with_only_one_item.each do |merchant|
      assert_instance_of Merchant, merchant
      assert_equal 1, merchant.items.count
    end
  end

  def test_it_grabs_merchants_with_pending_invoices
    assert_equal 7, sales_analyst.merchants_with_pending_invoices.count
    assert sales_analyst.merchants_with_pending_invoices.each do |merchant|
       assert_instance_of Merchant, merchant
    end
    assert_equal "jejum", sales_analyst.merchants_with_pending_invoices.first.name
  end

  def test_it_returns_merchants_revenue
    assert_equal 88208, sales_analyst.revenue_by_merchant(12334141).to_i
    assert_equal 0, sales_analyst.revenue_by_merchant(222222222).to_i
  end

  def test_it_grabs_merchants_ranked_by_revenue
    assert_equal 7, sales_analyst.merchants_ranked_by_revenue.count
    sales_analyst.merchants_ranked_by_revenue.each do |merchant|
      assert_instance_of Merchant, merchant
    end
    assert_equal "jejum", sales_analyst.merchants_ranked_by_revenue.first.name
  end

  def test_it_grabs_merchants_with_only_one_item_registered_in_month
    assert_equal 2, sales_analyst.merchants_with_only_one_item_registered_in_month("June").count
    sales_analyst.merchants_with_only_one_item_registered_in_month("June").each do |merchant|
      assert_instance_of Merchant, merchant
      assert_equal "June", merchant.created_at.strftime("%B")
    end
  end

  def test_it_grab_invoices_items_from_merchants
    paid_invoices = sales_analyst.grab_paid_invoice_items_from_merchants(12334141)

    assert_equal 16, paid_invoices.count
    paid_invoices.each do |ii|
      assert_instance_of InvoiceItem, ii
    end
  end

  def test_it_groups_items_to_invoice_attributes
    grouped_attributes = sales_analyst.group_items_to_invoice_attributes(12334141)

    assert_equal 6, grouped_attributes.count
    assert_equal [263418403, [7, 0.5384e3]], grouped_attributes.first
    assert_instance_of Hash, grouped_attributes
    grouped_attributes.keys.each do |k|
      assert_instance_of Integer, k
    end
    grouped_attributes.values.each do |v|
      assert_instance_of Array, v
    end
  end

  def test_it_grabs_most_sold_items
    most_sold = sales_analyst.grab_most_sold_items(12334141)

    refute_equal [], most_sold
    assert_equal 2, most_sold.count
    assert_equal [263465463, 263415463], most_sold
  end

  def test_it_grabs_most_sold_item_for_merchant
    most_sold = sales_analyst.most_sold_item_for_merchant(12334141)

    assert_equal 1, most_sold.count
    assert_instance_of Item, most_sold.first
    assert_equal "bracciale rigido margherite", most_sold.first.name
  end

  def test_it_groups_items_to_revenue
    grouped_revenue = sales_analyst.group_items_to_revenue(12334141)
    actual_grouped_revenue = {263418403=>0.37688e4,
                              263501136=>0.358218e4,
                              263426891=>0.22129e4,
                              263540674=>0.493842e4,
                              263415463=>0.74005e4,
                              263465463=>0.74005e4}


    assert_equal actual_grouped_revenue, grouped_revenue
  end

  def test_it_returns_top_item_by_revenue_id
    top_item = sales_analyst.top_item_by_revenue_id(12334141)

    assert_equal 12, top_item.count
    assert_equal [263465463, 0.74005e4, 263415463, 0.74005e4], top_item[0..3]
  end

end
