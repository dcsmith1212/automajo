from collections import List, Dict

from .weight import Weight
from .arc import Arc
from .state import State, StateId
from .symbol import SymbolTable
    
struct Fst:
    var start: State
    var states: List[State]
    var input_symbols: SymbolTable
    var output_symbols: SymbolTable
        
    fn __init__(inout self):
        # TODO: Implement kNoState concept or figure out how to use None here
        self.start = State(0)
        self.states = List[State]()
        self.input_symbols = SymbolTable()
        self.output_symbols = SymbolTable()

    fn __copyinit__(inout self, existing: Self):
        self.start = existing.start
        self.states = existing.states
        self.input_symbols = existing.input_symbols
        self.output_symbols = existing.output_symbols
    
    fn __moveinit__(inout self, owned existing: Self):
        self.start = existing.start
        self.states = existing.states^
        self.input_symbols = existing.input_symbols^
        self.output_symbols = existing.output_symbols^

    fn __str__(self) -> String:
        var has_symbols = len(self.input_symbols) > 0 and len(self.output_symbols) > 0
        if has_symbols:
            print('has symbols!')
            try:
                var string = 'start = ' + str(self.start.id)
                for state_ref in self.states:
                    var state = state_ref[]
                    for arc_ref in state.arcs:
                        arc = arc_ref[]
                        string += '\n' + str(state.id) + ' --- ' + self.input_symbols[arc.ilabel] + ':' + 
                                  self.output_symbols[arc.olabel] + ' [' + str(arc.weight.value) +
                                  '] ---> ' + str(arc.nextstate)
                    
                    if state.is_final():
                        string += '\n' + str(state.id) + ' [' + str(state.final_weight.value) + ']'

                return string
            except:
                print('Error: got label that was not in symbol table')
                return ''
        else:
            print('no symbols')
            var string = 'start = ' + str(self.start.id)
            for state_ref in self.states:
                var state = state_ref[]
                for arc_ref in state.arcs:
                    arc = arc_ref[]
                    string += '\n' + str(state.id) + ' ' + str(arc)
                
                if state.is_final():
                    string += '\n' + str(state.id) + ' [' + str(state.final_weight.value) + ']'
            
            return string

    # TODO: This is a good place to really learn about the ownership model
    # Is "state" a separate copy of the object in the list "self.states"?
    # What happens when I call "add_arc"... do I need to explicitly transfer
    # ownership of "arc" here?
    fn add_arc(inout self, state_id: StateId, owned arc: Arc):
        if not self.has_state(state_id):
            # TODO: Implement better error handling
            print('State ID ' + str(state_id) + ' does not exist.')
            return
        
        var state = self.states[state_id]
        state.add_arc(arc^)
        self.states[state_id] = state

    fn add_state(inout self) -> State:
        var state = State(id=len(self.states))
        self.states.append(state)
        return state
    
    fn add_states(inout self, n: UInt):
        for _ in range(n):
            _ = self.add_state()
    
    fn has_state(self, id: StateId) -> Bool:       
        return id < len(self.states)
    
    fn num_states(self) -> UInt:
        return len(self.states)

    fn set_final(inout self, id: StateId, owned weight: Weight):
        if not self.has_state(id):
            # TODO: Implement better error handling
            print('State ID ' + str(id) + ' does not exist.')
            return
        
        self.states[id].final_weight = weight
    