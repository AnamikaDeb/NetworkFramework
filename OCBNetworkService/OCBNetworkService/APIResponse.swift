//
//  APIResponse.swift
//  OCBNetworkService
//
//  Created by Anamika Deb on 4/5/21.
//

import Foundation

public protocol  APIResponseProtocol: Decodable {
    associatedtype DATA
    var success: Bool? {set get}
    var message: String? {set get}
    var data: DATA? {set get}
}

struct APIResponse<Model: Decodable>: APIResponseProtocol {
    var success: Bool?
    
    var message: String?
    
    var data: Model?
    
    typealias DATA = Model

}
