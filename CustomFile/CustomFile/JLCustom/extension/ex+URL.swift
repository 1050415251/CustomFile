//
//  ex+URL.swift
//  CustomFile
//
//  Created by 国投 on 2019/3/14.
//  Copyright © 2019 FlyKite. All rights reserved.
//

import Foundation

extension URL: ExpressibleByStringLiteral {

    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        let url = URL.init(string: value)!
        self = url
    }


}

