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
  print("Welcome to Rosalia! Type exit or .q to leave.")
  var running = true
  while running {
    print("> ", terminator: "")
    let input = readLine()
    if input == "exit" || input == ".q" || input == nil {
      running = false
    }
    else {
      // Because if the input is nil by this point SHTF
      print(eval(input!))
    }
  }
}

func eval(_ string: String) -> Any {
  var TokenSeq = RosaliaLexer(string: string)
  TokenSeq.nextUntil({ $0.kind == .whitespace })
  
  // Lex it here...
  // if i'm not lazy, i guess
  
  return TokenSeq.tokens
}

