//
//  ApiInfo.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI

//let apiInfoJsonEncoder = JSONEncoder()

struct ApiInfo: Codable {
    var benchmark: Float
    var datasource: String
    var date: String
    var received: String
    var measure: String
    var data: [Float]
    
}

class ApiInfoService: ObservableObject {
    
    @Published var apiInfo: String = "- no data -"
    
    func fetchData(){
        if let url = URL(string: Config.urlApiInfo) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error == nil {
                    
            
                    if let safeData = data {
                        DispatchQueue.main.async {
                            self.apiInfo = String(data: safeData, encoding: .utf8)!
                        }
//                        do {
//                            let result = try decoder.decode(ApiInfo.self, from: safeData)
//                            DispatchQueue.main.async {
//                                self.apiInfo = result
//                            }
//                        } catch {
//                            print(error)
//                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}

//extension ApiInfo {
//
//
////    jsonEncoder.outputFormatting = .prettyPrinted
//
//    var as_json_string: String {
//        do {
//            let encodePerson = try apiInfoJsonEncoder.encode(self)
//            let endcodeStringPerson = String(data: encodePerson, encoding: .utf8)!
//            return(endcodeStringPerson)
//        } catch {
//            return(error.localizedDescription)
//        }
//    }
//}
