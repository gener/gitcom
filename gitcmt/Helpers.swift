//
//  Helpers.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

func print(error: Error) {
	print(error: error.localizedDescription)
}

func print(error: String) {
	print("\("error".color(.red))\("".color(.default)): \(error)")
}

func error(errorMessage: String) -> Error {
	return NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessage])
}

func info(message: String) {
	print("\(message.color(.cyan))\("".color(.default))")
}

func print(list: [ItemProtocol]) {
	for (index, type) in list.enumerated() {
		print(item: type, key: "\(index + 1)")
	}
}

func print(item: ItemProtocol, key: String) {
	print("\(key.color(.white))\("".color(.default)) \(item.key) - \(item.value)")

}

enum Result<S,E> {
	case success(S)
	case failure(E)
}
