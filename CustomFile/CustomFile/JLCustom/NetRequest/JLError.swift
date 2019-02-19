//
//  JLError.swift
//  CustomFile
//
//  Created by 国投 on 2019/2/19.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation



enum JLError: LocalizedError {
    case unknowerror //未知错误
    case dataError


    var errorDescription: String? {
        switch self {
        case .unknowerror:
            return "未知错误"
        case .dataError:
            return "数据错误"

        }

    }

}
