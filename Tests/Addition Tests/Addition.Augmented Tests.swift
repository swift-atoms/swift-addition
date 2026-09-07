import Addition
import Testing

@Suite struct `Augmented addition preserves rounding residuals` {
    @Test func `The addition residual preserves a lost unit`() {
        let result = Addition.augmented(0x1p54 as Double, 1)
        #expect(result.head == 0x1p54)
        #expect(result.tail == 1)
        let reversed = Addition.augmented(large: 1.0, small: 0x1p54)
        #expect(reversed.head == result.head)
        #expect(reversed.tail == result.tail)
    }

    @Test func `Cancellation is exact and nonfinite results have no residual guarantee`() {
        let cancellation = Addition.augmented(Double.greatestFiniteMagnitude, -Double.greatestFiniteMagnitude)
        #expect(cancellation.head == 0 && cancellation.tail == 0)
        let overflow = Addition.augmented(Double.greatestFiniteMagnitude, Double.greatestFiniteMagnitude)
        #expect(overflow.head.isInfinite)
        #expect(overflow.tail.isNaN)
    }
}
