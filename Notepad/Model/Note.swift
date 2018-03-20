//
//  Note.swift
//  Notepad
//
//  Created by Philip Tam on 2018-03-20.
//  Copyright © 2018 RPSTAM. All rights reserved.
//

import Foundation
import RealmSwift

class Note : Object{
    @objc dynamic var text : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var dateLastUsed = Date()
}
