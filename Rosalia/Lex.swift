//
//  Lex.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import Foundation
import Flexer

// These are the constant symbols used in the language
enum RosaliaTokenKind {
  case character
  case newline
  case number
  case symbol
  case whitespace
  case word
}

typealias RosaliaToken = Flexer.Token<RosaliaTokenKind>

struct RosaliaTokenSequence: Sequence, IteratorProtocol, StringInitializable {
  public typealias Element = RosaliaToken
  
  private var lexer: Flexer.BasicTextCharacterLexer
  
  public init(string: String) {
    self.lexer = BasicTextCharacterLexer(string: string)
  }
  
  public mutating func next() -> RosaliaToken? {
    guard let token = lexer.peek()
    else {
      return nil
    }
    
    switch token.kind {
    case .lowercaseLetter, .uppercaseLetter, .underscore:
      guard let endingToken = lexer.nextUntil(notIn: [.lowercaseLetter, .uppercaseLetter, .underscore, .digit])
      else {
        return nil
      }
      return RosaliaToken(kind: .word, range: token.startIndex..<endingToken.endIndex)
    case .digit:
      guard let endingToken = lexer.nextUntil({$0.kind != .digit})
      else {
        return nil
      }
      
      return RosaliaToken(kind: .number, range: token.startIndex..<endingToken.endIndex)
      
    case .tab, .space:
      guard let endingToken = lexer.nextUntil(notIn: [.tab, .space])
      else {
        return nil
      }
      
      return RosaliaToken(kind: .whitespace, range: token.startIndex..<endingToken.endIndex)
      
    case .newline:
      guard let endingToken = lexer.nextUntil(notIn: [.newline])
      else {
        return nil
      }
      return RosaliaToken(kind: .newline, range: token.startIndex..<endingToken.endIndex)
      
      
    default: break
    }
    
    guard let endingToken = lexer.nextUntil(in:[.newline, .tab, .space, .lowercaseLetter, .uppercaseLetter, .underscore, .digit])
    else {
      return nil
    }
    return RosaliaToken(kind: .symbol, range: token.startIndex..<endingToken.endIndex)
  }
}

typealias RosaliaLexer = LookAheadSequence<RosaliaTokenSequence>
