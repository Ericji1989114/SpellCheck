//
//  SpellChecker.swift
//  XcodePowerPack
//
//  Created by Tonny Xu on 2017/02/28.
//  Copyright © 2017 Tonny Xu. All rights reserved.
//

import Foundation

struct Constants{
    static let A:Character = "A"
    static let Z:Character = "Z"
}

extension CharacterSet {
    public static var codeCharacterSet : CharacterSet {
        return CharacterSet(charactersIn: "=").union(.punctuationCharacters).union(.symbols).union(.newlines).union(.decimalDigits)
    }
}

extension String {
    public var words: [String] {
        return components(separatedBy: CharacterSet.codeCharacterSet)
            .joined(separator: " ")
            .components(separatedBy: " ")
            .filter {!$0.isEmpty}
            .map { $0.emojilessString.cut }
            .filter { $0.characters.count > 0}
            .joined(separator: " ")
            .components(separatedBy: " ")
            .filter { $0.characters.count > 0}
    }

    public var cut : String {
        let mappedC = self.characters.map { (c) -> String in
            if c >= Constants.A && c <= Constants.Z {
                return " " + String(c).lowercased()
            }
            return String(c)
        }.joined()
        return mappedC.components(separatedBy: " ").filter{$0.characters.count > 1}.joined(separator: " ")
    }

    public var emojilessString : String {
        return self.unicodeScalars.filter { !$0.isEmoji && !$0.isZeroWidthJoiner }.reduce("") { $0+String($1) }
    }
}

extension UnicodeScalar {
    // see: http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
    // see: http://unicode.org/Public/emoji/4.0/emoji-data.txt
    // see: http://unicode.org/emoji/charts/full-emoji-list.html
    public var isEmoji: Bool {
        switch value {
        case 0x3030, 0x00AE, 0x00A9,    // Special Characters
        0x1D000 ... 0x1F77F,            // Emoticons
        0x2100 ... 0x27BF,              // Misc symbols and Dingbats
        0xFE00 ... 0xFE0F,              // Variation Selectors
        0x1F900 ... 0x1F9FF:            // Supplemental Symbols and Pictographs
            return true

        default: return false
        }
    }

    var isZeroWidthJoiner: Bool {
        return value == 0x200D
    }
}


public class SpellChecker {
    static let sharedInstance = SpellChecker()
    var dictLoaded = false
    var trie = Trie()

    private init(){
        // need to support 2 kinds of loading:
        // 1. for framework, which is in Resources folder
        // 2. for binary command, it will be the same folder

        let mainBundle = Bundle.main
        if let dictBundleUrl = mainBundle.url(forResource:"Dictionaries", withExtension:"bundle") {
            print("OK,mainBundle: \(mainBundle), \(dictBundleUrl)")
            // inside a framework
            if let dictBundle = Bundle.init(url: dictBundleUrl){
                print("OK, dictBundle: \(dictBundle)")
                self.loadDictionaries(inBundle: dictBundle)
            } else {
                print("Oooooops! dictBundle is nil")
            }
        } else {
            print("Oops! \(mainBundle)")
        }
    }

    private func loadDictionaries(inBundle:Bundle){
        let dictBundle = inBundle
        if let dictUrls = dictBundle.urls(forResourcesWithExtension: "txt", subdirectory: nil) {
            self.dictLoaded = true
            for aUrl in dictUrls {
                do {
                    let words = try String(contentsOf: aUrl, encoding: String.Encoding.utf8)
                    let wordsArray = words.components(separatedBy: "\n")
                    self.trie.buildTrie(withWords: wordsArray)
                }
                catch {}
            }
        }
    }

    func isValid(word: String) -> Bool {
        if !self.dictLoaded {
            print("Oops!, dict not loaded")
            return true
        }
        if let results = self.trie.wordsForPrefix(prefix: word) {
            var hasExactMatch = false
//            print("[DEBUG]result for \(word) is \(results)")
            for aResult in results {
                if aResult == word.lowercased() {
                    hasExactMatch = true
                    break
                }
            }

            return hasExactMatch
        }

        return false
    }

}
