public import Polarity

/// The reusable identity of an addition operation.
///
/// APIs use `Addition` as a shared property tag and as the namespace for
/// reusable addition kernels.
public enum Addition {

    public enum Error: Swift.Error, Hashable, Sendable {
        case overflow
    }

    /// Adds two fixed-width integers and reports overflow without trapping.
    @inlinable
    public static func reporting<Value: FixedWidthInteger>(
        _ lhs: Value,
        _ rhs: Value
    ) -> (value: Value, overflow: Bool) {
        let result = lhs.addingReportingOverflow(rhs)
        return (result.partialValue, result.overflow)
    }

    /// Adds two fixed-width integers exactly.
    @inlinable
    public static func exact<Value: FixedWidthInteger>(
        _ lhs: Value,
        _ rhs: Value
    ) throws(Addition.Error) -> Value {
        let result = reporting(lhs, rhs)
        guard !result.overflow else { throw .overflow }
        return result.value
    }

    /// Adds two fixed-width integers, clamping overflow to the nearest bound.
    @inlinable
    public static func saturating<Value: FixedWidthInteger>(
        _ lhs: Value,
        _ rhs: Value
    ) -> Value {
        let result = reporting(lhs, rhs)
        guard result.overflow else { return result.value }
        if Value.isSigned && rhs < .zero { return .min }
        return .max
    }
}

extension Addition {

    /// Addition for values represented by an unsigned magnitude and binary
    /// polarity.
    public enum Signed {}
}

extension Addition.Signed {

    /// Exactly adds two binary signed magnitudes backed by unsigned storage.
    ///
    /// Either polarity may accompany a zero input. A zero result always uses
    /// positive polarity.
    @inlinable
    public static func exact<Storage: FixedWidthInteger & UnsignedInteger>(
        lhsMagnitude: Storage,
        lhsPolarity: Polarity,
        rhsMagnitude: Storage,
        rhsPolarity: Polarity
    ) throws(Addition.Error) -> (polarity: Polarity, magnitude: Storage) {
        if lhsPolarity == rhsPolarity {
            let magnitude = try Addition.exact(lhsMagnitude, rhsMagnitude)
            return normalized(polarity: lhsPolarity, magnitude: magnitude)
        }
        return reduced(
            lhsMagnitude: lhsMagnitude,
            lhsPolarity: lhsPolarity,
            rhsMagnitude: rhsMagnitude,
            rhsPolarity: rhsPolarity
        )
    }

    /// Adds two binary signed magnitudes, clamping equal-sign overflow.
    @inlinable
    public static func saturating<Storage: FixedWidthInteger & UnsignedInteger>(
        lhsMagnitude: Storage,
        lhsPolarity: Polarity,
        rhsMagnitude: Storage,
        rhsPolarity: Polarity
    ) -> (polarity: Polarity, magnitude: Storage) {
        if lhsPolarity == rhsPolarity {
            return normalized(
                polarity: lhsPolarity,
                magnitude: Addition.saturating(lhsMagnitude, rhsMagnitude)
            )
        }
        return reduced(
            lhsMagnitude: lhsMagnitude,
            lhsPolarity: lhsPolarity,
            rhsMagnitude: rhsMagnitude,
            rhsPolarity: rhsPolarity
        )
    }

    @inlinable
    internal static func reduced<Storage: FixedWidthInteger & UnsignedInteger>(
        lhsMagnitude: Storage,
        lhsPolarity: Polarity,
        rhsMagnitude: Storage,
        rhsPolarity: Polarity
    ) -> (polarity: Polarity, magnitude: Storage) {
        if lhsMagnitude >= rhsMagnitude {
            return normalized(
                polarity: lhsPolarity,
                magnitude: lhsMagnitude - rhsMagnitude
            )
        }
        return normalized(
            polarity: rhsPolarity,
            magnitude: rhsMagnitude - lhsMagnitude
        )
    }

    @inlinable
    internal static func normalized<Storage: FixedWidthInteger & UnsignedInteger>(
        polarity: Polarity,
        magnitude: Storage
    ) -> (polarity: Polarity, magnitude: Storage) {
        (magnitude == .zero ? .positive : polarity, magnitude)
    }
}
