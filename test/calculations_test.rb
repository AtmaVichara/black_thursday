require_relative 'test_helper'
require_relative '../lib/calculations.rb'


class CalculationsTest < Minitest::Test

  include Calculations

  def test_variance_is_returning_correct_value
    sample_data_1 = [53, 4, 323, 233, 12, 5123, 62, 73, 8, 943, 101]
    sample_data_2 = [5, 4, 3, 2, 1, 5, 6, 7, 8, 9, 10]
    mean_1 = sample_data_1.sum / sample_data_1.count
    mean_2 = sample_data_2.sum / sample_data_2.count

    assert_equal 22943203, variance(mean_1, sample_data_1)
    assert_equal 85 , variance(mean_2, sample_data_2)
  end

  def test_it_returns_correct_standard_deviation
    sample_data_1 = [53, 4, 323, 233, 12, 5123, 62, 73, 8, 943, 101]
    sample_data_2 = [5, 4, 3, 2, 1, 5, 6, 7, 8, 9, 10]
    mean_1 = sample_data_1.sum / sample_data_1.count
    mean_2 = sample_data_2.sum / sample_data_2.count
    var_1 = variance(mean_1, sample_data_1)
    var_2 = variance(mean_2, sample_data_2)

    assert_equal 1514.7, standard_dev(var_1, (sample_data_1.count-1))
    assert_equal 2.83, standard_dev(var_2, (sample_data_2.count-1))
  end



end
