from collections import Optional, Dict, Set

alias Label = Int # TODO: Eventually this could just be UInt
alias Symbol = String




@value
struct SymbolTable:
    var label2symbol: Dict[Label, Symbol]
    var symbol2label: Dict[Symbol, Label]
    var next_label: Label

    @staticmethod
    fn no_label() -> Label:
        return -1
    
    @staticmethod
    fn no_symbol() -> Symbol:
        return 'jdpo93q28yritvurmdsjbndconq9132vb5yi'

    fn __init__(inout self):
        self.label2symbol = Dict[Label, Symbol]()
        self.symbol2label = Dict[Symbol, Label]()

        # This is incremented by _find_next_avail_label so that we
        # always use the smallest available label when users call
        # "add", skipping those that were explicitly used with
        # __setitem__.
        self.next_label = 0
    
    fn __contains__(self, label: Label) -> Bool:
        return label in self.label2symbol
    
    fn __contains__(self, symbol: Symbol) -> Bool:
        return symbol in self.symbol2label
    
    fn __getitem__(self, label: Label) raises -> Symbol:
        return self.label2symbol[label]
    
    fn __getitem__(self, symbol: Symbol) raises -> Label:
        return self.symbol2label[symbol]

    fn __len__(self) -> Int:
        return len(self.label2symbol)
    
    fn __repr__(self) -> String:
        return self.__str__()

    fn __setitem__(inout self, label: Label, symbol: Symbol):
        if label in self:
            try:
                var existing = self[label]
                if existing:
                    print('Label ' + str(label) + ' already in table with symbol "' + existing + '".')
                else:
                    print('Label ' + str(label) + ' is supposedly in this table, but no associated symbol was ' +
                            'found using __getitem__. This should never happen and is a bug in the implementation.')
            except:
                # We should never get here since we check if label is in table
                pass
        
        self.label2symbol[label] = symbol
        self.symbol2label[symbol] = label
        if label == self.next_label:
            self._find_next_avail_label()

    fn __setitem__(inout self, symbol: Symbol, label: Label):
        if symbol in self:
            try:
                var existing = self[symbol]
                if existing:
                    print('Symbol ' + symbol + ' already in table with symbol "' + str(existing) + '".')
                else:
                    print('Symbol ' + symbol + ' is supposedly in this table, but no associated label was ' +
                        'found using __getitem__. This should never happen and is a bug in the implementation.')
            except:
                # We should never get here since we check if label is in table
                pass
        
        self.label2symbol[label] = symbol
        self.symbol2label[symbol] = label
        self.next_label = label + 1
    
    fn __str__(self) -> String:
        string = String()
        for item in self.label2symbol.items():
            label = item[].key
            symbol = item[].value
            string += str(label) + '\t' + symbol + '\n'
        return string
    
    fn add(inout self, symbol: Symbol) -> Label:
        var label = self.next_label
        self.label2symbol[label] = symbol
        self.symbol2label[symbol] = label
        
        self._find_next_avail_label()
        return label

    fn remove(inout self, label: Label) raises:
        if label in self:
            var symbol = self[label]
            try:
                _ = self.label2symbol.pop(label)
                _ = self.symbol2label.pop(symbol)
                if label < self.next_label:
                    self.next_label = label
            except:
                pass # Shouldn't happen because we check if label is in table

    fn remove(inout self, symbol: Symbol) raises:
        if symbol in self:
            var label = self[symbol]
            try:
                _ = self.label2symbol.pop(label)
                _ = self.symbol2label.pop(symbol)
                if label < self.next_label:
                    self.next_label = label
            except:
                pass # Shouldn't happen because we check if label is in table

    fn _find_next_avail_label(inout self):
        while True:
            self.next_label += 1
            if self.next_label not in self:
                return