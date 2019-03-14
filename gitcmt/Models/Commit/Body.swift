//
//  Body.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct Body: Codable {
	var request: String = "Please enter a body of commit"
	var length: Length = Length(min: nil, max: nil)
	var newLineSpacer: String = "|"
}

