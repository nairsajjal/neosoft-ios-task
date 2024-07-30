//
//  ImageListTableViewCell.swift
//  ilaBank_Test-Tejaswini
//
//  Created by Neosoft on 01/07/24.
//

import UIKit

class ImageListTableViewCell: UITableViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureData(_ data: ListData) {
        imgView.image = UIImage(named: data.image)
        lblTitle.text = data.title
    }

}
