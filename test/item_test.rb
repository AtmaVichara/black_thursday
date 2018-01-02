require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
end
require "minitest/autorun"
require "minitest/pride"
require "./lib/item"
require "bigdecimal"
require "pry"

class ItemTest < Minitest::Test

  def setup
    @item = Item.new({
      :name        => "Pencil",
      :description => "You can use it to write things",
      :unit_price  => BigDecimal.new(10.99,4),
      :created_at  => "2018-01-02 14:37:20 -0700",
      :updated_at  => "2018-01-02 14:37:25 -0700",
    })
  end

  def test_it_exists
    assert_instance_of Item, @item
  end

  def test_it_has_name
    assert_equal "Pencil", @item.name
  end

  def test_it_has_a_description
    assert_equal "You can use it to write things", @item.description
  end

  def test_it_has_unit_price
    assert_equal 0.1099e2, @item.unit_price
  end

  def test_it_creates_at_a_time
    assert_equal "2018-01-02 14:37:20 -0700", @item.created_at
  end

  def test_it_returns_time_updated_at
    assert_equal "2018-01-02 14:37:25 -0700", @item.updated_at
  end

  def test_it_returns_unit_price_to_dollars
    assert_equal "$10.99", @item.unit_price_to_dollars
  end

end