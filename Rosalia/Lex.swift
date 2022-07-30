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
  case rcomment
  case err
  
  public static let parser: GenericParser<String, (), RosaliaValue> = {
    // First we acquire the language definition. This defines some base values,
    // like comments, newlines and such.
    let rosalia = LanguageDefinition<()>.RosaliaDefinition
    
    // Then we set up some shorthands to use later for convenience, and create
    // an instance of GenericTokenParser.
    let anyChar = StringParser.anyCharacter
    let lexer   = GenericTokenParser(languageDefinition: rosalia)
    let symbol  = lexer.symbol
    let stringLiteral = lexer.stringLiteral
    
    // We define the syntax for a single line comment here.
    let commentStart = StringParser.string(rosalia.commentLine)
    let commentEnd   = StringParser.newLine
    
    // Let a comment be defined as: commentStart (--) then any character until the end of a line.
    let comment = (commentStart *> anyChar.manyTill(commentEnd.attempt)).stringValue
    
    // Now we define the rest of the tokens.
    // Booleans & Primitives
    let rTrue  = symbol("True")  *> GenericParser(result: true)
    let rFalse = symbol("False") *> GenericParser(result: false)
    // A boolean is defined as either True or False
    let rbool  = RosaliaValue.rbool   <^> (rTrue <|> rFalse)
    // A floating point number is defined as either a float (eg. 1.5) or an integer (eg. 1)
    let rfloat = RosaliaValue.rfloat  <^> (lexer.float.attempt <|> lexer.integerAsFloat)
    
    // "Container" types - Strings, Lists etc
    let rstring = RosaliaValue.rstring <^> stringLiteral
    var rlist: GenericParser<String, (), RosaliaValue>!
    
    // Then we run the parser recursively so we can handle stuff like lists,
    // which can be infinitely nested.
    GenericParser.recursive { (rvalue: GenericParser<String, (), RosaliaValue>) in
      let rlistValues = lexer.commaSeparated(rvalue)
      rlist = RosaliaValue.rlist <^> lexer.brackets(rlistValues)
      
      return rstring <|> rfloat <|> rbool <|> rlist
    }
    // Finally, we return one of the tokens, depending on which one we've found.
    // The <|> operator allows it to be any one of them.
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
