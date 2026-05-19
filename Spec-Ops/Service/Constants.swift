//
//  Constants.swift
//  Spec-Ops
//
//  Created by Dimitris Poluzos on 17/5/26.
//

import UIKit

enum AppColors {
    static let accent = UIColor.orange
    static let background = UIColor.black
    static let cardBackground = UIColor(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.0)
    static let primaryText = UIColor.white
    static let secondaryText = UIColor.systemGray
}

enum CategoryIcon{
    static func iconName(for category: String) -> String {
        switch category.lowercased() {
        case "laptop":                  return "laptopcomputer"
        case "mobile", "smartphone":    return "iphone"
        case "tablet":                  return "ipad"
        case "monitor":                 return "display"
        case "keyboard":                return "keyboard"
        case "headphones", "headset":   return "headphones"
        case "mouse":                   return "computermouse"
        case "cpu", "processor":        return "cpu"
        case "gpu", "graphics card":    return "memorychip"
        case "storage", "ssd", "hdd":   return "internaldrive"
        case "webcam", "camera":        return "camera"
        case "microphone":              return "microphone"
        default:                        return "desktopcomputer"
        }
    }
}
