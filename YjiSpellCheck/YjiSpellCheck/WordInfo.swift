//
//  WordInfo.swift
//  XcodePowerPack
//
//  Created by Ericji Workspace on 2017/03/04.
//  Copyright © 2017年 Tonny Xu. All rights reserved.
//

import Cocoa

class WordInfo: NSObject {
    public var rowNum: NSInteger?
    public var lineNum: NSInteger?
    public var filePath: String?
    public var content: String?
    
    public var hasWarning: Bool = false
    private lazy var warningMsg: String = "\(self.filePath!)" + ":\(self.lineNum!):" + " warning: " + "\(self.content!) is not right"
    
    func getWarningMsg() -> String? {
        if self.hasWarning {
            return self.warningMsg
        } else {
            return nil
        }
    }
}
