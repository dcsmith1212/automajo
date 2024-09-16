from automajo.symbol import SymbolTable
from testing import assert_equal

def test_getitem_setitem():
    syms = SymbolTable()
    syms[0] = '<eps>'
    assert_equal(syms[0], '<eps>')
    assert_equal(syms['<eps>'], 0)
    assert_equal(len(syms), 1)

    syms.__setitem__('the', 1)
    # syms['the'] = 1 # TODO: Why doesn't this compile?
    assert_equal(syms[1], 'the')
    assert_equal(syms['the'], 1)
    assert_equal(len(syms), 2)

