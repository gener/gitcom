//
//  HeaderItem.swift
//  gitcmt
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

protocol ItemProtocol {
	var key: String {get}
	var value: String {get}
}

struct TypeItem: ItemProtocol, Codable {
	var key: String
	var value: String
}

struct ScopeItem: ItemProtocol, Codable {
	var key: String
	var value: String
	var types: [String]?
}
