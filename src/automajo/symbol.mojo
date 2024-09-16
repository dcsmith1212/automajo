from collections import Dict, Set

alias Label = Int # TODO: Eventually this could just be UInt
alias Symbol = String

@value
struct SymbolTable:
    var label2symbol: Dict[Label, Symbol]
    var symbol2label: Dict[Symbol, Label]

    fn __init__(inout self):
        self.label2symbol = Dict[Label, Symbol]()
        self.symbol2label = Dict[Symbol, Label]()
    
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

    fn __setitem__(inout self, label: Label, owned symbol: Symbol) raises:
        if label in self.label2symbol:
            raise Error('Label ' + str(label) + ' already in table with symbol "' +
                        self.__getitem__(label) + '".')
        
        self.label2symbol[label] = symbol
        self.symbol2label[symbol] = label

    fn __setitem__(inout self, owned symbol: Symbol, label: Label) raises:
        if label in self.label2symbol:
            raise Error('Symbol ' + symbol + ' already in table with label "' +
                        str(self.__getitem__(symbol)) + '".')
        
        self.__setitem__(label, symbol)
    
    fn __str__(self) -> String:
        string = String()
        for item in self.label2symbol.items():
            label = item[].key
            symbol = item[].value
            string += str(label) + '\t' + symbol + '\n'
        return string
    
        

