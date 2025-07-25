import Testing
@testable import HealthPal

struct SymptomEntryTests {
    @Test func testHasAnySymptoms() throws {
        let entry = SymptomEntry(painLevel: 2)
        #expect(entry.hasAnySymptoms)
    }

    @Test func testOverallWellnessCalculation() throws {
        let entry = SymptomEntry(painLevel: 3, fatigueLevel: 2, moodLevel: 4)
        if let wellness = entry.overallWellness {
            #expect(abs(wellness - 11.0/3.0) < 0.0001)
        } else {
            #expect(false, "Wellness should not be nil")
        }
    }
}

