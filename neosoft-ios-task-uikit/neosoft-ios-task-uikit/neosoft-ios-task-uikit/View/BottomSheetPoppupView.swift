//
//  File.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 30/07/24.
//

import UIKit

class BottomSheetPoppupView: UIViewController {
    
    // MARK: @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblListTitle: UILabel!
    @IBOutlet var sheetView: UIView!
    
    private var characterOccurrenceData:[CharacterOccurrenceData]?
    private var bottomSheetData: BottomSheetModel?
    private var sheetData: SheetDataModel?
    var viewModel:BottomSheetPopupViewModelProtocol = BottomSheetPopupViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    func setupData(){
        lblListTitle.text = viewModel.getListTitle()
        if let data = viewModel.topThreeCharactersOccurrenc(){
            characterOccurrenceData = data
            tableView.reloadData()
        }
    }
}

// MARK: UITableViewDataSource & Delegate
extension BottomSheetPoppupView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let data = viewModel.getCharactersOccurrencData(index: indexPath.row) {
            let title = "\(data.character.capitalized) = \(data.count)"
            cell.textLabel?.text = title
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
// MARK: touchesBegan
extension BottomSheetPoppupView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        
        if touch?.view != self.sheetView {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
