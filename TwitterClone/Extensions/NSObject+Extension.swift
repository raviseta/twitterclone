//
//  NSObject+Extension.swift
//  TwitterClone
//
//  Created by raviseta on 01/03/23.
//

import Foundation

extension NSObject {
    @objc class var className: String {
        return String(describing: self)
    }

}
