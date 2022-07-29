//
//  Lex.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import Foundation
import SwiftParsec


/// The overarching type for all Rosalia tokens.
/// cases:
/// ```
/// rlist([RosaliaValue])
/// rfloat(Double)
/// rstring(String)
/// rbool(Bool)
/// err
/// ```
/// methods:
/// ```
/// parser()
/// init()
///
/// ```
///
public enum RosaliaValue {
  case rlist   (Array <RosaliaValue>)
  case rfloat  (Double)
  case rstring (String)
  case rbool   (Bool)
  case err
  
  public static let parser: GenericParser<String, (), RosaliaValue> = {
    let rosalia = LanguageDefinition<()>.RosaliaDefinition
    
    let anyChar = StringParser.anyCharacter
    let lexer   = GenericTokenParser(languageDefinition: rosalia)
    let symbol  = lexer.symbol
    let stringLiteral = lexer.stringLiteral
    
    // Comments
    let commentStart = StringParser.string(rosalia.commentLine)
    let commentEnd   = StringParser.newLine
    let comment = (commentStart *> anyChar.manyTill(commentEnd.attempt)).stringValue
    
    // Booleans & Primitives
    let rTrue  = symbol("True")  *> GenericParser(result: true)
    let rFalse = symbol("False") *> GenericParser(result: false)
    let rbool  = RosaliaValue.rbool   <^> (rTrue <|> rFalse)
    let rfloat = RosaliaValue.rfloat  <^> (lexer.float.attempt <|> lexer.integerAsFloat)
    
    // "Container" types - Strings, Lists etc
    let rstring = RosaliaValue.rstring <^> stringLiteral
    var rlist: GenericParser<String, (), RosaliaValue>!
    
    GenericParser.recursive { (rvalue: GenericParser<String, (), RosaliaValue>) in
      let rlistValues = lexer.commaSeparated(rvalue)
      rlist = RosaliaValue.rlist <^> lexer.brackets(rlistValues)
      
      let nameValue: GenericParser<String, (), (String, RosaliaValue)> =
      stringLiteral >>- { name in
        symbol(":") *> rvalue.map { value in (name, value) }
      }
      return rstring <|> rfloat <|> rbool <|> rlist
    }
    return lexer.whiteSpace *> rlist <|> rstring <|> rfloat <|> rbool
  }()
  
  public init(data: String) throws {
    try self = RosaliaValue.parser.run(sourceName: "", input: data)
  }
  
  public var string: String? {
    guard case .rstring(let string) = self else { return nil }
    return string
  }
  
  public var float: Double? {
    guard case .rfloat(let double) = self else { return nil }
    return double
  }
  
  public var boolean: Bool? {
    guard case .rbool(let bool) = self else { return nil }
    return bool
  }
  
  public subscript(index: Int) -> RosaliaValue {
    
    guard case .rlist(let list) = self, index >= 0 && index < list.count else { return .err }
    
    return list[index]
    
  }
  
}

public extension LanguageDefinition {
  static var RosaliaDefinition: LanguageDefinition {
    
    var rosaDef = empty
    
    rosaDef.commentStart = "--*"
    rosaDef.commentEnd   = "*--"
    rosaDef.commentLine  = "--"
    
    return rosaDef
  }
}
