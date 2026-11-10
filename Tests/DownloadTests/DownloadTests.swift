import XCTest
@testable import MediaBox

final class DownloadTests: XCTestCase {
    func testClassify() {
        XCTAssertEqual(SourceResolver.classify(URL(string: "https://a.com/x.mp3")!), .directMedia(ext: "mp3", isVideo: false))
        XCTAssertEqual(SourceResolver.classify(URL(string: "https://a.com/x.MP4")!), .directMedia(ext: "mp4", isVideo: true))
        XCTAssertEqual(SourceResolver.classify(URL(string: "https://www.youtube.com/watch?v=abc")!), .youtube)
        XCTAssertEqual(SourceResolver.classify(URL(string: "https://youtu.be/abc")!), .youtube)
        XCTAssertEqual(SourceResolver.classify(URL(string: "https://a.com/page")!), .webPage)
    }

    func testYouTubeIsRefused() {
        if case .refused = SourceAdapters.resolve(URL(string: "https://youtu.be/abc")!) {} else { XCTFail("YouTube doit être refusé") }
    }

    func testSanitizeAndUnique() throws {
        XCTAssertEqual(FileManagerService.sanitize("a/b:c?.mp3"), "a_b_c_.mp3")
        XCTAssertEqual(FileManagerService.sanitize("   "), "fichier")
        let dir = FileManager.default.temporaryDirectory.appendingPathComponent("u-\(UUID().uuidString)")
        try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        try Data().write(to: dir.appendingPathComponent("x.mp3"))
        XCTAssertEqual(FileManagerService.uniqueURL(in: dir, name: "x.mp3").lastPathComponent, "x (2).mp3")
        try? FileManager.default.removeItem(at: dir)
    }

    func testQueueLimits() {
        let ids = (0..<5).map { _ in UUID() }
        let states = ids.enumerated().map { (id: $0.element, state: $0.offset == 0 ? DownloadState.running : DownloadState.queued) }
        XCTAssertEqual(DownloadQueue.idsToStart(states: states, limit: 2).count, 1)
        XCTAssertEqual(DownloadQueue.idsToStart(states: states, limit: 0).count, 0)
        XCTAssertEqual(DownloadQueue.effectiveLimit(userMax: 3, ecoMax: 1), 1)
        XCTAssertEqual(DownloadQueue.effectiveLimit(userMax: 3, ecoMax: 0), 0)
    }

    func testTaskInfoRoundTrip() {
        let info = DownloadTaskInfo(id: "1", dest: "music", name: "a.mp3")
        XCTAssertEqual(DownloadTaskInfo.decode(info.encoded())?.name, "a.mp3")
    }
}
