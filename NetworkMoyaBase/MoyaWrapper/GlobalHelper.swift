//
//  GlobalHelper.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/14.
//

import Foundation
import UIKit

open class GlobalHelper {
    public enum DeviceType:String {
        case UIDeviceUnknown = "Unknown iPhone"
        case UIDeviceiPhoneSimulator = "iPhone Simulator"
        case UIDeviceiPhoneSimulatoriPhone = "iPhone Simulator iphone" // both regular and iPhone 4 devices
        case UIDeviceiPhoneSimulatoriPad = "iPad Simulator"
        
        case UIDevice1GiPhone = "iPhone 1G"
        case UIDevice3GiPhone = "iPhone 3G"
        case UIDevice3GSiPhone = "iPhone 3GS"
        case UIDeviceiPhone4 = "iPhone 4"
        case UIDeviceiPhone4s = "iPhone 4S"
        case UIDeviceiPhone5 = "iPhone 5"
        case UIDeviceiPhone5c = "iPhone 5c"
        case UIDeviceiPhone5s = "iPhone 5s"
        case UIDeviceiPhone6 = "iPhone 6"
        case UIDeviceiPhone6Plus  = "iPhone 6 Plus"
        case UIDeviceiPhone6s = "iPhone 6S"
        case UIDeviceiPhoneSE = "iPhone SE"
        case UIDeviceiPhone6sPlus = "iPhone 6s Plus"
        case UIDeviceiPhone7 = "iPhone 7"
        case UIDeviceiPhone7Plus = "iPhone 7 Plus"
        case UIDeviceiPhone8 = "iPhone 8"
        case UIDeviceiPhone8Plus = "iPhone 8 Plus"
        case UIDeviceiPhoneX = "iPhone X"
        case UIDeviceiPhoneXR = "iPhone XR"
        case UIDeviceiPhoneXS = "iPhone XS"
        case UIDeviceiPhoneXS_Max = "iPhone XS_Max"
        case UIDeviceiPhone11 = "iPhone 11"
        case UIDeviceiPhone11_Pro = "iPhone 11Pro"
        case UIDeviceiPhone11_Pro_Max = "iPhone 11ProMax"
        case UIDeviceiPhoneSE2 = "iPhone SE2"
        case UIDeviceiPhone12 = "iPhone 12"
        case UIDeviceiPhone12Mini = "iPhone 12Mini"
        case UIDeviceiPhone12Pro = "iPhone 12Pro"
        case UIDeviceiPhone12Pro_Max = "iPhone 12ProMax"
        case UIDeviceiPhone13Mini = "iPhone 13 mini"
        case UIDeviceiPhone13 = "iPhone 13"
        case UIDeviceiPhone13Pro = "iPhone 13Pro"
        case UIDeviceiPhone13Pro_Max = "iPhone 13ProMax"
        case UIDeviceiPhoneSE3 = "iPhone SE3"
        case UIDeviceiPhone14 = "iPhone 14"
        case UIDeviceiPhone14Plus = "iPhone 14 Plus"
        case UIDeviceiPhone14Pro = "iPhone 14Pro"
        case UIDeviceiPhone14Pro_Max = "iPhone 14ProMax"

        
        case UIDevice1GiPod = "iPod touch 1G"
        case UIDevice2GiPod = "iPod touch 2G"
        case UIDevice3GiPod = "iPod touch 3G"
        case UIDevice4GiPod = "iPod touch 4G"
        case UIDevice5GiPod = "iPod touch 5G"
        case UIDevice6GiPod = "iPod touch 6G"
        case UIDevice7GiPod = "iPod touch 7G"
        
        case UIDeviceiPad1 = "iPad 1"
        case UIDeviceiPad2 = "iPad 2"
        case UIDeviceiPadMini = "iPad mini"
        case UIDeviceiPadMini2 = "iPad mini2"
        case UIDeviceiPadMini3 = "iPad mini3"
        case UIDeviceiPadMini4 = "iPad mini4"
        case UIDeviceiPadMini5 = "iPad mini5"
        case UIDeviceiPadMini6 = "iPad mini6"

