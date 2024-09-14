from .weight import Weight

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
    