//
//  EndPoint.swift
//  OCBNetworkService
//
//  Created by Anamika Deb on 4/5/21.
//

import Foundation


enum HTORequestType: String {
    case GET
    case POST
    case PUT
    case DELETE
    case UPLOAD
    case PATCH
}

protocol EndPoint {
    var path: String {set get}
    var params: [String: Any]? {set get}
    var header: [String: Any]? {get}
    var type: HTORequestType {set get}
    
    func makeURLRequest(baseURL: String) -> URLRequest
}

protocol FileUploadEndPoint: EndPoint {
    var file: Data? {set get}
}


extension EndPoint {
    var header: [String: Any]? {
        //TODO: Add default header bearar token here
        if ViewModels.userBearerToken.isEmpty {
            return ["Accept":"application/json", "Content-type": "application/json", "X-Localization": "jp"]
        }
        return ["Accept":"application/json", "Authorization": "Bearer \(ViewModels.userBearerToken)", "X-Localization": "jp"]
    }
    
    func makeURLRequest(baseURL: String) -> URLRequest {
        print("\(baseURL)\(path)")
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!, timeoutInterval: TimeInterval(60))
        request.httpMethod = type.rawValue
        header?.forEach { (element) in
            request.addValue(element.value as! String, forHTTPHeaderField: element.key)
        }
        
        if type == .POST {
            print("params: \(params ?? [:])")
            request.addValue("application/json", forHTTPHeaderField: "Content-type")
            let httpBody = try? JSONSerialization.data(withJSONObject: params ?? [:], options: [])
            request.httpBody = httpBody
        }
        
        
        if type == .UPLOAD {
            if let imgUploadEndPoint = self as? FileUploadEndPoint {
                let imageName = "img"
                let uniqueId = UUID().uuidString
                let boundary = "---------------------------\(uniqueId)"
                   
                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                   
                   
                let boundaryText = "--\(boundary)\r\n"
               
                   
                var body = Data()
                body.append(boundaryText.data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(imageName).jpg\"\r\n".data(using: .utf8)!)
                body.append("Content-Type: image/jpeg".data(using: .utf8)!)
                body.append("\r\n\r\n".data(using: .utf8)!)
                body.append(imgUploadEndPoint.file!)
                body.append("\r\n".data(using: .utf8)!)
                body.append("--\(boundary)--\r\n".data(using: .utf8)!)
                request.httpMethod = HTORequestType.POST.rawValue
                request.httpBody = body
            }
        }
        
        
        
        return request
    }
    
    private func createHttpBody(binaryData: Data, mimeType: String) -> Data {
           let fieldName = "file"
           var postContent = "--\(generateBoundary())\r\n"
           let fileName = "upload_image.jpeg"
           postContent += "Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n"
           postContent += "Content-Type: \(mimeType)\r\n\r\n"

           var data = Data()
           guard let postData = postContent.data(using: .utf8) else { return data }
           data.append(postData)
           data.append(binaryData)

           guard let endData = "\r\n--\(generateBoundary())--\r\n".data(using: .utf8) else { return data }
           data.append(endData)
           return data
       }
    

    
    func generateBoundary() -> String {
        return "Boundary--------------------------------------------\(NSUUID().uuidString)"
    }
}


struct HTOEndPoint: EndPoint {
    var path: String
    var params: [String : Any]?
    var type: HTORequestType
}
