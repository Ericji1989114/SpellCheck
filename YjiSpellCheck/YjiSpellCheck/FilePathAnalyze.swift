//
//  FilePathAnalyze.swift
//  XcodePowerPack
//
//  Created by Ericji Workspace on 2017/03/04.
//  Copyright © 2017年 Tonny Xu. All rights reserved.
//

import Cocoa

class FilePathAnalyze: NSObject {
    
    private let fileManager = FileManager()
    public var resultFilePaths: [String] = []
    
    func getChildPath(superPath: String) {
        // except hidden files
        if self.isHiddenFile(filePath: superPath) {
            return
        }
        do {
            let subPaths = try self.fileManager.contentsOfDirectory(atPath: superPath)
            if subPaths.count > 0 {
                // is a folder file
                let contentFilePaths = self.getFilePaths(fileNames: subPaths, superPath: superPath)
                for path in contentFilePaths {
                    getChildPath(superPath: path)
                }
            } else {
                self.checkFilePath(filePath: superPath)
            }
        } catch {
            // is a file type
            self.checkFilePath(filePath: superPath)
            return
        }
    }
    
    func getFilePaths(fileNames: [String], superPath: String) -> [String] {
        var filePaths: [String] = []
        for fileName in fileNames {
            let filePath = superPath + "/" + fileName
            filePaths.append(filePath)
        }
        return filePaths
    }
    
    func checkFilePath(filePath: String) {
        let pathExtension = (filePath as NSString).pathExtension
        if pathExtension == "m" || pathExtension == "mm" || pathExtension == "swift" || pathExtension == "h" {
            self.resultFilePaths.append(filePath)
        }
    }
    
    func isHiddenFile(filePath: String) -> Bool {
        let fileName = (filePath as NSString).lastPathComponent as NSString
        if fileName.hasPrefix(".") {
            return true
        } else {
            return false
        }
    }
    
}
