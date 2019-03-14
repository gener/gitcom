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
			return Length.Val(message: "Length is so small!", value: value)
		}
		static func max(_ value: Int) -> Val {
			return Length.Val(message: "Length is so big!", value: value)
		}
		static let min: Val = Val.min(5)
		static let max: Val = Val.max(72)
		var message: String
		var value: Int
		
	}
	var min: Val?
	var max: Val?
}
