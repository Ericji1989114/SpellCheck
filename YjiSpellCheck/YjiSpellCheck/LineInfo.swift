//
//  LineInfo.swift
//  XcodePowerPack
//
//  Created by Ericji Workspace on 2017/03/04.
//  Copyright © 2017年 Tonny Xu. All rights reserved.
//

import Cocoa

class LineInfo: NSObject {
    var wordInfos: [WordInfo] = []
    func getWarningMsg() -> [String] {
        var msgs: [String] = []
        for wordInfo in wordInfos {
            if wordInfo.hasWarning {
                msgs.append(wordInfo.getWarningMsg()!)
            }
        }
        return msgs
    }
}
