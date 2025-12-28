//
//  TaskRunner.swift
//  Shelley
//
//  Created by Tyler Hall on 8/26/20.
//  Copyright © 2020 Tyler Hall. All rights reserved.
//

import Foundation

final class SendableClosure: @unchecked Sendable {
    let closure: () -> Void
    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }
}

class TaskRunner {

    var scriptURL: URL

    let uuid = UUID().uuidString

    init?(scriptName: String) {
        guard let url = Constants.scriptFolderURL?.appendingPathComponent(scriptName).appendingPathExtension("sh") else { return nil }
        if FileManager.default.isExecutableFile(atPath: url.path) {
            scriptURL = url
        } else {
            return nil
        }
    }

    func execute(_ completion: (() -> Void)? = nil) {
        let sh = Process()
        sh.launchPath = scriptURL.path

        let wrappedCompletion = completion.map { SendableClosure($0) }

        DispatchQueue.global(qos: .userInitiated).async { [wrappedCompletion] in
            sh.launch()
            sh.waitUntilExit()
            if let wrappedCompletion {
                DispatchQueue.main.async {
                    wrappedCompletion.closure()
                }
            }
        }
    }
}

extension TaskRunner: Equatable {
    static func == (lhs: TaskRunner, rhs: TaskRunner) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension TaskRunner: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
}
