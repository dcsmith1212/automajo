from automajo.symbol import SymbolTable
from testing import assert_equal

def test_getitem_setitem():
    syms = SymbolTable()
    syms[0] = '<eps>'
    assert_equal(syms[0], '<eps>')
    assert_equal(syms['<eps>'], 0)
    assert_equal(len(syms), 1)

    syms[2] = 'the'
    # syms['the'] = 1 # TODO: Why doesn't this compile?
    assert_equal(syms[2], 'the')
    assert_equal(syms['the'], 2)
    assert_equal(len(syms), 2)

    l = syms.add('quick')
    assert_equal(l, 1)

    l = syms.add('brown')
    assert_equal(l, 3)