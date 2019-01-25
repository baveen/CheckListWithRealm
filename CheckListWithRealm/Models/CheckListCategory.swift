//
//  CheckListCategory.swift
//  CheckListWithRealm
//
//  Created by Baveendran Nagendran on 1/25/19.
//  Copyright © 2019 rbsolutions. All rights reserved.
//

import Foundation
import RealmSwift

class CheckListCategory: Object {
    @objc dynamic var name: String = ""
    let items = List<CheckListItem>()
}
