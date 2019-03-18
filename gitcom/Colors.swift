//
//  Colors.swift
//  gitcom
//
//  Created by Eugene Kalyada on 10/03/2019.
//  Copyright © 2019 EDCODE. All rights reserved.
//

import Foundation

public protocol ModeCode {
	var value: UInt8 { get }
}

public enum Color: UInt8, ModeCode {
	case black = 30
	case red
	case green
	case yellow
	case blue
	case magenta
	case cyan
	case white
	case `default` = 39
	case lightBlack = 90
	case lightRed
	case lightGreen
	case lightYellow
	case lightBlue
	case lightMagenta
	case lightCyan
	case lightWhite
	
	public var value: UInt8 {
		return rawValue
	}
}
extension String {
	func color(_ color: Color) -> String {
		return "\u{001B}[0;\(color.rawValue)m\(self)"
	}
}
