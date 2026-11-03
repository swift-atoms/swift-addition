# swift-addition

Use this package when you need to add two numbers and must choose what happens if the result doesn't fit. You can get the wrapped value with an overflow flag, a thrown error, or a value clamped to the type's bounds. It also adds sign-magnitude pairs (an unsigned magnitude with a `Polarity`), and it gives the exact rounding error of a floating-point sum. Start from `Addition`; use `Addition.Signed` for sign-magnitude operands. For the difference of two values, use the sibling package swift-subtraction instead.

## Laws

- `Addition.reporting` returns the two's-complement wrapped sum, and flags overflow exactly when the mathematical sum is outside `Value`'s range. `Addition.exact` throws exactly when that flag is set; otherwise it returns the sum.
- `Addition.saturating` returns the true sum when it fits. When it doesn't, it returns `.max`, or `.min` if `Value` is signed and the right operand is negative.
- `Addition.Signed` never produces a negative zero: a zero magnitude always has polarity `.positive`, even when both operands are negative zero or they cancel.
- In `Addition.Signed`, operands with opposite polarities never overflow. The result is the difference of the magnitudes and takes the polarity of the larger magnitude. Operands with the same polarity overflow when the sum of the magnitudes exceeds `Storage.max`. In that case `Addition.Signed.saturating` clamps the magnitude to `.max` and keeps the shared polarity.
- `Addition.augmented` returns `head`, the rounded sum, and `tail`, the rounding error, so that `head + tail` equals `lhs + rhs` exactly while `head` is finite. If `head` is not finite, `tail` carries no guarantee (for example, it is NaN on overflow to infinity). Exact cancellation gives zero for both `head` and `tail`.
- `Addition.augmented(large:small:)` gives the same result as `Addition.augmented(_:_:)`. It takes the cheaper path only when the radix is 2 and `|large| >= |small|`. Otherwise it falls back to the general algorithm, so swapping the arguments is safe.
