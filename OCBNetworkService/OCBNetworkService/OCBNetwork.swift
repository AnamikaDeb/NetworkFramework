//
//  OCBNetwork.swift
//  OCBNetworkService
//
//  Created by Anamika Deb on 4/5/21.
//

import Foundation
import UIKit

// https://www.hintabo.com/api/user/id
// https://www.hitabo.com/api/calender/date/date

public struct NetworkEnvironment {
    let baseURL: String
    let defaultHeader: [String: String]
    
    static let devEnv = NetworkEnvironment(baseURL: "http://bd52.ocdev.me/api/", defaultHeader: [:])
    static let stgEnv = NetworkEnvironment(baseURL: "http://www.hinatabo.com/api/", defaultHeader: [:])
    static let prodEnv = NetworkEnvironment(baseURL: "http://www.hinatabo.com/api/", defaultHeader: [:])
}


protocol Network {
    var env: NetworkEnvironment {set get}
    
    func execute(endPoint: EndPoint, result: @escaping((Data?, Error?) -> Void))
}

extension Network {
    func execute(endPoint: EndPoint, result: @escaping((Data?, Error?) -> Void)) {
        print("endpoint: \(endPoint)")
        let task = URLSession.shared.dataTask(with: endPoint.makeURLRequest(baseURL: env.baseURL)) { (data, urlResponse, error) in
            
            //print(String(data: data ?? Data(), encoding: .utf8))
            
//            print("Data: \(data), URLResponse: \(urlResponse), Error: \(error)")
//            result(data,error)
            /*   DispatchQueue.main.async {
                do {
                    let dic = try JSONSerialization.jsonObject(with: data) as! Dictionary<String, Any>
                    print("response base: \(dic)")
                    result(data, nil)
                } catch {
                    print("api error: \(error.localizedDescription)")
                    result(nil, error)
                }
            }*/
            DispatchQueue.main.async {
                if let err = error {
                    //print("Network Error: \(err)")
                    result(nil, err)
                }
                else {
                    //print("Network Data: \(String(data: data!, encoding: .utf8))")
                    result(data, nil)
                }
            }
        }
        task.resume()
    }
}



public class OCBNetwork: Network {
    var env: NetworkEnvironment
    
    public init(env: NetworkEnvironment) {
        self.env = env
    }
}
