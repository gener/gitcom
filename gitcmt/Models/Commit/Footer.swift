//
//  Footer.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct Footer: Codable {
	var request: String = "Please enter a footer of commit"
	var length: Length = Length(min: nil, max: nil)
	var prefix: String = "META:"
	var enabled: Bool = true
}

