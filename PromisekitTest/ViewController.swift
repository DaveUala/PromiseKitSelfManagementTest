//
//  ViewController.swift
//  PromisekitTest
//
//  Created by Ualá on 02/09/21.
//

import UIKit
import PromiseKit

protocol CapturedStringCollector {
    func didCapture(string: String)
}

class StringCollector: CapturedStringCollector {
    func didCapture(string: String) {

    }
}

class ViewControllerWithoutWeakSelf: UIViewController {
    var capturedValueCollector: CapturedStringCollector = StringCollector()

    func captureValue() {
        CoolPromiseFactory().make().done {
            self.capturedValueCollector.didCapture(string: $0)
        }.catch { _ in
        }
    }
}

class ViewControllerWithWeakSelf: UIViewController {
    var capturedValueCollector: CapturedStringCollector = StringCollector()

    func captureValue() {
        CoolPromiseFactory().make().done { [weak self] in
            self?.capturedValueCollector.didCapture(string: $0)
        }.catch { _ in
        }
    }
}
