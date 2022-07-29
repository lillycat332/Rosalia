//
//  main.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import Foundation
import ArgumentParser
import Dispatch

@main struct Rosalia: ParsableCommand {
  static let configuration: CommandConfiguration =
  CommandConfiguration (
      commandName: "Rosalia"
    , subcommands:
    [ repl.self
    , run.self
    , check.self
    ]
    , defaultSubcommand: repl.self
  )
  @Flag(help:"Enable EXPERIMENTAL! features") var EXPERIMENTAL: Bool = false
}

extension Rosalia {
  struct repl: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration (
      abstract: "Experiment with Rosalia interactively"
    , usage: """
    Explore Rosalia, the standard library and its type system. Use .q, ^D or exit
    to quit, and .help for more detailed usage information.
    """
    )
    
    func run() throws {
      signal(SIGINT, SIG_IGN)
      REPL()
    }
  }
  
  struct run: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration (
      abstract: """
      Run a Rosalia (.rosalia, .rslia) file in the interpreter, or read from STDIN.
      """
//    , usage: "Rosalia run <file>"
    )
    
    @Argument(help: "The file to run.") var file: String?
    
    func run() {
      Interpret(code: file!)
    }
  }
  
  struct check: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration (
      abstract: "Check, and optionally correct a rosalia file (or input from STDIN) for syntax and type errors"
    , usage: "Rosalia check [--correct, -c] <file>"
    )
    
    @Argument(help: "The file to check") var file: String?
    func run() {
      TypeCheck(code: file!)
    }
  }
}


