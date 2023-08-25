//
//  EnvHelper.swift
//  SwiftAppBase
//
//  Created by anthony zhu on 2023/8/8.
//

import Foundation

public let EnvSwitchChangeNotification = "EnvSwitchChangeNotification"

open class EnvHelper {
    static let EnvSwitchKey = "EnvSwitchKey"

    fileprivate static var currentEnv = Environment(rawValue: UserDefaults.standard.integer(forKey: EnvSwitchKey)) ?? Environment.debug

    public enum Environment: Int {
        case debug
        case uat
        case release
        case build
    }

    public static var env: Environment {
        get { return currentEnv }
        set {
            currentEnv = newValue
            UserDefaults.standard.set(currentEnv.rawValue, forKey: EnvSwitchKey)
            NotificationCenter.default.post(name: Notification.Name(rawValue: EnvSwitchChangeNotification), object: nil)
        }
    }
    
    open class func setupEnvironment(_ preset:Environment) {
        env = preset
    }
    
    open class func getEnvURL(_ key:String) -> URL? {
        return URL(string: EnvironmentTable.shared.getValue(key) ?? "")
    }
}

private class EnvironmentTable {
    public class var shared: EnvironmentTable {
        struct Static {
            static let instance: EnvironmentTable = EnvironmentTable()
        }
        return Static.instance
    }
    
    fileprivate var envEntries: [String:(String?,String?,String?)] = [:]
    
    public func getValue(_ key:String) -> String? {
        if let (debug,uat,release) = envEntries[key] {
            switch EnvHelper.env {
            case .debug:
                return debug
            case .release:
                return release
            case .uat:
                return uat
            case .build:
                #if DEBUG
                 return debug
                #elseif TESTFLIGHT
                 return debug
                #else
                 return release
                #endif
            }
        }
        return nil
    }
    
    init() {
        let envListPath:String? = Bundle.main.path(forResource: "env_list", ofType: "plist")
        if let path = envListPath,let dict = NSDictionary(contentsOfFile: path) as? [String:Any] {
            for ele in dict {
                if let tuple = ele.value as? [String:String] {
                    envEntries[ele.key] = (tuple["DEBUG"], tuple["UAT"], tuple["RELEASE"])
                }
            }
            
        }
    }
}
