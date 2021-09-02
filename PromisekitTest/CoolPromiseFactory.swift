//
//  CoolPromiseFactory.swift
//  PromisekitTest
//
//  Created by Ualá on 02/09/21.
//

import PromiseKit

class CoolPromiseFactory {
    func make() -> Promise<String> {
        return Promise { $0.fulfill("is this a leak?") }
    }
}
