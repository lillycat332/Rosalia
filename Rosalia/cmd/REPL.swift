//
//  REPL.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

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
  print("Welcome to Rosalia! Type exit or .q to leave, or .help for help.")
  var running = true
  while running {
    print("> ", terminator: "")
    let input = readLine()
    
    if input == "exit" || input == ".q" || input == nil {
      running = false
    } else if input == ".help" {
      replhelper.help()
    } else {
      // Because if the input is nil by this point SHTF
      print(
        "\("\(replhelper.eval(input!))", color: .green)"
      )
    }
    
  }
}

/// replhelper enum acts as a namespace to contain helper functions for the REPL
enum replhelper {
  static func eval(_ string: String) -> Any {
    var TokenSeq = RosaliaLexer(string: string)
    let toks = TokenSeq.nextUntil(in: [.newline])
    
    // Lex it here...
    // if i'm not lazy, i guess
    
    return toks!
  }
  
  static func help() {
    print(
    """
    Welcome to Rosalia!
    
    Rosalia is an interpreted, functional programming language inspired by Swift,
    Haskell and JavaScript.
    """)
    let metatype = "Type: \(type(of: self))"
    print("\(metatype, color: .blue)")
  }
}
