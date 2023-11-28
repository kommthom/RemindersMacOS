//
//  AsyncMap.swift
//  RemindersMacOS
//
//  Created by Thomas on 16.10.23.
//

import Foundation
import Combine

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async -> T
    ) -> Publishers.FlatMap<Future<T, Never>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    let output = await transform(value)
                    promise(.success(output))
                }
            }
        }
    }
}

/*
 struct PhotoRenderer {
     var colorProfile: ColorProfile
     var effect: PhotoEffect

     func render(_ photo: Photo) -> AnyPublisher<UIImage, Never> {
         colorProfile
             .apply(to: photo)
             .asyncMap { photo in
                 let photo = await effect.apply(to: photo)
 return await uiImage(from: photo)
             }
             .eraseToAnyPublisher()
     }

     private func uiImage(from photo: Photo) async -> UIImage {
         ...
     }
 }
 */

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>, Self> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
    let output = try await transform(value)
    promise(.success(output))
} catch {
    promise(.failure(error))
}
                }
            }
        }
    }
}

/*
 class LoginStateController {
     private let keychain: Keychain
     private let userLoader: UserLoader
     ...

     func loadLoggedInUser() -> AnyPublisher<User, Error> {
         keychain
             .loadLoggedInUserID()
             .asyncMap { [userLoader] userID in
                 try await userLoader.loadUser(withID: userID)
             }
             .eraseToAnyPublisher()
     }
 }
 */

extension Publisher {
    func asyncMap<T>(
        _ transform: @escaping (Output) async throws -> T
    ) -> Publishers.FlatMap<Future<T, Error>,
                            Publishers.SetFailureType<Self, Error>> {
        flatMap { value in
            Future { promise in
                Task {
                    do {
                        let output = try await transform(value)
                        promise(.success(output))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
    }
}

/*
 struct PhotoUploader {
     var renderer: PhotoRenderer
     var urlSession = URLSession.shared

     func upload(_ photo: Photo,
                 to url: URL) -> AnyPublisher<URLResponse, Error> {
         renderer
             .render(photo)
             .asyncMap { image in
                 guard let data = image.pngData() else {
                     throw PhotoUploadingError.invalidImage(image)
                 }

                 var request = URLRequest(url: url)
                 request.httpMethod = "POST"

                 let (_, response) = try await urlSession.upload(
     for: request,
     from: data
 )

                 return response
             }
             .eraseToAnyPublisher()
     }
 }
 */
