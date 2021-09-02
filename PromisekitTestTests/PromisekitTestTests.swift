//
//  PromisekitTestTests.swift
//  PromisekitTestTests
//
//  Created by Ualá on 02/09/21.
//

import XCTest

@testable import PromisekitTest

final class PromisekitTestTests: XCTestCase {
    func test_noWeakSelfController_viewDidLoad_setsCapturedValue() {
        let spy = CapturedStringCollectorSpy()
        let sut = ViewControllerWithoutWeakSelf()
        sut.capturedValueCollector = spy
        trackMemoryLeaks(for: sut, spy)

        sut.captureValue()
        RunLoop.current.run(until: Date())

        XCTAssertEqual(spy.messages, ["is this a leak?"])
    }

    func test_weakSelfController_viewDidLoad_setsCapturedValue() {
        let spy = CapturedStringCollectorSpy()
        let sut = ViewControllerWithWeakSelf()
        sut.capturedValueCollector = spy
        trackMemoryLeaks(for: sut, spy)

        sut.captureValue()
        RunLoop.current.run(until: Date())

        XCTAssertEqual(spy.messages, ["is this a leak?"])
    }
}

final class CapturedStringCollectorSpy: CapturedStringCollector {
    var messages: [String] = []
    let expectaction: XCTestExpectation?

    init(expectaction: XCTestExpectation? = nil) {
        self.expectaction = expectaction
    }

    func didCapture(string: String) {
        messages.append(string)
        expectaction?.fulfill()
    }
}

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.",
                         file: file,
                         line: line)
        }
    }

    func trackMemoryLeaks(for instances: AnyObject...,  file: StaticString = #file, line: UInt = #line) {
        for instance in instances {
            trackForMemoryLeaks(instance, file: file, line: line)
        }
    }
}

