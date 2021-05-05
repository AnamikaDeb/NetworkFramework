//
//  NetworkViewModel.swift
//  OCBNetworkService
//
//  Created by Anamika Deb on 4/5/21.
//

import Foundation

public class NetworkViewModel<Model: APIResponseProtocol> {
    var network: Network!
    var decoder: JSONDecoder!
    
    var state: ViewState<Model>?
    
    var response : ((ViewState<Model>) -> Void)?
    
    
    init(network: Network = OCBNetwork(env: NetworkEnvironment.devEnv)) {
       
        self.network = network
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func getEndPoint() -> EndPoint {
        return HTOEndPoint(path: "default", params: [:], type: .GET)
    }
    
    
    func fetch() {
        self.state = .loading
        self.response?(.loading)

        self.network.execute(endPoint: getEndPoint()) {[weak self] data, error in
           
            if let error = error {
                print("Error: \(error)")
                self?.state = .error(message: error.localizedDescription)
                self?.response?(.error(message: error.localizedDescription))

                return
            }
            
            do {
                guard let data = data else { return }
                print("RESPONSE: \(String(data:data, encoding: .utf8))")

                let response = try self?.decoder.decode(Model.self, from: data)
//                print("Response: \(response)")

                self?.state = .loaded(data: response! )
                
                self?.response?(.loaded(data: response!))
                return
            } catch {
                print("eroor: \(error.localizedDescription)")
                self?.state = .error(message: error.localizedDescription)
                self?.response?(.error(message: error.localizedDescription))
            }
        }
    }
    
    func onAppear() {
        fetch()
    }
}


// Factory
public class ViewModels {
    static var userBearerToken : String = ""
}
