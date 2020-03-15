import SwiftyJSON

/** Methods to represent NSData as model objects */
class ResponseParser : NSObject {
    
    static func parseSearchUsers(_ response: Data) -> [User]? {
        return parseDataToArray(response, parser: getUserFromJson)
    }

    static func parseConversationId(_ response: Data) -> String? {
        let json = parseDataToJSON(response)
        return json["conversation-id"].stringValue
    }
    
    static func parseSessionInfo(_ response: Data) -> (String?, String?, String?) {
        let json = parseDataToJSON(response)
        
        let apiKey = json["apiKey"].stringValue
        let token = json["apiToken"].stringValue
        let sessionId = json["sessionId"].stringValue
        return (apiKey, token, sessionId)
    }
    
    static func parseGetMessages(_ response: Data) -> [Message]? {
        return parseDataToArray(response, parser: getMessageFromJson)
    }
    
    static func parseSentMessage(_ response: Data) -> Message? {
        let json = parseDataToJSON(response)
        return getMessageFromJson(json)
        
    }
    
    static func parseGetInbox(_ response: Data) -> [Inbox]? {
        return parseDataToArray(response, parser: getInboxFromJson)
    }
    
    
    static func parseIsSuccess(_ response: Data) -> Bool {
        let json = parseDataToJSON(response)
        let ok = json["ok"].intValue
        
        return ok == 1
    }
    
    static func isSuccessWithMessage(_ response: Data) -> (Bool, String?) {
        let json = parseDataToJSON(response)
        return (json["success"].boolValue, json["message"].stringValue)
    }
    
    static func isSuccess(_ response: Data) -> Bool {
        let json = parseDataToJSON(response)
        return json["success"].boolValue
    }
    
    static func parseGetUserId(_ response: Data) -> String? {
        let json = parseDataToJSON(response)
        
        return json["id"].stringValue
    }
    
    static func parseGetUserData(_ response: Data) -> String? {
        let json = parseDataToJSON(response)
        
        return json["url"].stringValue
    }
    
    static func parseGetCategoreis(_ response: Data) -> [String]? {
        return parseDataToArray(response, parser: { json -> String in
            return json.stringValue
        })
    }
    
    // MARK: - Common
    fileprivate static func parseDataToJSON(_ data: Data) -> JSON {
        do {
            return try JSON(data: data)
        } catch {
            #if DEBUG
            fatalError("JSON parse error!!!")
            #endif
        }
        return JSON()
    }
    
    fileprivate static func parseDataToArray<T>(_ data: Data, parser: (JSON) -> T) -> [T] {
        do {
            let d = try JSON(data: data).arrayValue
            return d.map { parser($0) }
        } catch {
            #if DEBUG
            fatalError("JSON parse error!!!")
            #endif
        }
        return []
    }
}

/** Methods to represent JSON as model objects */
extension ResponseParser {
    static func getUserFromJson(_ json: JSON) -> User {
        return User(
            userID: json["id"].stringValue,
            userAvatar: json["thumbnail"].stringValue,
            firstName: json["first_name"].stringValue,
            lastName: json["last_name"].stringValue,
            email: json["email"].stringValue,
            age: json["age"].intValue,
            gender: json["gender"].stringValue,
            snapchat: json["snapchat"].stringValue
        )
    }
    
    static func getMessageFromJson(_ json: JSON) -> Message {
        return Message(
            from: json["from"].stringValue,
            to: json["to"].stringValue,
            timeStamp: json["timestamp"].doubleValue,
            message: json["message"].stringValue,
            messageId: json["id"].stringValue)
    }
    
    static func getInboxFromJson(_ json: JSON) -> Inbox {
        let userJson = json["user"]
        let user = getUserFromJson(userJson)
        
        return Inbox(from: json["from"].stringValue,
                     to: json["to"].stringValue,
                     timeStamp: json["timestamp"].doubleValue,
                     message: json["message"].stringValue,
                     conId: json["conversation_id"].stringValue,
                     user: user)
        
    }
    
}
