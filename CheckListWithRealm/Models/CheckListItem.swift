//
//  CheckListItem.swift
//  CheckListWithRealm
//
//  Created by Baveendran Nagendran on 1/25/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import Foundation
import RealmSwift

class CheckListItem: Object {
    
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool =  false
    var parentList = LinkingObjects(fromType: CheckListCategory.self, property: "items")
    
}
