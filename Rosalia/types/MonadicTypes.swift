//
//  MonadicTypes.swift
//  Rosalia
//
//  Created by Lilly Cham on 22/07/2022.
//

import Foundation

/// # Maybe<T>
/// The `Maybe<T>` type is a *monad*, which can contain a value of type T, or
/// Nothing.
///
/// It has the following methods:
/// ```swift
/// func unwrap() throws -> T
/// func coalesce(_ x: T) -> T
/// func flatMap
/// func map
/// ```
/// `unwrap()` forcibly unwraps the type into a value. If it contains Nothing, a fatal error is thrown.
///
/// In the case it contains Nothing, you can call `.coalesce()` to provide a fallback value. If a
/// Maybe contains nothing, `coalesce()` will return whatever you passed into it. In the case it
/// contains `Just(T)` it will return the value within the `Just()`.
///
/// Example:
/// ```swift
/// let x: Maybe<String> = .Nothing
/// let y = x.unwrap()
/// ```
/// will crash, because it's Nothing and wasn't Coalesced:
/// ```
/// Fatal error: Unexpectedly found Nothing when attempting
/// to unwrap value of type Maybe<Int>
/// ```
/// but:
/// ```swift
/// let y = x.coalesce("Nothing found")
/// ```
/// will assign y "Nothing found".
enum Maybe<T> {
  case Just(T)
  case Nothing
  
  func unwrap() throws -> T {
    switch self {
    case .Just(let x):
      return x
    case .Nothing:
      fatalError(
        """
        Unexpectedly found Nothing when attempting to unwrap value of type \
        \(type(of: self))
        """
      )
    }
  }
  
  func coalesce(_ value: T) -> T {
    switch self {
    case .Just(let x):
      return x
    case .Nothing:
      return value
    }
  }
}
