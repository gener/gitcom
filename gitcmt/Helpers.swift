//
//  Helpers.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

extension String {
	func capturedGroups(withRegex pattern: String) -> [String] {
		var results = [String]()
		
		var regex: NSRegularExpression
		do {
			regex = try NSRegularExpression(pattern: pattern, options: [])
		} catch {
			return results
		}
		let matches = regex.matches(in: self, options: [], range: NSRange(location:0, length: self.count))
		
		guard let match = matches.first else { return results }
		
		let lastRangeIndex = match.numberOfRanges - 1
		guard lastRangeIndex >= 1 else { return results }
		
		for i in 1...lastRangeIndex {
			let capturedGroupIndex = match.range(at: i)
			let matchedString = (self as NSString).substring(with: capturedGroupIndex)
			results.append(matchedString)
		}
		
		return results
	}
}

public extension Array {
	public subscript (safe index: Int) -> Element? {
		return indices ~= index ? self[index] : nil
	}
}

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
