//
//  Trie.swift
//  XcodePowerPack
//
//  Created by Tonny Xu on 2017/03/04.
//  Copyright © 2017 Tonny Xu. All rights reserved.
//

import Foundation

extension String {

    var length: Int {
        return self.characters.count
    }

    func substringToIndex(to: Int) -> String {
        if to > self.length {
            return ""
        }
        let targetIdx = self.index(self.startIndex, offsetBy: to)
        return self.substring(to: targetIdx)
    }
}

public class TrieNode {

    private var parent: TrieNode?
    var children = [String:TrieNode]()
    private var char: String?
    private var isLeaf = true
    private var isWord = false

    init() {
    }

    convenience init(char: String, parent: TrieNode) {
        self.init()
        self.char = char
        self.parent = parent
    }

    func insert(word: String) {
        isLeaf = false
        let firstChar = word.substringToIndex(to: 1)
        addChildNodeForChar(char: firstChar)

        if word.length > 1 {
            addWordToChildNode(word: word, atChar: firstChar)
        } else {
            children[firstChar]?.isWord = true
        }
    }

    private func addChildNodeForChar(char: String) {
        if children[char] as TrieNode! == nil {
            let childNode = TrieNode(char: char, parent: self)
            children[char] = childNode
        }
    }

    private func addWordToChildNode(word: String, atChar char: String) {
        let index = word.index(word.startIndex, offsetBy: 1)
        children[char]?.insert(word: word.substring(from: index))
    }

    func nodeForCharacter(char: String) -> TrieNode? {
        return children[char]
    }

    func words() -> [String] {
        var words = [String]()
        if isWord {
            words.append(asString())
        }
        if !isLeaf {
            for child in children.values {
                words += child.words()
            }
        }
        return words
    }

    func asString() -> String {
        if parent == nil {
            return ""
        }
        return parent!.asString() + String(char!)
    }
    
}

public struct Trie {

    private var rootNode = TrieNode()

    public init() {
    }

    public mutating func buildTrie(withWords: [String]) {
        for aWord in withWords {
            self.insert(word: aWord.lowercased())
        }
    }

    public mutating func insert(word: String) {
        rootNode.insert(word: word)
    }

    public mutating func remove(word: String) {
        let filteredWords = allWords().filter { $0 != word }
        if filteredWords.count == 0 {
            rootNode = TrieNode()
        } else {
            for word in filteredWords {
                rootNode.insert(word: word)
            }
        }
    }

    private func allWords() -> [String] {
        var allWords = [String]()
        for node in rootNode.children.values {
            allWords += node.words()
        }
        return allWords
    }

    public func wordsForPrefix(prefix: String) -> [String]? {
        if prefix.length <= 2 {
            return [prefix]
        }

        var lastNode = rootNode
        for character in prefix.lowercased().characters {
            if let aNode = lastNode.nodeForCharacter(char: String(character)) {
                lastNode = aNode
            }
        }
        return lastNode === rootNode ? nil : lastNode.words()
    }

}
