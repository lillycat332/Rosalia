//
//  REPL.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import LineNoise
import Foundation

/// The program state enum keeps track of whether we are in a REPL, or running a script.
enum ProgramState {
  case REPL
  case Program
}


func handleFatal(printer: () -> String) {
  if PROGRAM_STATE == .REPL {
    print("Execution failed with error: \(printer()) ")
  } else {
    print("Unrecoverable error: \(printer())")
    fatalError()
  }
}

func REPL() {
  print("Welcome to Rosalia! Type .exit or .q to leave, or .help for help.")
  var running = true
  let ln = LineNoise()
  ln.setCompletionCallback { currentBuffer in
    let completions = [
      ".exit"
    , ".q"
    , ".help"
    ]
    
    return completions.filter { $0.hasPrefix(currentBuffer) }
  }
  
  while running {
    do {
      let input = try ln.getLine(prompt: "> ")
      ln.addHistory(input)
      print("")
      
      if input == ".exit" || input == ".q" {
        running = false
      }
      else if input == ".help" {
        ReplHelper.help()
      }
      else {
        do {
          try print(
            "\(ReplHelper.eval(input))"
          )
        }
        catch ParseError.UnexpectedToken {
          print("Parse Error: Unexpected, malformed or otherwise invalid token")
        }
      }
    } catch LinenoiseError.EOF {
      exit(0)
    } catch {
      print("\(error)")
    }
  }
}

/// replhelper enum acts as a namespace to contain helper functions for the REPL
enum ReplHelper {
  static func eval(_ string: String) throws -> RosaliaToken {
    try lex(string)
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
