# Addition

`Addition` is the shared identity used to tag addition properties and the
namespace for exact, saturating, and overflow-reporting fixed-width addition.
`Addition.Signed` provides exact and saturating addition for unsigned binary
signed-magnitude storage.

`augmented` returns a rounded sum and residual. Its exact-pair guarantee applies to finite binary inputs in round-to-nearest arithmetic without overflow. The ordered overload falls back to the general algorithm when the magnitude ordering is not met. Nonfinite results do not carry an exact residual.
