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
/// func flatMap<U>(_ fn: (T) throws -> Maybe<U>) rethrows -> Maybe<U>
/// func map<U>(_ fn: (T) throws -> U) rethrows -> Maybe<U>
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
  
  // Forcibly unwrap the value into a value outside the monad, of type T.
  // In the case that it contains a value of Nothing, crash.
  @inlinable public func unwrap() throws -> T {
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
  
  // Safely unwrap the value into a value outside the monad, of type T.
  // In the case that it contains a value of Nothing, *coalesce* it into the
  // value of (_ value: T).
  @inlinable public func coalesce(_ value: T) -> T {
    switch self {
    case .Just(let x):
      return x
    case .Nothing:
      return value
    }
  }
  
  @inlinable public func flatMap<U>(
    _ fn: (T) throws -> Maybe<U>
  ) rethrows -> Maybe<U> {
    switch self {
    case .Just(let x):
      return try fn(x)
    case .Nothing:
      return .Nothing
    }
  }
  
  // Perform a function on the value contained with in the Maybe, returning a Maybe.
  @inlinable public func map<U>(_ fn: (T) throws -> U) rethrows -> Maybe<U> {
    switch self {
    case .Just(let x):
      return .Just(try fn(x))
    case .Nothing:
      return .Nothing
    }
  }
}