        case UIDeviceiPad3 = "iPad 3"
        case UIDeviceiPad4 = "iPad 4"
        case UIDeviceiPad5 = "iPad 5"
        case UIDeviceiPad6 = "iPad 6"
        case UIDeviceiPad7 = "iPad 7"
        case UIDeviceiPad8 = "iPad 8"
        case UIDeviceiPad9 = "iPad 9"
        case UIDeviceiPad10 = "iPad 10"

        case UIDeviceiPadAir = "iPad Air"
        case UIDeviceiPadAir2 = "iPad Air2"
        case UIDeviceiPadAir3 = "iPad Air3"
        case UIDeviceiPadAir4 = "iPad Air4"
        case UIDeviceiPadAir5 = "iPad Air5"


        case UIDeviceiPadPro_10_5 = "iPad pro 10.5-inch"
        case UIDeviceiPadPro_9_7 = "iPad pro 9.7-inch"
        
        case UIDeviceiPadPro_12_9 = "iPad pro 12.9-inch"
        case UIDeviceiPadPro_12_9_2 = "iPad pro 2nd 12.9-inch"
        case UIDeviceiPadPro_12_9_3 = "iPad pro 3rd 12.9-inch"
        case UIDeviceiPadPro_12_9_4 = "iPad pro 4th 12.9-inch"
        case UIDeviceiPadPro_12_9_5 = "iPad pro 5th 12.9-inch"
        case UIDeviceiPadPro_12_9_6 = "iPad pro 6th 12.9-inch"

        case UIDeviceiPadPro_11_0 = "iPad pro 11-inch"
        case UIDeviceiPadPro_11_0_2 = "iPad pro 2nd 11-inch"
        case UIDeviceiPadPro_11_0_3 = "iPad pro 3rd 11-inch"
        case UIDeviceiPadPro_11_0_4 = "iPad pro 4th 11-inch"

        
        case UIDeviceAppleTV2 = "Apple TV 2G"
        case UIDeviceUnknownAppleTV = "Unknown Apple TV"
        
        case UIDeviceUnknowniPhone = "Unknown iOS device"
        case UIDeviceUnknowniPod = "Unknown iPod"
        case UIDeviceUnknowniPad = "Unknown iPad"
        case UIDeviceIFPGA = "iFPGA"

    }
    static func getAppVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "8.0.0"
    }
    
    static func getAppBuildVersion() -> String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "8.0.0"

    }
    
    static func getSystemVersion() -> String {
        UIDevice.current.systemVersion
    }
    
    static func getDeviceName() -> String {
        UIDevice.current.modelName.rawValue
    }
    
}

