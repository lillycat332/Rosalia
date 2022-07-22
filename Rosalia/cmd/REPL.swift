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
  print("Welcome to Rosalia")
  handleFatal(printer: { "FUCK" })
}

