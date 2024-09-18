from utils.numerics import max_finite


trait Semiring:
    # Additive identity
    @staticmethod
    fn zero() -> Self: ...

    # Multiplicative identity
    @staticmethod
    fn one() -> Self: ...

    fn __add__(self, other: Self) -> Self: ...
    fn __mul__(self, other: Self) -> Self: ...


@value
struct TropicalWeight(Semiring):
    var value: Float64

    @staticmethod
    fn zero() -> Self:
        return Self(max_finite[DType.float64]()) # TODO: Is there a representation of infinity?
    
    @staticmethod
    fn one() -> Self:
        return Self(1.0)

    fn __add__(self, other: Self) -> Self:
        return Self(min(self.value, other.value))

    fn __mul__(self, other: Self) -> Self:
        return Self(self.value + other.value)


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
    