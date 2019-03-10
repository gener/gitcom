//
//  Lenght.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct Lenght: Codable {
	struct Val: Codable {
		static func min(_ value: Int) -> Val {
			return Lenght.Val(message: "Lenght is so small!", value: value)
		}
		static func max(_ value: Int) -> Val {
			return Lenght.Val(message: "Lenght is so big!", value: value)
		}
		static let min: Val = Val.min(5)
		static let max: Val = Val.max(72)
		var message: String
		var value: Int
		
	}
	var min: Val?
	var max: Val?
}
