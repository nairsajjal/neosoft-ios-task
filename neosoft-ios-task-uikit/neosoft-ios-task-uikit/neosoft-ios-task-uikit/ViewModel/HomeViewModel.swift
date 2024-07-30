//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import Foundation

protocol HomeViewModelProtocol {
    func getData() -> [CarousalDetailData]
    func getListingData(index:Int) -> [ListData]?
    func numberOfRows(index: Int) -> Int
    func searchData(str:String, index:Int)
    func updateSearch(isSearch:Bool, index:Int)
    func getCarouselJsonData()
}

class HomeViewModel : HomeViewModelProtocol {
    
    private var carouselData : [CarousalDetailData]?
    private var filteredListData : [ListData]?
    private var requestManager: FileReaderProtocol = FileReader()
    private var isSearchActive:Bool = false
    func getData() -> [CarousalDetailData] {
        if let data = carouselData {
            return data
        }
        return [CarousalDetailData]()
    }
    
    func getCarouselData(index: Int) -> CarousalDetailData? {
        if getData().count > index {
            return getData()[index]
        }
        return nil
    }
    
    func getListingData(index:Int) -> [ListData]? {
        if let listData = getCarouselData(index: index) {
            if isSearchActive {
              return filteredListData
            }
            filteredListData = listData.listData
            return filteredListData
        }
        return nil
    }
    
    func numberOfRows(index: Int) -> Int {
        if let listData = getListingData(index: index) {
            return listData.count
        }
        return 0
    }
}

// MARK: getCarouselJsonData
extension HomeViewModel {
    func getCarouselJsonData(){
        do {
            let response: CarouselData = try requestManager.loadDataFrom(file: "Carousel_Data", type: "json")
            carouselData = response.data
        } catch {
        }
    }
}

// MARK : Search
extension HomeViewModel {
    
    func searchData(str:String, index:Int) {
        isSearchActive = true
        let data = getData()[index].listData
        filteredListData = data.filter({ content in
            return content.title.range(of: str, options: .caseInsensitive) != nil
        })
        print("filteredListDataCount\(filteredListData?.count ?? 0)")
    }
    
    func updateSearch(isSearch:Bool, index:Int) {
        isSearchActive = isSearch
        let data = getData()[index].listData
        filteredListData  = data
    }
}
