import Testing
@testable import HealthPal

struct AdherenceLogTests {
    @Test func testMarkAsTakenSetsValues() throws {
        let medId = UUID()
        let now = Date()
        var log = AdherenceLog(medicationId: medId, scheduledDate: now, scheduledTime: now)
        let taken = now.addingTimeInterval(5 * 60)
        log.markAsTaken(at: taken, method: .quickTap, notes: "with food")
        #expect(log.status == .taken)
        #expect(log.actualTakenTime == taken)
        #expect(log.entryMethod == .quickTap)
        #expect(log.notes == "with food")
        #expect(log.isOnTime)
        #expect(log.totalDelayMinutes == 5)
    }

    @Test func testMarkAsTakenDelayed() throws {
        let medId = UUID()
        let now = Date()
        var log = AdherenceLog(medicationId: medId, scheduledDate: now, scheduledTime: now)
        let taken = now.addingTimeInterval(45 * 60)
        log.markAsTaken(at: taken)
        #expect(!log.isOnTime)
        #expect(log.totalDelayMinutes == 45)
    }
}

