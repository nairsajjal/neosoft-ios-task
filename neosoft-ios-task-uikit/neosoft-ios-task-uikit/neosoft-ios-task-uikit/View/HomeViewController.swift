//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    // MARK: @IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    let viewModel:HomeViewModelProtocol = HomeViewModel()
    var selectedIndex = 0
    private var searchBar = UISearchBar()
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupTableView()
        setupSearchBar()
        getCarouselData()
    }
}

// MARK: SetupViews
extension HomeViewController {
    private func setupTableView(){
        tableView.register(UINib(nibName: HomeViewConstants.imageCarousalTableViewCell, bundle: nil), forCellReuseIdentifier: HomeViewConstants.imageCarousalTableViewCell)
        tableView.register(UINib(nibName: HomeViewConstants.imageListTableViewCell, bundle: nil), forCellReuseIdentifier: HomeViewConstants.imageListTableViewCell )
    }
    
    private func setupSearchBar() {
        searchBar.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: tableView.frame.size.height)
        searchBar.delegate = self
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.placeholder = "Search"
    }
}

// MARK: UITableView Delegates & Datasource
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            return viewModel.numberOfRows(index: selectedIndex)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewConstants.imageCarousalTableViewCell, for: indexPath) as?  ImageCarousalTableViewCell {
                cell.setDelegate(delegate: self)
                cell.homeData = viewModel.getData()
                cell.carousalCollectionView.reloadData()
                return cell
            }
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: HomeViewConstants.imageListTableViewCell, for: indexPath) as? ImageListTableViewCell {
                if let listData = viewModel.getListingData(index: selectedIndex) {
                    cell.configureData(listData[indexPath.row])
                }
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 250
        }else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            return searchBar
        }else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1 {
            return 60
        }else {
            return 1
        }
    }
}

// MARK: getCarouselData
extension HomeViewController {
    private func getCarouselData() {
        viewModel.getCarouselJsonData()
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

// MARK: ImageCarousalTableViewCellProtocol
extension HomeViewController : ImageCarousalTableViewCellProtocol {
    func updateList(index: Int) {
        self.selectedIndex = index
        updateSearchResult()
        UIView.performWithoutAnimation {
            tableView.reloadSections(IndexSet(integer: 1), with: .none)
        }
    }
}

// MARK : BottomSheetAction
extension HomeViewController {
    @IBAction func btnBottomSheetAction(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let bottomSheetVC = storyboard.instantiateViewController(withIdentifier: HomeViewConstants.bottomSheetPoppupView) as? BottomSheetPoppupView else {
            return
        }
        
        if let listData = viewModel.getListingData(index: selectedIndex) {
            let sheetData = SheetDataModel(index: selectedIndex, listData: listData)
            bottomSheetVC.viewModel.sheetData = sheetData
            bottomSheetVC.modalTransitionStyle = .crossDissolve
            bottomSheetVC.modalPresentationStyle = .overFullScreen
            self.present(bottomSheetVC, animated: false)
        }
    }
}
