//
//  UserDefaultsManager.swift
//  SlimHUD
//
//  Created by Alex Perathoner on 24/12/22.
//

import Foundation

class UserDefaultsManager {

    static func getItem<T>(for key: String, defaultValue: T) -> T where T: NSCoding, T: NSObject {
        do {
            guard let data = UserDefaults.standard.object(forKey: key) as? Data,
                  // swiftlint:disable:next force_cast
                  let item = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! T? else {
                return defaultValue
            }
            return item
        } catch {
            NSLog("unarchiveTopLevelObjectWithData() failed!")
            return defaultValue
        }
    }

    static func getBool(for key: String, defaultValue: Bool) -> Bool {
        if UserDefaults.standard.valueExists(forKey: key) {
            return UserDefaults.standard.bool(forKey: key)
        } else {
            return defaultValue
        }
    }

    static func getArr<T>(for key: String, defaultValue: [T]) -> [T] {
        // swiftlint:disable:next force_cast
        return UserDefaults.standard.array(forKey: key) as! [T]? ?? defaultValue
    }

    static func getString(for key: String, defaultValue: String) -> String {
        return UserDefaults.standard.string(forKey: key) ?? defaultValue
    }

    static func getInt(for key: String, defaultValue: Int) -> Int {
        if UserDefaults.standard.valueExists(forKey: key) {
            return UserDefaults.standard.integer(forKey: key)
        } else {
            return defaultValue
        }
    }

    static func setItem<T>(_ item: T, for key: String) {
        do {
            UserDefaults.standard.set(try NSKeyedArchiver.archivedData(withRootObject: item, requiringSecureCoding: false), forKey: key)
        } catch {
            NSLog("Failed to archive data!")
        }
    }

}
