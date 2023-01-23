//
//  Card.swift
//  RealmSwift-iOS
//
//  Created by Masatoshi Yamashita on 2022/12/25.
//

import SwiftUI
import RealmSwift

class Card: Object, Identifiable {
    
    @objc dynamic var id : Date = Date()
    @objc dynamic var date = Date()
    @objc dynamic var name = ""
    @objc dynamic var phonenum = ""
    @objc dynamic var detail = ""
}

