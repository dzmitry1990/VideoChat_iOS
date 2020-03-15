import UIKit

class HttpHelper: NSObject {
    static let
    keyEmail = "email",
    keyFirstName = "first_name",
    keyLastName = "last_name",
    keyPassword = "password",
    keyPhone = "phone",
    keyCode = "code",
    keyId = "id",
    keyAge = "age",
    keySnapchat = "snapchat",
    keyGender = "gender",
    keyQuery  = "query",
    keyFrom = "from",
    keyTo = "to",
    keyConId = "conversation_id",
    keyMessage = "message",
    keyUserId = "user_id",
    keyType = "type",
    keyPlaceId = "place_id",
    keyComment = "comment",
    keyName = "name",
    keyAddress = "address",
    keyCoordinates = "coordinates",
    keyCity = "city",
    keyState = "state",
    keyDescription = "description",
    keyCategory = "category",
    keyBlockId = "block_id",
    keyCommentId = "comment_id",
    keyOffset = "offset",
    keyLimit = "limit",
    keySearching = "searching"
    
    static func createNewUser(_ completionHandler: @escaping(String?) -> Void) {
        get(HttpUrl.createUser) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseGetUserId(data))
            } else {
                completionHandler(nil)
            }
        }
    }

    static func logPurchase(_ userId: String, completionHandler: @escaping(Bool) -> Void) {
        guard !userId.isEmpty else {
            completionHandler(false)
            return
        }
        
        let params = [keyUserId: userId as Any]
        
        post(HttpUrl.logPurchase, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseIsSuccess(data))
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func retrieveSession(_ sendUserId: String, receiveUserId: String, completionHandler: @escaping(String?, String?, String?) -> Void) {
        let params = [keyFrom: sendUserId as Any,
                      keyTo: receiveUserId as Any]
        
        post(HttpUrl.retrieveSession, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil, nil, nil)
                return
            }
            
            if let data = data {
                let (apiKey,token, sessionid) = ResponseParser.parseSessionInfo(data)
                completionHandler(apiKey,token, sessionid)
            } else {
                completionHandler(nil, nil, nil)
            }
        }
        
    }
    
    static func reportUser(_ userId: String, blockId: String, type: Int = -1, completionHandler: @escaping(Bool) -> Void) {
        let params = type >= 0 ?
                        [keyUserId: userId as Any,
                         keyBlockId: blockId as Any,
                         keyType: type as Any] :
                        [keyUserId: userId as Any,
                         keyBlockId: blockId as Any]
        
        post(HttpUrl.reportUser, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.isSuccess(data))
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func reportPost(_ placeId: String, completionHandler: @escaping(Bool) -> Void) {
        let params = [keyPlaceId: placeId as Any]
        
        post(HttpUrl.reportPost, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.isSuccess(data))
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func reportComment(_ commentId: String, completionHandler: @escaping(Bool) -> Void) {
        let params = [keyCommentId: commentId as Any]
        
        post(HttpUrl.reportComment, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.isSuccess(data))
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func getConversationId(_ from: String, to: String, completionHandler: @escaping(String?) -> Void) {
        guard !from.isEmpty else {
            completionHandler(nil)
            return
        }
        
        guard !to.isEmpty else {
            completionHandler(nil)
            return
        }
        
        let params = [keyFrom: from as Any,
                      keyTo: to as Any]
        
        post(HttpUrl.conversationId, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseConversationId(data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func getMessages(_ conId: String, completionHandler: @escaping([Message]?) -> Void) {
        guard !conId.isEmpty else {
            completionHandler(nil)
            return
        }
        
        let params = [keyConId: conId as Any]
        
        post(HttpUrl.getMessages, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseGetMessages(data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func sendMessage(_ from: String, to: String, message: String, completionHandler: @escaping(Message?) -> Void) {
        guard !from.isEmpty else {
            completionHandler(nil)
            return
        }
        guard !to.isEmpty else {
            completionHandler(nil)
            return
        }
        guard !message.isEmpty else {
            completionHandler(nil)
            return
        }
        
        let params = [keyFrom: from as Any,
                      keyTo: to as Any,
                      keyMessage: message as Any]
        
        post(HttpUrl.sendMessage, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseSentMessage(data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func getInbox(_ userId: String, completionHandler: @escaping([Inbox]?) -> Void) {
        guard !userId.isEmpty else {
            completionHandler(nil)
            return
        }
        
        let params = [keyUserId: userId as Any]
        
        post(HttpUrl.getInbox, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseGetInbox(data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func getHistories(_ userId: String, completionHandler: @escaping([Inbox]?) -> Void) {
        guard !userId.isEmpty else {
            completionHandler(nil)
            return
        }
        
        let params = [keyUserId: userId as Any]
        
        post(HttpUrl.history, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseGetInbox(data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func search(_ searchStr: String, offset: Int = 0, limit: Int = 0, completionHandler: @escaping([User]?) -> Void) {
        let params = limit > 0 ?
            [keyQuery: searchStr as Any,
            keyOffset: offset as Any,
            keyLimit: limit as Any,
            keySearching: true as Any] :
            [keyQuery: searchStr as Any]
        
        post(HttpUrl.search, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(nil)
                return
            }
            
            if let data = data {
                completionHandler(ResponseParser.parseSearchUsers(data))
            } else {
                completionHandler(nil)
            }
        }
    }
    
    static func verifyPhoneNumber(_ phonenum: String, completionHandler: @escaping(Bool, String?) -> Void) {
        let params = [keyPhone: phonenum as Any]
        
        post(HttpUrl.verifyNumber, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false, nil)
                return
            }
            
            if let data = data {
                let (success, mess) = ResponseParser.isSuccessWithMessage(data)
                
                completionHandler(success, mess)
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    static func verifyCode(_ phonenum: String, code: String, completionHandler: @escaping(Bool, String?) -> Void) {
        let params = [keyPhone: phonenum as Any,
                      keyCode: code as Any]
        
        post(HttpUrl.verifyCode, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false, nil)
                return
            }
            
            if let data = data {
                let (success, mess) = ResponseParser.isSuccessWithMessage(data)
                
                completionHandler(success, mess)
            } else {
                completionHandler(false, nil)
            }
        }
    }
    
    static func updateUser(_ userId: String, age: Int, snapchat: String, gender: String, completionHandler: @escaping(Bool) -> Void) {
        let params = [keyId: userId as Any,
                      keyAge: age as Any,
                      keySnapchat: snapchat as Any,
                      keyGender: gender as Any]
        
        post(HttpUrl.updateUser, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false)
                return
            }
            
            if let data = data {
                let success = ResponseParser.parseIsSuccess(data)
                completionHandler(success)
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func updateSearchingUser(_ userId: String, searching: Bool, completionHandler: @escaping(Bool) -> Void) {
        let params = [keyId: userId as Any,
                      keySearching: searching as Any]
        
        post(HttpUrl.updateUser, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                completionHandler(false)
                return
            }
            
            if let data = data {
                let success = ResponseParser.parseIsSuccess(data)
                completionHandler(success)
            } else {
                completionHandler(false)
            }
        }
    }
    
    static func signUp(_ email: String, password: String, fName: String, lName: String, completionHandler: @escaping(String?, Bool) -> Void) {
        let urlComp = NSURLComponents(string: HttpUrl.signUp)!
        
        let params = [keyEmail: email,
                      keyPassword: password,
                      keyFirstName: fName,
                      keyLastName: lName]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            var urlRequest = URLRequest(url: urlComp.url!)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    completionHandler(nil, false)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        
                        var message: String!
                        var success = false
                        
                        if let mess = json["message"] as? String {
                            message = mess
                            message = message.capitalizingFirstLetter()
                        }
                        
                        if let suc = json["success"] as? Int {
                            success = suc == 1
                        }

                        if let user = json["user"] as? NSDictionary {
                            Preferences.sharedInstance.setUserInfo(user: user)
                        }
                        
                        completionHandler(message, success)
                        return
                    }
                } catch {
                }
                
                completionHandler(nil, false)
            })
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func login(_ username: String, password: String, completionHandler: @escaping(String?, Bool) -> Void) {
        let urlComp = NSURLComponents(string: HttpUrl.logIn)!
        
        let params = [keyEmail: username,
                      keyPassword: password]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            var urlRequest = URLRequest(url: urlComp.url!)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                
                if error != nil {
                    print(error.debugDescription)
                    completionHandler(nil, false)
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        print(json)
                    
                        var message: String!
                        var success = false
                        
                        if let mess = json["message"] as? String {
                            message = mess
                            message = message.capitalizingFirstLetter()
                        }
                        
                        if let suc = json["success"] as? Int {
                            success = suc == 1
                        }
                        
                        if let user = json["user"] as? NSDictionary {
                            Preferences.sharedInstance.setUserInfo(user: user)
                        }
                        
                        completionHandler(message, success)
                        return
                    }
                } catch {
                }
                
                completionHandler(nil, false)
            })
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func uploadPhoto (_ image: UIImage, firstname: String, lastname: String,  callback: @escaping(String?, Error?) -> Void) {
        let userId = Preferences.sharedInstance.getUserId()
        if userId.isEmpty {
            return
        }
        
        let imageData = UIImageJPEGRepresentation(image, 1)
        
        if(imageData==nil)  {
            callback(nil, nil)
            return
        }
        let params = [keyUserId: userId as Any,
                      keyFirstName: firstname as Any,
                      keyLastName: lastname as Any]
        
        uploadMultipart(HttpUrl.updateProfile, imageData: imageData! as NSData, params: params) { (data, response, error) in
            if error != nil {
                #if DEBUG
                print(error.debugDescription)
                #endif
                
                callback(nil, error)
                return
            }
            
            if let data = data {
                callback(ResponseParser.parseGetUserData(data), nil)
            } else {
                callback(nil, nil)
            }
        }
    }

}

extension HttpHelper {
    static func post(_ url: String, params: [String: Any], completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) {
        guard let urlComp = NSURLComponents(string: url) else {
            return
        }
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            
            var urlRequest = URLRequest(url: urlComp.url!)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest, completionHandler: completionHandler)
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func get(_ url: String, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) {
        guard let urlComp = NSURLComponents(string: url) else {
            return
        }
        
        var urlRequest = URLRequest(url: urlComp.url!)
        urlRequest.httpMethod = "GET"
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: completionHandler)
        task.resume()
    }
    
    static func uploadMultipart(_ url: String, imageData: NSData?, params: [String: Any], completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) {
        
        guard let myUrl = NSURL(string: url) else {
            return
        }
        
        let request = NSMutableURLRequest(url:myUrl as URL)
        request.httpMethod = "POST";
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        request.httpBody = createBodyWithParameters(params: params, filePathKey: "uploadedfile", imageDataKey: imageData! as NSData, boundary: boundary) as Data
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: completionHandler);
        
        task.resume()
    }
    
    static func createBodyWithParameters(params: [String : Any], filePathKey: String?, imageDataKey: NSData, boundary: String) -> Data {
        var body = Data();
        
        let timestamp = NSDate().timeIntervalSince1970
        let filename = "\(timestamp).jpg"
        
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"params\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
        if let jsonData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted) {
            body.append(jsonData)
        }
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(imageDataKey as Data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
