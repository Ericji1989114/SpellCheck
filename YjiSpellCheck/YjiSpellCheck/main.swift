//
//  main.swift
//  spellCheckerCommand
//
//  Created by Tonny Xu on 2017/03/04.
//  Copyright © 2017 Tonny Xu. All rights reserved.
//

import Foundation


func analyzeDataFromCommandlineArgu() {
    let filePaths = CommandLine.arguments
    if filePaths.count < 2 {
        print("Wrong argument")
        exit(1)
    }

    let filePath = filePaths[1]
    print("checking \(filePath)")
    // root handle
    let pathAnalyze = FilePathAnalyze()
    let contentsAnalyze = FileContentsAnalyze()
    pathAnalyze.getChildPath(superPath: filePath)
    let resultFilePaths = pathAnalyze.resultFilePaths // all .swift,.h,.m,.mm file
    for resultFilePath in resultFilePaths {
        let lineStrInfos = contentsAnalyze.getFileContents(filePath: resultFilePath)
        let lineWordInfos = contentsAnalyze.getWordsInfo(arrStrs: lineStrInfos)
        for lineInfo in lineWordInfos {
            for warningMsg in lineInfo.getWarningMsg() {
                print(warningMsg)
            }
        }
    }
}

analyzeDataFromCommandlineArgu()

