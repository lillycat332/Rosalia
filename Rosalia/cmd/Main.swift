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
  static let configuration: CommandConfiguration = CommandConfiguration (
    subcommands: [
      repl.self
    , run.self
    , check.self
    ]
  )
}

extension Rosalia {
  struct repl: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration (
      abstract: "Experiment with Rosalia interactively"
    , usage: """
    Explore Rosalia, the standard library and it's type system. Use .q, ^D or exit
    to quit, and .help for more detailed usage information.
    """
    )
    
    func run() throws {
      REPL()
    }
  }
  
  struct run: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration (
      abstract: "Run a rosalia (.rosalia, .rslia) file in the interpreter"
    , usage: "rosalia run <file>"
    )
    
    @Argument(help: """
    The file to run.
    """) var file: String?
    
    func run() {
      Interpret(code: file!)
    }
  }
  
  struct check: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration (
      abstract: "Check, and optionally correct a rosalia file for syntax and type errors"
    , usage: "rosalia check [--correct, -c] <file>"
    )
  }
}


