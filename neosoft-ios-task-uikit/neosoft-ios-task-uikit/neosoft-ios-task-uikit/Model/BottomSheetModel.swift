//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import Foundation

struct SheetDataModel {
    let index: Int
    var listData: [ListData]
}

struct BottomSheetModel {
    let listCount: Int
    let characterOccurrenceData: [CharacterOccurrenceData]    
}

struct CharacterOccurrenceData {
    let character: String
    let count: Int
}
    
