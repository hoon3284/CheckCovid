//
//  CheckCovid+UserDefaults.swift
//  CheckCovid
//
//  Created by wickedRun on 2021/12/21.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.wickedrun.CheckCovid"
        return UserDefaults(suiteName: appGroupId)!
    }
}
