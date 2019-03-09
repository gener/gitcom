//
//  ScopeItem.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

struct ScopeItem: Codable {
	var key: String
	var value: String
	var types: [String]?
}
