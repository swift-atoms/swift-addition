extension Addition {
    /// Returns the rounded sum and its residual rounding error.
    ///
    /// For finite binary operands in round-to-nearest arithmetic, when the sum
    /// does not overflow, `head + tail` represents the exact mathematical sum.
    /// Nonfinite inputs or overflow may produce a NaN residual.
    @inlinable
    public static func augmented<T: FloatingPoint>(_ lhs: T, _ rhs: T) -> (head: T, tail: T) {
        let head = lhs + rhs
        let x = head - rhs
        let y = head - x
        return (head, (lhs - x) + (rhs - y))
    }

    /// Uses the shorter residual calculation when the operands are ordered by magnitude.
    /// Unordered operands and nonbinary representations use the general algorithm.
    @inlinable
    public static func augmented<T: FloatingPoint>(large: T, small: T) -> (head: T, tail: T) {
        guard T.radix == 2, large.magnitude >= small.magnitude else {
            return augmented(large, small)
        }
        let head = large + small
        return (head, (large - head) + small)
    }
}
