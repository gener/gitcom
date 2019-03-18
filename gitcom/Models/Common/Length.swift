//
//  Length.swift
//  gitcom
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct Length: Codable {
	struct Val: Codable {
		static func min(_ value: Int) -> Val {
			return Length.Val(value: value)
		}
		static func max(_ value: Int) -> Val {
			return Length.Val(value: value)
		}

		static let min: Val = Val.min(5)
		static let max: Val = Val.max(72)
		var value: Int
		
		func insufficient(prefix: String) -> String {
			return "\(prefix) has insufficient length (min: \(value))."
		}
		
		func excess(prefix: String) -> String {
			return "\(prefix) has excess length (max: \(value))."
		}
		
	}
	var min: Val?
	var max: Val?
}
