//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import Foundation

protocol FileReaderProtocol {
    func loadDataFrom<T: Decodable>(file: String, type: String) throws -> T
}

final class FileReader: FileReaderProtocol {
    // MARK: loading data from local path file
    func loadDataFrom<T: Decodable>(file: String, type: String) throws -> T {
        guard let path = Bundle.main.url(forResource: file, withExtension: type)else {
            throw CustomError.invalidPath
        }
        let data = try Data(contentsOf: path )
        let response = try JSONDecoder().decode(T.self, from: data)
        return response
    }
}

enum CustomError: LocalizedError {
    case invalidPath
 }
