//
//  User.swift
//  Energram
//
//  Created by Alex Antipov on 21.02.2023.
//

import Foundation

struct User: Decodable {
    var id: String
    var email: String
    var is_superadmin: Bool
    var created: Date
    var last_login: Date
//    var userpic: Bool
    
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case email
//        case is_superadmin
//        case created
//        case last_login
//    }
    
}
