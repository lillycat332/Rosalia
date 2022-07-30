//
//  REPL.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import LineNoise
import Foundation
import Dispatch

/// The program state enum keeps track of whether we are in a REPL, or running a script.
enum ProgramState {
  case REPL
  case Program
}

func REPL() {
  signal(SIGINT, SIG_IGN)
  
  var running = true
  let ln = LineNoise()
  ln.setCompletionCallback { currentBuffer in
    let completions =
    [ ".exit"
    , ".q"
    , ".help"
    ]
    
    return completions.filter { $0.hasPrefix(currentBuffer) }
  }
    
  while running {
    do {
      //      let input = try ln.getLine(prompt: "> ")
      //      ln.addHistory(input)
      
      print("> ", terminator: "")
      let input = readLine()
      print("")
      switch input {
      case ".exit", ".q", nil:
        running = false
      case ".help", ".h":
        ReplHelper.help()
      case "fuck you":
        print("Watch your mouth!")
        fatalError("USER_INSULTED_INTERPRETER")
      default:
        do {
          try print(
            ReplHelper.typeColor(ReplHelper.eval(input!))
          )
        }
        catch {
          print("Parse Error: \(error)")
        }
      }
    } catch {
      print("\(error)")
    }
  }
}

/// replhelper enum acts as a namespace to contain helper functions for the REPL
enum ReplHelper {
  static func eval(_ string: String) throws -> RosaliaValue {
    let x = try RosaliaValue(data: string)
    return x
  }
  
  // Colors a rosalia token as a type.
  static func typeColor(_ val: RosaliaValue) -> String {
    return "\("\(val)", color: .blue)"
  }
  
  static func help() {
    print(
    """
    Welcome to Rosalia!

    Rosalia is an interpreted, functional programming language inspired by Swift,
    Haskell and JavaScript.
    """)
    let metatype = "Type: \(type(of: help))"
    print("\(metatype, color: .blue)")
  }
}
