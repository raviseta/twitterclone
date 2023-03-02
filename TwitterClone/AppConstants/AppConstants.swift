//
//  AppConstants.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation
import UIKit

struct Constants {
    struct Texts {
        static let profileViewTitle = "Profile"
        static let alertOkTitle = "Ok"
        static let alertCancelTitle = "Cancel"
        static let alertQuitTitle = "Quit"
    }
    
    struct URLs {
        static let baseURL = "https://google.com"
        static let profileEndpoints = "/search"
    }
    
    struct StoryboardXIBNames {
        static let main = "Main"
    }
    
    struct Value {
        static let tableRowEstimatedHeight = 182.0
        static let SCREEN_WIDTH: CGFloat = UIScreen.main.bounds.width
    }
  
    struct ErrorMessages {
        static let xibNotFound = "xib does not exists"
        static let invalidURL = "Invalid URL"
        static let invalidResponse = "Invalid response"
        static let unknownError = "Unknown error"
        static let noInternetConnection = "No internet connection"
        static let noError = "No Error"
        static let jailbrokenDevice = "This Device is JailBroken.Please quit the application."
    }
    
    struct Image {
        static let placeholderImage = "placeholderImage.png"
    }
}
