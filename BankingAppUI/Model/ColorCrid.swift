//
//  ColorCrid.swift
//  BankingAppUI
//
//  Created by nakamura motoki on 2022/02/10.
//

import SwiftUI

// MARK: Sample Model
struct ColorGrid: Identifiable{
    var id = UUID().uuidString
    var hexValue: String
    var color: Color
    // MARK: Animation Properties for Each Card
    var rotateCards: Bool = false
    var addToGrid: Bool = false
    var showText: Bool = false
    var removeFromView: Bool = false
}