extension UIDevice {
    //获取设备具体详细的型号
    var modelName: GlobalHelper.DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        if identifier == "iFPGA" {
            return .UIDeviceIFPGA
        } else if identifier == "iPhone1,1" {
            return .UIDevice1GiPhone
        } else if identifier == "iPhone1,2" {
            return .UIDevice3GiPhone
        } else if identifier.hasPrefix("iPhone2") {
            return .UIDevice3GSiPhone
        } else if identifier.hasPrefix("iPhone3") {
            return .UIDeviceiPhone4
        } else if identifier.hasPrefix("iPhone4") {
            return .UIDeviceiPhone4s
        } else if identifier.hasPrefix("iPhone5,1") {
            return .UIDeviceiPhone5
        } else if identifier.hasPrefix("iPhone5,2") {
            return .UIDeviceiPhone5
        } else if identifier.hasPrefix("iPhone5,3") {
            return .UIDeviceiPhone5c
        } else if identifier.hasPrefix("iPhone5,4") {
            return .UIDeviceiPhone5c
        } else if identifier.hasPrefix("iPhone6") {
            return .UIDeviceiPhone5s
        } else if identifier.hasPrefix("iPhone7,1") {
            return .UIDeviceiPhone6
        } else if identifier.hasPrefix("iPhone7,2") {
            return .UIDeviceiPhone6Plus
        } else if identifier.hasPrefix("iPhone8,2") {
            return .UIDeviceiPhone6sPlus
        } else if identifier.hasPrefix("iPhone8,1") {
            return .UIDeviceiPhone6s
        } else if identifier.hasPrefix("iPhone8,4") {
            return .UIDeviceiPhoneSE
        } else if identifier.hasPrefix("iPhone9,2") {
            return .UIDeviceiPhone7Plus
        } else if identifier.hasPrefix("iPhone9,4") {
            return .UIDeviceiPhone7Plus
        } else if identifier.hasPrefix("iPhone9,1") {
            return .UIDeviceiPhone7
        } else if identifier.hasPrefix("iPhone9,3") {
            return .UIDeviceiPhone7
        } else if identifier.hasPrefix("iPhone10,2") {
            return .UIDeviceiPhone8Plus
        } else if identifier.hasPrefix("iPhone10,5") {
            return .UIDeviceiPhone8Plus
        } else if identifier.hasPrefix("iPhone10,1") {
            return .UIDeviceiPhone8
        } else if identifier.hasPrefix("iPhone10,4") {
            return .UIDeviceiPhone8
        } else if identifier.hasPrefix("iPhone10,3") {
            return .UIDeviceiPhoneX
        } else if identifier.hasPrefix("iPhone10,6") {
            return .UIDeviceiPhoneX
        } else if identifier.hasPrefix("iPhone11,8") {
            return .UIDeviceiPhoneXR
        } else if identifier.hasPrefix("iPhone11,2") {
            return .UIDeviceiPhoneXS
        } else if identifier.hasPrefix("iPhone11,4") {
            return .UIDeviceiPhoneXS_Max
        } else if identifier.hasPrefix("iPhone11,6") {
            return .UIDeviceiPhoneXS_Max
        } else if identifier.hasPrefix("iPhone12,1") {
            return .UIDeviceiPhone11
        } else if identifier.hasPrefix("iPhone12,3") {
            return .UIDeviceiPhone11_Pro
        } else if identifier.hasPrefix("iPhone12,5") {
            return .UIDeviceiPhone11_Pro_Max
        } else if identifier.hasPrefix("iPhone12,8") {
            return .UIDeviceiPhoneSE2
        } else if identifier.hasPrefix("iPhone13,1") {
            return .UIDeviceiPhone12Mini
        } else if identifier.hasPrefix("iPhone13,2") {
            return .UIDeviceiPhone12
        } else if identifier.hasPrefix("iPhone13,3") {
            return .UIDeviceiPhone12Pro
        } else if identifier.hasPrefix("iPhone13,4") {
            return .UIDeviceiPhone12Pro_Max
        } else if identifier.hasPrefix("iPhone14,4") {
            return .UIDeviceiPhone13Mini
        } else if identifier.hasPrefix("iPhone14,5") {
            return .UIDeviceiPhone13
        } else if identifier.hasPrefix("iPhone14,2") {
            return .UIDeviceiPhone13Pro
        } else if identifier.hasPrefix("iPhone14,3") {
            return .UIDeviceiPhone13Pro_Max
        } else if identifier.hasPrefix("iPhone14,6") {
            return .UIDeviceiPhoneSE3
        } else if identifier.hasPrefix("iPhone14,7") {
            return .UIDeviceiPhone14
        } else if identifier.hasPrefix("iPhone14,8") {
            return .UIDeviceiPhone14Plus
        } else if identifier.hasPrefix("iPhone15,2") {
            return .UIDeviceiPhone14Pro
        } else if identifier.hasPrefix("iPhone15,3") {
            return .UIDeviceiPhone14Pro_Max
        } else if identifier.hasPrefix("iPod1") {
            return .UIDevice1GiPod
        } else if identifier.hasPrefix("iPod2") {
            return .UIDevice2GiPod
        } else if identifier.hasPrefix("iPod3") {
            return .UIDevice3GiPod
        } else if identifier.hasPrefix("iPod4") {
            return .UIDevice4GiPod
        } else if identifier.hasPrefix("iPod5") {
            return .UIDevice5GiPod
        } else if identifier.hasPrefix("iPod7") {
            return .UIDevice6GiPod
        } else if identifier.hasPrefix("iPod9") {
            return .UIDevice7GiPod
        } else if identifier.hasPrefix("iPad1") {
            return .UIDeviceiPad1
        } else if identifier.hasPrefix("iPad2,1") {
            return .UIDeviceiPad2
        } else if identifier.hasPrefix("iPad2,2") {
            return .UIDeviceiPad2
        } else if identifier.hasPrefix("iPad2,3") {
            return .UIDeviceiPad2
        } else if identifier.hasPrefix("iPad2,4") {
            return .UIDeviceiPad2
        } else if identifier.hasPrefix("iPad2,5") {
            return .UIDeviceiPadMini
        } else if identifier.hasPrefix("iPad2,6") {
            return .UIDeviceiPadMini
        } else if identifier.hasPrefix("iPad3,1") {
            return .UIDeviceiPad3
        } else if identifier.hasPrefix("iPad3,2") {
            return .UIDeviceiPad3
        } else if identifier.hasPrefix("iPad3,3") {
            return .UIDeviceiPad3
        } else if identifier.hasPrefix("iPad3,4") {
            return .UIDeviceiPad4
        } else if identifier.hasPrefix("iPad3,5") {
            return .UIDeviceiPad4
        } else if identifier.hasPrefix("iPad3,6") {
            return .UIDeviceiPad4
        } else if identifier.hasPrefix("iPad4,1") {
            return .UIDeviceiPadAir
        } else if identifier.hasPrefix("iPad4,2") {
            return .UIDeviceiPadAir
        } else if identifier.hasPrefix("iPad4,3") {
            return .UIDeviceiPadAir
        } else if identifier.hasPrefix("iPad4,4") {
            return .UIDeviceiPadMini2
        } else if identifier.hasPrefix("iPad4,5") {
            return .UIDeviceiPadMini2
        } else if identifier.hasPrefix("iPad4,6") {
            return .UIDeviceiPadMini2
        } else if identifier.hasPrefix("iPad4,7") {
            return .UIDeviceiPadMini3
        } else if identifier.hasPrefix("iPad4,8") {
            return .UIDeviceiPadMini3
        } else if identifier.hasPrefix("iPad4,9") {
            return .UIDeviceiPadMini3
        } else if identifier.hasPrefix("iPad5,1") {
            return .UIDeviceiPadMini4
        } else if identifier.hasPrefix("iPad5,2") {
            return .UIDeviceiPadMini4
        } else if identifier.hasPrefix("iPad5,3") {
            return .UIDeviceiPadAir2
        } else if identifier.hasPrefix("iPad5,4") {
            return .UIDeviceiPadAir2
        } else if identifier.hasPrefix("iPad6,3") {
            return .UIDeviceiPadPro_9_7
        } else if identifier.hasPrefix("iPad6,4") {
            return .UIDeviceiPadPro_9_7
        } else if identifier.hasPrefix("iPad6,7") {
            return .UIDeviceiPadPro_12_9
        } else if identifier.hasPrefix("iPad6,8") {
            return .UIDeviceiPadPro_12_9
        } else if identifier.hasPrefix("iPad6,11") {
            return .UIDeviceiPad5
        } else if identifier.hasPrefix("iPad6,12") {
            return .UIDeviceiPad5
        } else if identifier.hasPrefix("iPad7,1") {
            return .UIDeviceiPadPro_12_9_2
        } else if identifier.hasPrefix("iPad7,2") {
            return .UIDeviceiPadPro_12_9_2
        } else if identifier.hasPrefix("iPad7,3") {
            return .UIDeviceiPadPro_10_5
        } else if identifier.hasPrefix("iPad7,4") {
            return .UIDeviceiPadPro_10_5
        } else if identifier.hasPrefix("iPad7,5") {
            return .UIDeviceiPad6
        } else if identifier.hasPrefix("iPad7,6") {
            return .UIDeviceiPad6
        } else if identifier.hasPrefix("iPad7,11") {
            return .UIDeviceiPad7
        } else if identifier.hasPrefix("iPad7,12") {
            return .UIDeviceiPad7
        } else if identifier.hasPrefix("iPad8,1") {
            return .UIDeviceiPadPro_11_0
        } else if identifier.hasPrefix("iPad8,2") {
            return .UIDeviceiPadPro_11_0
        } else if identifier.hasPrefix("iPad8,3") {
            return .UIDeviceiPadPro_11_0
        } else if identifier.hasPrefix("iPad8,4") {
            return .UIDeviceiPadPro_11_0
        } else if identifier.hasPrefix("iPad8,5") {
            return .UIDeviceiPadPro_12_9_3
        } else if identifier.hasPrefix("iPad8,6") {
            return .UIDeviceiPadPro_12_9_3
        } else if identifier.hasPrefix("iPad8,7") {
            return .UIDeviceiPadPro_12_9_3
        } else if identifier.hasPrefix("iPad8,8") {
            return .UIDeviceiPadPro_12_9_3
        } else if identifier.hasPrefix("iPad8,9") {
            return .UIDeviceiPadPro_11_0_2
        } else if identifier.hasPrefix("iPad8,10") {
            return .UIDeviceiPadPro_11_0_2
        } else if identifier.hasPrefix("iPad8,11") {
            return .UIDeviceiPadPro_12_9_4
        } else if identifier.hasPrefix("iPad8,12") {
            return .UIDeviceiPadPro_12_9_4
        } else if identifier.hasPrefix("iPad11,1") {
            return .UIDeviceiPadMini5
        } else if identifier.hasPrefix("iPad11,2") {
            return .UIDeviceiPadMini5
        } else if identifier.hasPrefix("iPad11,3") {
            return .UIDeviceiPadAir3
        } else if identifier.hasPrefix("iPad11,4") {
            return .UIDeviceiPadAir3
        } else if identifier.hasPrefix("iPad11,6") {
            return .UIDeviceiPad8
        } else if identifier.hasPrefix("iPad11,7") {
            return .UIDeviceiPad8
        } else if identifier.hasPrefix("iPad13,1") {
            return .UIDeviceiPadAir4
        } else if identifier.hasPrefix("iPad13,2") {
            return .UIDeviceiPadAir4
        } else if identifier.hasPrefix("iPad12,1") {
            return .UIDeviceiPad9
        } else if identifier.hasPrefix("iPad12,2") {
            return .UIDeviceiPad9
        } else if identifier.hasPrefix("iPad14,1") {
            return .UIDeviceiPadMini6
        } else if identifier.hasPrefix("iPad14,2") {
            return .UIDeviceiPadMini6
        } else if identifier.hasPrefix("iPad13,4") {
            return .UIDeviceiPadPro_11_0_3
        } else if identifier.hasPrefix("iPad13,5") {
            return .UIDeviceiPadPro_11_0_3
        } else if identifier.hasPrefix("iPad13,6") {
            return .UIDeviceiPadPro_11_0_3
        } else if identifier.hasPrefix("iPad13,7") {
            return .UIDeviceiPadPro_11_0_3
        } else if identifier.hasPrefix("iPad13,8") {
            return .UIDeviceiPadPro_12_9_5
        } else if identifier.hasPrefix("iPad13,9") {
            return .UIDeviceiPadPro_12_9_5
        } else if identifier.hasPrefix("iPad13,10") {
            return .UIDeviceiPadPro_12_9_5
        } else if identifier.hasPrefix("iPad13,11") {
            return .UIDeviceiPadPro_12_9_5
        } else if identifier.hasPrefix("iPad13,16") {
            return .UIDeviceiPadAir5
        } else if identifier.hasPrefix("iPad13,17") {
            return .UIDeviceiPadAir5
        } else if identifier.hasPrefix("iPad13,18") {
            return .UIDeviceiPad10
        } else if identifier.hasPrefix("iPad13,19") {
            return .UIDeviceiPad10
        } else if identifier.hasPrefix("iPad14,3") {
            return .UIDeviceiPadPro_11_0_4
        } else if identifier.hasPrefix("iPad14,4") {
            return .UIDeviceiPadPro_11_0_4
        } else if identifier.hasPrefix("iPad14,5") {
            return .UIDeviceiPadPro_12_9_6
        } else if identifier.hasPrefix("iPad14,6") {
            return .UIDeviceiPadPro_12_9_6
        } else if identifier.hasPrefix("AppleTV2") {
            return .UIDeviceAppleTV2
        } else if identifier.hasPrefix("iPhone") {
            return .UIDeviceUnknowniPhone
        } else if identifier.hasPrefix("iPod") {
            return .UIDeviceUnknowniPod
        } else if identifier.hasPrefix("iPad") {
            return .UIDeviceUnknowniPad
        } else if identifier == "i386" || identifier == "x86_64" {
            if UIScreen.main.bounds.size.width < 768 {
                return .UIDeviceiPhoneSimulatoriPhone
            } else {
                return .UIDeviceiPhoneSimulatoriPad
            }
        }
   
        return .UIDeviceUnknown;
    }
}
