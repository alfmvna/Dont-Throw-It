//
//  UserDefaults.swift
//  Jangan Di Buang
//
//  Created by Allif Maulana on 09/05/20.
//  Copyright © 2020 Allif Maulana. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func setValueForSwitch(value: Bool?) {
        if value != nil {
            UserDefaults.standard.set(value, forKey: "Simpan")
        } else {
            UserDefaults.standard.removeObject(forKey: "Simpan")
        }
        UserDefaults.standard.synchronize()
    }
    
    func getValueOfSwitch() -> Bool? {
        return UserDefaults.standard.value(forKey: "Simpan") as? Bool
    }
    
}
