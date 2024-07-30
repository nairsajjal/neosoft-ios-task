//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import UIKit
// MARK : UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            viewModel.searchData(str: searchText, index: selectedIndex)
            tableView.reloadData()
        }else {
            updateSearchResult()
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        updateSearchResult()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        updateSearchResult()
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func updateSearchResult(){
        viewModel.updateSearch(isSearch: false, index: selectedIndex)
        tableView.reloadData()
    }
}
