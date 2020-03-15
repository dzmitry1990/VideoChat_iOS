//
//  Constants.swift
//  ExploreWorld
//
//  Created by Dzmitry Zhuk on 5/2/18.
//  Copyright © 2018 Dzmitry Zhuk. All rights reserved.
//

import UIKit
class Constant {
    static let BTN_HEIGHT = Utilities.isPad() ? CGFloat(70) : CGFloat(56)
    static let TF_HEIGHT = Utilities.isPad() ?  CGFloat(65) : CGFloat(48)
}

class Controllers: NSObject {
    static let rootWelcomeController = "RootWelcomeController"
    static let rootPhoneController = "RootPhoneViewController"
    static let rootViewController = "RootController"
    static let rootNavController = "RootNavController"
    static let ghostDetailsController = "GhostDetailsController"
    static let submitLocationController = "SubmitLocationController"
    static let searchResultsController = "SearchResultsController"
    static let termsServiceController = "TermsServiceController"
    static let editProfileController = "EditProfileController"
    static let cameraController = "CameraController"
    static let chatViewController = "ChatViewController"
    static let signupViewController = "SignupViewController"
    static let loginViewController = "LoginViewController"
    static let rootAuthController = "RootAuthController"
    static let verifyCodeController = "VerifyNumberController"
    static let getStartedController = "GetStartedController"
    static let permissionController = "PermissionController"
    static let videoCallController = "VideoCallController"
    static let reportViewController = "ReportViewController"
}

class Notifications {
    static let closeBroadcast = "closeBroadcast"
}

class Urls {
    static let TERMS_URL                        = "http://app.highfashioncircle.com/terms.html"
    static let POLICY_URL                       = "http://app.highfashioncircle.com/privacy.html"
}

class HttpUrl {
    static let BASE_URL                         = "http://bereal.to/stats/video-chat/"
    
    static let
    signUp = BASE_URL + "signup/",
    logIn = BASE_URL + "login/",
    verifyNumber = BASE_URL + "verify-number/",
    verifyCode = BASE_URL + "verify-code/",
    updateUser = BASE_URL + "update/",
    search = BASE_URL + "search/",
    getCategories = BASE_URL + "/categories",
    conversationId = BASE_URL + "conversation-id/",
    getMessages = BASE_URL + "messages/",
    sendMessage = BASE_URL + "message/",
    getInbox = BASE_URL + "inbox/",
    getPlaces = BASE_URL + "places/",
    getPlaceDetails = BASE_URL + "details/",
    getComments = BASE_URL + "comments/",
    sendComment = BASE_URL + "comment/",
    submitLocation = BASE_URL + "submit/",
    updateProfile = BASE_URL + "profile/",
    logPurchase = BASE_URL + "log-purchase/",
    createUser = BASE_URL + "create-user/",
    reportUser = BASE_URL + "report-user/",
    reportPost = BASE_URL + "report-post/",
    reportComment = BASE_URL + "report-comment/",
    retrieveSession = BASE_URL + "session/",
    history = BASE_URL + "history/"
}

struct Gender {
    static let
    male = "male",
    female = "female"
}

class Colors: NSObject {
    static let borderColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1.0)
    static let selecctedColor = UIColor.init(red: 255/255, green: 89/255, blue: 89/255, alpha: 1.0)
    static let grayTextColor = UIColor.init(red: 168/255, green: 168/255, blue: 168/255, alpha: 1.0)
    static let greenColor = UIColor.init(red: 2/255, green: 195/255, blue: 25/255, alpha: 1.0)
    static let orangeColor = UIColor.init(red: 255/255, green: 191/255, blue: 0/255, alpha: 1.0)
    static let redColor = UIColor.init(red: 255/255, green: 89/255, blue: 89/255, alpha: 1.0)
    static let opacityColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.1)
    static let palceholderColor = UIColor.init(red: 143/255, green: 143/255, blue: 143/255, alpha: 1.0)
}

let kProductSubscriptionId      = "com.ithaunts.haunt.monthly"

class OpenTokKey: NSObject {
    static let kApiKey = "46103362"
    static let kSessionId = "1_MX40NjEwMzM2Mn5-MTUyOTk2NzkzNDEyM35HVjczNlB5K3ltV29paVJnODI1UWVqeml-fg"
    static let kToken = "T1==cGFydG5lcl9pZD00NjEwMzM2MiZzaWc9ZTEwZjZmZDdlNmYxM2E5ODNjZWU3NTY0NGJmNzliYzNjNmMwM2NiZjpzZXNzaW9uX2lkPTFfTVg0ME5qRXdNek0yTW41LU1UVXlPVGsyTnprek5ERXlNMzVIVmpjek5sQjVLM2x0VjI5cGFWSm5PREkxVVdWcWVtbC1mZyZjcmVhdGVfdGltZT0xNTI5OTY3OTc3Jm5vbmNlPTAuMDk5NjMyMzY3NDQ2MjE2Mjkmcm9sZT1wdWJsaXNoZXImZXhwaXJlX3RpbWU9MTUzMjU1OTk3NiZpbml0aWFsX2xheW91dF9jbGFzc19saXN0PQ=="
    static let kWidgetHeight = 480
    static let kWidgetWidth = 640
}
