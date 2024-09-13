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


# TODO: Make sure we are using @value correctly here
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
        return 'Arc(ilabel=' + str(self.ilabel) + ', olabel=' + str(self.olabel) +
               ', weight=' + str(self.weight) + ', nextstate=' + str(self.nextstate) + ')'
    
    fn __repr__(self) -> String:
        return self.__str__()


# TODO: Make UInt conform to Hashable in stdlib
alias StateId = UInt

struct State:
    var id: StateId
    var arcs: List[Arc]
    var final_weight: Weight

    fn __init__(inout self, id: StateId):
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
        var string = 'State ID = ' + str(self.id)
        for arc in self.arcs:
            string += '\n' + str(arc[])
        
        if self.is_final():
            string += '\n' + str(self.final_weight)
        
        return string
    
    fn add_arc(inout self, arc: Arc):
        self.arcs.append(arc)
    
    fn is_final(self) -> Bool:
        return self.final_weight != Weight.zero()

    

struct Fst:
    var start: State
    var states: List[State]
        
    fn __init__(inout self):
        # TODO: Implement kNoState concept or figure out how to use None here
        self.start = State(0)
        self.states = List[State]()

    fn __str__(self) -> String:
        string = String()
        for state_ref in self.states:
            var state = state_ref[]
            for arc_ref in state.arcs:
                arc = arc_ref[]
                string += str(state.id) + ' ' + str(arc.nextstate) + ' ' +
                          str(arc.ilabel) + ' ' + str(arc.olabel) + ' ' +
                          str(arc.weight.value) + '\n'
            
            if state.is_final():
                string += str(state.id) + ' ' + str(state.final_weight.value) + '\n'

        return string

    # TODO: This is a good place to really learn about the ownership model
    # Is "state" a separate copy of the object in the list "self.states"?
    # What happens when I call "add_arc"... do I need to explicitly transfer
    # ownership of "arc" here?
    fn add_arc(inout self, state_id: StateId, arc: Arc):
        if state_id >= len(self.states):
            # TODO: Implement better error handling
            print('State ID ' + str(state_id) + ' does not exist.')
        
        var state = self.states[state_id]
        state.add_arc(arc)

    fn add_state(inout self) -> StateId:
        var id = len(self.states)
        var state = State(id)
        self.states.append(state)
        return id
    
    fn add_states(inout self, n: UInt):
        for _ in range(n):
            _ = self.add_state()
    



fn main():
    var arc1 = Arc(0, 1, Weight(3.14), 2)
    var arc2 = Arc(3, 2, Weight(1.23), 0)
    var s = State(0)
    s.add_arc(arc1)
    s.add_arc(arc2)
    s.final_weight = Weight(9.999)

    var fst = Fst()
    fst.start = fst.add_state()
    fst.add_states(1)



    var arc = Arc(99, 99, Weight(3.14), 1)
    fst.add_arc(0, arc)

    print(str(fst.states[0]))
