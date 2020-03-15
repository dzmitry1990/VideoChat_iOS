import UIKit
import Foundation

public class Preferences: NSObject {
    static let sharedInstance = Preferences()
    private let defaults:UserDefaults = UserDefaults.standard

    private let thumbnail_key = "thumbnail_key"
    private let first_name_key = "first_name_key"
    private let last_name_key = "last_name_key"
    private let userid_key = "user_id_key"
    private let snapchat_key = "snapchat_key"
    private let age_key = "age_key"
    private let purchase_user_key = "purchase_user_key"
    
    
    var sessionId: String?
    var token: String?
    var apiKey: String?
    var categories: [String]?
    
    func setPurchaseUser(_ userId: String) {
        defaults.setValue(userId, forKey: purchase_user_key)
    }
    
    func getPurchaseUser()->String {
        return defaults.string(forKey: purchase_user_key) ?? ""
    }
    
    var userId: String {
        return getUserId()
    }
    func setUserId(_ userId: String) {
        defaults.setValue(userId, forKey: userid_key)
    }
    
    func getUserId()->String {
        return defaults.string(forKey: userid_key) ?? ""
    }
    
    var firstName: String {
        return getFirstName()
    }
    func setFirstName(_ firstName: String) {
        defaults.setValue(firstName, forKey: first_name_key)
    }
    
    func getFirstName()->String {
        return defaults.string(forKey: first_name_key) ?? ""
    }
    var lastName: String {
        return getLastName()
    }
    func setLastName(_ lastName: String) {
        defaults.setValue(lastName, forKey: last_name_key)
    }
    
    func getLastName()->String {
        return defaults.string(forKey: last_name_key) ?? ""
    }
    var thumbnailPath: String {
        return getThumbnailPath()
    }
    func setThumbnailPath(_ path: String) {
        defaults.setValue(path, forKey: thumbnail_key)
    }
    
    func getThumbnailPath()->String {
        return defaults.string(forKey: thumbnail_key) ?? ""
    }
    
    var snapchatUsername: String {
        return getSnapchatUsername()
    }
    func setSnapchatUsername(_ userName: String) {
        defaults.setValue(userName, forKey: snapchat_key)
    }
    
    func getSnapchatUsername()->String {
        return defaults.string(forKey: snapchat_key) ?? ""
    }
    
    var age: Int {
        return getAge()
    }
    func setAge(_ age: Int) {
        defaults.set(age, forKey: age_key)
    }
    
    func getAge()->Int {
        return defaults.integer(forKey: age_key)
    }
    
    func clearData() {
        setUserId("")
        setFirstName("")
        setLastName("")
        setThumbnailPath("")
        setSnapchatUsername("")
        setAge(0)
    }
    
    var isLoggedIn: Bool {
        return !userId.isEmpty
    }

    func setUserInfo(user: NSDictionary) {
        if let id = user["id"] as? String {
            setUserId(id)
        }
        if let firstName = user["first_name"] as? String {
            setFirstName(firstName)
        }
        if let lastName = user["last_name"] as? String {
            setLastName(lastName)
        }
        if let thumbnail = user["thumbnail"] as? String {
            setThumbnailPath(thumbnail)
        }
        if let snapchat = user["snapchat"] as? String {
            setSnapchatUsername(snapchat)
        }
        
        if let age = user["age"] as? Int {
            setAge(age)
        }
    }
    
    func setCategories(_ catList: [String]) {
        categories = catList
    }
}
