//
//  ResponseDecoding.swift
//  AppointmentChecker
//
//  Created by Yuchen Nie on 2/23/21.
//

import Foundation
import ReactiveSwift

// A witness type that can decode a given string to a data producer
struct ResponseDecoding<A> where A: Decodable {
  let decode: (Data) -> DataProducer<A>
}

extension ResponseDecoding where A: Decodable {
  // generic type that can handle most decodables
  static var decodable: ResponseDecoding {
    ResponseDecoding { value in
      resultToDataProducer(decodeResult(value))
    }
  }
}

private func resultToDataProducer<A>(_ result: Result<A, DecodeError>) -> DataProducer<A> {
  switch result {
  case let .success(value): return DataProducer(value: value)
  case let .failure(decodeError):
    return DataProducer(error: DataLoadingError.badResponse(decodeError))
  }
}


public enum DecodeError: Error {
  case decoding(DecodingError)
  case missingDataField
  case unknown(String)
}

extension DecodeError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case let .decoding(err):
      switch err {
      case let .typeMismatch(_, context),
           let .valueNotFound(_, context),
           let .keyNotFound(_, context),
           let .dataCorrupted(context):
        return context.debugDescription

      @unknown default: return err.errorDescription
      }
    case let .unknown(message): return message
    case .missingDataField: return "Could not find data field to `deserialize`"
    }
  }
}

private let decoder = JSONDecoder()
public typealias JSONObject = [String: Any]

public func decodeResult<T: Decodable>(_ data: Data) -> Result<T, DecodeError> {
  do {
    let decoded = try decoder.decode(T.self, from: data)
    return .success(decoded)
  } catch {
    if let decodingError = error as? DecodingError {
      return .failure(.decoding(decodingError))
    }
    return .failure(.unknown(error.localizedDescription))
  }
}

public func decodeResult<T: Decodable>(_ string: String) -> Result<T, DecodeError> {
  string.data(using: .utf8).flatMap(decodeResult) ?? Result.failure(.unknown(""))
}

public func decodeResult<T: Decodable>(_ json: JSONObject) -> Result<T, DecodeError> {
  let data: Data? = try? JSONSerialization.data(withJSONObject: json)
  return data.flatMap(decodeResult) ?? Result.failure(.unknown(""))
}
