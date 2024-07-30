//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import Foundation

protocol BottomSheetPopupViewModelProtocol {
    func getListTitle() -> String
    func numberOfRows() -> Int
    func getCharactersOccurrencData(index: Int) -> CharacterOccurrenceData?
    func topThreeCharactersOccurrenc() -> ([CharacterOccurrenceData]?)
    var sheetData: SheetDataModel? { get set }
}

class BottomSheetPopupViewModel: BottomSheetPopupViewModelProtocol {
    var sheetData: SheetDataModel?
    var characterOccurrenceData: [CharacterOccurrenceData]?
    
    func getListTitle() -> String {
        characterOccurrenceData = topThreeCharactersOccurrenc()
        if let safe_sheetData = sheetData {
            return "List \(safe_sheetData.index + 1) (\(sheetData?.listData.count ?? 0) items)"
        }
        return ""
    }
    
    func numberOfRows() -> Int {
        if let data = characterOccurrenceData {
            return data.count
        }
        return 0
    }
    
    func getCharactersOccurrencData(index: Int) -> CharacterOccurrenceData? {
        if let data = characterOccurrenceData {
            return data[index]
        }
        return nil
    }
    
    private func characterFrequency(in titles: [String]) -> [Character: Int] {
        var frequency: [Character: Int] = [:]
        
        for title in titles {
            for char in title {
                if char != " " {
                    frequency[char, default: 0] += 1
                }
            }
        }
        return frequency
    }
    
    func topThreeCharactersOccurrenc() -> ([CharacterOccurrenceData]?) {
        if let safe_sheetData = sheetData {
            let titles = safe_sheetData.listData.map { $0.title }
            let frequencies = characterFrequency(in: titles)
            let sortedFrequencies = frequencies.sorted { $0.value > $1.value }
            let top3 = sortedFrequencies.prefix(3).map { CharacterOccurrenceData(character: String($0.key), count: $0.value) }
            return (top3)
        }
        return nil
    }
}
