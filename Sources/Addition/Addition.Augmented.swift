extension Addition {





    @inlinable
    public static func augmented<T: FloatingPoint>(_ lhs: T, _ rhs: T) -> (head: T, tail: T) {
        let head = lhs + rhs
        let x = head - rhs
        let y = head - x
        return (head, (lhs - x) + (rhs - y))
    }



    @inlinable
    public static func augmented<T: FloatingPoint>(large: T, small: T) -> (head: T, tail: T) {
        guard T.radix == 2, large.magnitude >= small.magnitude else {
            return augmented(large, small)
        }
        let head = large + small
        return (head, (large - head) + small)
    }
}
