//
//  Task.swift
//  todo_task
//
//  Created by Piyush on 21/04/25.
//

import Foundation

//struct Task {
//  let title: String
//  let isComplete: Bool
//  
//  init(title: String, isComplete: Bool = false) {
//    self.title = title
//    self.isComplete = isComplete
//  }
//  
//  func completeToggled() -> Task {
//    return Task(title: title, isComplete: !isComplete)
//  }
//}

struct Task: Codable {
    let title: String
    let isComplete: Bool

    init(title: String, isComplete: Bool = false) {
        self.title = title
        self.isComplete = isComplete
    }

    func completeToggled() -> Task {
        return Task(title: title, isComplete: !isComplete)
    }
}
