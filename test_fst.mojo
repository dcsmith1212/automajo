from fst import Weight
from testing import assert_equal, assert_almost_equal

def test_weight_arithmetic():
    assert_equal(Weight(0.0), Weight.zero())
    assert_equal(Weight(1.0), Weight.one())

    var sum: Weight = Weight(0.2) + Weight(0.8)
    assert_almost_equal(sum.value, Weight(1.0).value)

    var diff: Weight = Weight(12.6) - Weight(3.2)
    assert_almost_equal(diff.value, Weight(9.4).value)

    var prod: Weight = Weight(2.3) * Weight(3)
    assert_almost_equal(prod.value, Weight(6.9).value)

    var quot: Weight = Weight(6.8) / Weight(2.0)
    assert_almost_equal(quot.value, Weight(3.4).value)