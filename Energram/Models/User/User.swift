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
    var userpic: [String: String]?
    
//    enum CodingKeys: String, CodingKey {
//        case id = "_id"
//        case email
//        case is_superadmin
//        case created
//        case last_login
//    }
    
}

struct UserpicUploadResponse: Decodable {
    var result: String
    var userpic_dir: String
    var userpic_hash: String
    
    var userpicUrl: String {
        return "https://media.energram.co/\(userpic_dir)/\(userpic_hash)_512.jpg"
    }
    
}
