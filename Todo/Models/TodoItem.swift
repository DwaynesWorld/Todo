//
//  TodoItem.swift
//  Todo
//
//  Created by Kyle Thompson on 12/7/18.
//  Copyright © 2018 Kyle Thompson. All rights reserved.
//

import Foundation

class TodoItem {
    var title: String = ""
    var completed: Bool = false
    
    convenience init(_ title: String) {
        self.init()
        self.title = title
    }
}
