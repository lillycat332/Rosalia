//
//  main.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import Foundation
import ArgumentParser

var PROGRAM_STATE: ProgramState = .REPL

@main struct Rosalia: ParsableCommand {
  @Flag(help: "Whether to run a REPL or not") var repl = false
  
  @Argument(help: "The file to run") var file: String
  
  mutating func run() throws {
    if repl {
      PROGRAM_STATE = .REPL
      REPL()
    }
    else {
      PROGRAM_STATE = .Program
      fatalError("Not implemented")
    }
  }
}


