from collections import List, Dict

@value
struct Weight:
    var value: Float64

    @staticmethod
    fn zero() -> Self:
        return Self(0.0)

    @staticmethod
    fn one() -> Self:
        return Self(1.0)

    fn __add__(self, other: Self) -> Self:
        return Self(self.value + other.value)

    fn __sub__(self, other: Self) -> Self:
        return Self(self.value - other.value)
    
    fn __mul__(self, other: Self) -> Self:
        return Self(self.value * other.value)
    
    fn __truediv__(self, other: Self) -> Self:
        return Self(self.value / other.value)
    
    fn __eq__(self, other: Self) -> Bool:
        return self.value == other.value
    
    fn __ne__(self, other: Self) -> Bool:
        return self.value != other.value
    
    fn __float__(self) -> Float64:
        return self.value
    
    fn __hash__(self) -> UInt:
        return hash(self.value)

    fn __str__(self) -> String:
        return 'Weight(' + str(self.value) + ')'
    
    fn __repr__(self) -> String:
        return self.__str__()


@value
struct Arc:
    var ilabel: Int
    var olabel: Int
    var weight: Weight
    var nextstate: Int

    fn __eq__(self, other: Self) -> Bool:
        return self.ilabel == other.ilabel and
               self.olabel == other.olabel and
               self.weight == other.weight and
               self.nextstate == other.nextstate
    
    fn __ne__(self, other: Self) -> Bool:
        return not self.__eq__(other)

    fn __str__(self) -> String:
        # return 'Arc(ilabel=' + str(self.ilabel) + ', olabel=' + str(self.olabel) +
        #        ', weight=' + str(self.weight) + ', nextstate=' + str(self.nextstate) + ')'
        return '--- ' + str(self.ilabel) + ':' + str(self.olabel) + 
               ' [' + str(self.weight.value) + '] ---> ' + str(self.nextstate)
    
    fn __repr__(self) -> String:
        return self.__str__()


# TODO: Make UInt conform to Hashable in stdlib
alias StateId = UInt

struct State:
    var id: StateId
    var arcs: List[Arc]
    var final_weight: Weight

    fn __init__(inout self, owned id: StateId):
        self.id = id
        self.arcs = List[Arc]()
        # TODO: Implement kNoWeight or figure out how to use None here
        self.final_weight = Weight.zero()

    fn __copyinit__(inout self, existing: Self):
        self.id = existing.id
        self.arcs = existing.arcs
        self.final_weight = existing.final_weight
    
    fn __moveinit__(inout self, owned existing: Self):
        self.id = existing.id
        self.arcs = existing.arcs^
        self.final_weight = existing.final_weight
    
    fn __hash__(self) -> UInt:
        # Should only be one state per ID in an FST
        # TODO: This won't generalize if we change StateId to something
        # other than UInt... Best we can do until UInt is Hashable
        return self.id

    fn __eq__(self, other: Self) -> Bool:
        return self.id == other.id and
               self.arcs == other.arcs and
               self.final_weight == other.final_weight
    
    fn __ne__(self, other: Self) -> Bool:
        return not self.__eq__(other)
    
    fn __str__(self) -> String:
        var string = 'state id = ' + str(self.id)
        if self.is_final():
            string += ' [' + str(self.final_weight.value) + ']'

        for arc in self.arcs:
            string += '\n' + str(self.id) + ' ' + str(arc[])
        
        return string
    
    fn add_arc(inout self, owned arc: Arc):
        self.arcs.append(arc)
    
    fn is_final(self) -> Bool:
        return self.final_weight != Weight.zero()
    
    fn num_arcs(self) -> UInt:
        return len(self.arcs)


    
struct Fst:
    var start: State
    var states: List[State]
        
    fn __init__(inout self):
        # TODO: Implement kNoState concept or figure out how to use None here
        self.start = State(0)
        self.states = List[State]()

    fn __copyinit__(inout self, existing: Self):
        self.start = existing.start
        self.states = existing.states
    
    fn __moveinit__(inout self, owned existing: Self):
        self.start = existing.start
        self.states = existing.states^

    fn __str__(self) -> String:
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
    



fn main():
    var fst = Fst()
    fst.start = fst.add_state()
    fst.add_states(2)
    fst.add_arc(0, Arc(99, 99, Weight(1.23), 1))
    fst.add_arc(0, Arc(88, 88, Weight(4.56), 2))
    fst.set_final(1, Weight(7.89))
    fst.set_final(2, Weight(9.87))
    print(str(fst))
