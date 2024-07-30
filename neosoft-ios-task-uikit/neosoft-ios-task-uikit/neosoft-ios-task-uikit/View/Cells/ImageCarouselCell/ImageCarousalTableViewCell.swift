//
//  ImageCarousalTableViewCell.swift
//  ilaBank_Test-Tejaswini
//
//  Created by Neosoft on 01/07/24.
//

import UIKit
protocol ImageCarousalTableViewCellProtocol {
    func updateList(index: Int)
}

class ImageCarousalTableViewCell: UITableViewCell {
    // MARK: @IBOutlets
    @IBOutlet weak var carousalCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var homeData: [CarousalDetailData]?
    var imageCarousalTableViewCellDelegate: ImageCarousalTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    func setupCollectionView(){
        carousalCollectionView.delegate = self
        carousalCollectionView.dataSource = self
        carousalCollectionView.register(UINib(nibName: HomeViewConstants.carousalDetailCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: HomeViewConstants.carousalDetailCollectionViewCell)
    }
    
    func setDelegate(delegate: ImageCarousalTableViewCellProtocol?) {
        self.imageCarousalTableViewCellDelegate = delegate
    }
    
}

// MARK: UICollectionViewDataSource
extension ImageCarousalTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let data = homeData {
            pageControl.numberOfPages = data.count
            return data.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewConstants.carousalDetailCollectionViewCell, for: indexPath) as? CarousalDetailCollectionViewCell {
            if let data = homeData {
                cell.imageView.image =  UIImage(named: data[indexPath.row].image)
            }
            return cell
        }
        return UICollectionViewCell()
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ImageCarousalTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: ScrollView Delegate
extension ImageCarousalTableViewCell {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage
        if let delegate = imageCarousalTableViewCellDelegate {
            delegate.updateList(index: currentPage)
        }
    }
}

