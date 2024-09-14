from .weight import Weight
from .arc import Arc

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
    