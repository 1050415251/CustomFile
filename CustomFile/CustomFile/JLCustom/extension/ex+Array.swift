//
//  ex+Array.swift
//  CustomFile
//
//  Created by 国投 on 2019/1/14.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    func removerepeat() -> [Element] {
        if self.count == 0 {
            return []
        }
        return self.reduce([self[0]], { (result, element) -> [Element] in
            var newresult = result
            if !newresult.contains(element) {
                newresult.append(element)
            }
            return newresult
        })
    }


}
