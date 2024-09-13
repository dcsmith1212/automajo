from collections import Dict

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
        return 'Arc(ilabel=' + str(self.ilabel) + ', olabel=' + str(self.olabel) +
               ', weight=' + str(self.weight) + ', nextstate=' + str(self.nextstate) + ')'
    
    fn __repr__(self) -> String:
        return self.__str__()


struct State:
    var id: Int
    var arcs: List[Arc]
    var final_weight: Weight

    fn __copyinit__(inout self, existing: Self):
        self.id = existing.id
        self.arcs = existing.arcs
        self.final_weight = existing.final_weight
    
    fn __moveinit__(inout self, owned existing: Self):
        self.id = existing.id
        self.arcs = existing.arcs^
        self.final_weight = existing.final_weight

    fn __eq__(self, other: Self) -> Bool:
        return self.id == other.id and
               self.arcs == other.arcs and
               self.final_weight == other.final_weight
    
    fn __ne__(self, other: Self) -> Bool:
        return not self.__eq__(other)
    
    # fn __hash__(self) -> UInt:
        


struct Fst:
    var start: State
    var num_states: Int
    var arcs: Dict[State, List[Arc]]
    var finals: List[State]

    fn __init__(inout self):
        self.start = 0
        self.num_states = 0
        self.arcs = Dict[StateId, List[Arc]]()
        self.finals = List[StateId]()


fn main():
    var arc = Arc(0, 1, Weight(3.14), 2)
    print(str(arc))
