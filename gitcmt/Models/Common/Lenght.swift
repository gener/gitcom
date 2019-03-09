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
		static let min: Val = Lenght.Val(message: "Lenght is so small!", value: 5)
		static let max: Val = Lenght.Val(message: "Lenght is so big!", value: 72)
		var message: String
		var value: Int
		
	}
	var min: Val?
	var max: Val?
}
