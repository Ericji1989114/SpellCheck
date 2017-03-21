//
//  FileContentsAnalyze.swift
//  XcodePowerPack
//
//  Created by Ericji Workspace on 2017/03/04.
//  Copyright © 2017年 Tonny Xu. All rights reserved.
//

import Cocoa

class FileContentsAnalyze: NSObject {
    
    var filePath: String!
    
    func getFileContents(filePath: String) -> [String] {
        self.filePath = filePath
        var resultArr: [String] = []
        do {
            let content = try String(contentsOfFile: filePath)
            let tmpStrs = content.components(separatedBy: "\n")
            for var str in tmpStrs {
                str = str.trimmingCharacters(in: CharacterSet.whitespaces)
                resultArr.append(str)
            }
            
        } catch {
            return resultArr
        }
        return resultArr
    }
    
    func getWordsInfo(arrStrs: [String]) -> [LineInfo] {
        var resultContent: [LineInfo] = []
        if arrStrs.count == 0 {
            return resultContent
        }
        for str in arrStrs {
            let lineNum = arrStrs.index(of: str)
            let words = str.words
            let lineInfo = LineInfo()
            for word in words {
                let wordInfo = WordInfo()
                wordInfo.filePath = self.filePath
                wordInfo.lineNum = lineNum! + 1
                wordInfo.rowNum = words.index(of: word)
                wordInfo.content = word
                // TODO: check word correct or not
                if SpellChecker.sharedInstance.isValid(word: word) {
                    wordInfo.hasWarning = false
                } else {
                    wordInfo.hasWarning = true
                }
                lineInfo.wordInfos.append(wordInfo)
            }
            resultContent.append(lineInfo)
        }
        return resultContent
    }
    
}
