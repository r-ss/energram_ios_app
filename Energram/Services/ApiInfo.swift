//
//  ApiInfo.swift
//  Energram
//
//  Created by Alex Antipov on 12.11.2022.
//

import Foundation
import SwiftUI

extension Data {
    var prettyPrintedJSONString: String? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }
        return prettyPrintedString
    }
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
                            
//                            self.apiInfo = try! String(contentsOf: url, encoding: .utf8)
                            
                            self.apiInfo = safeData.prettyPrintedJSONString!
                            
                            //                            self.apiInfo = String(data: safeData, encoding: .utf8)!
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
}
