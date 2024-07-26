//
//  MainViewController.swift
//  neosoft-ios-task-uikit
//
//  Created by JustMac on 26/07/24.
//

import Foundation
import UIKit

class CarouselViewController: UIViewController, UIScrollViewDelegate {
    var currentIndex = 0
    let images = ["lonavala", "pune", "mumbai", "dehradun", "shimla"]
    var scrollView: UIScrollView!
    var pageControl: UIPageControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupPageControl()
    }

    func setupScrollView() {
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: view.bounds.width * CGFloat(images.count), height: view.bounds.height)

        for (index, imageName) in images.enumerated() {
            let imageView = UIImageView(image: UIImage(named: imageName))
            imageView.frame = CGRect(x: view.bounds.width * CGFloat(index), y: 0, width: view.bounds.width, height: view.bounds.height)
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
        }

        view.addSubview(scrollView)
    }

    func setupPageControl() {
        pageControl = UIPageControl(frame: CGRect(x: 0, y: view.bounds.height - 50, width: view.bounds.width, height: 50))
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        view.addSubview(pageControl)
    }

    @objc func pageControlChanged() {
        let offset = CGPoint(x: scrollView.bounds.width * CGFloat(pageControl.currentPage), y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x / view.bounds.width)
        pageControl.currentPage = Int(pageIndex)
    }
}

class ListItem {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String

    init(image: String, title: String, subtitle: String) {
        self.image = image
        self.title = title
        self.subtitle = subtitle
    }
}

class ListViewController: UITableViewController {
    var items: [ListItem] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]

        cell.imageView?.image = UIImage(named: item.image)
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subtitle

        return cell
    }
}

class SearchBarViewController: UIViewController, UISearchBarDelegate {
    var searchText: String = ""
    var searchBar: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
    }

    func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search..."
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        // Notify other parts of the app about the search text change if needed
    }
}

class FloatingActionButton: UIButton {
    init(action: @escaping () -> Void) {
        super.init(frame: .zero)
        addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        setImage(UIImage(systemName: "plus"), for: .normal)
        backgroundColor = .blue
        tintColor = .white
        layer.cornerRadius = 30
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        actionClosure = action
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var actionClosure: (() -> Void)?

    @objc private func buttonTapped() {
        actionClosure?()
    }
}

class BottomSheetViewController: UIViewController, UITableViewDataSource {
    var characterCounts: [Character: Int] = [:]
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterCounts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        let sortedCounts = characterCounts.sorted { $0.value > $1.value }
        let key = sortedCounts[indexPath.row].key
        let value = sortedCounts[indexPath.row].value

        cell.textLabel?.text = String(key)
        cell.detailTextLabel?.text = "\(value)"

        return cell
    }
}

class MainViewController: UIViewController {
    var searchText = ""
    var currentIndex = 0
    var items: [ListItem] = []
    var showBottomSheet = false
    var characterCounts: [Character: Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    func setupViews() {
        let carouselVC = CarouselViewController()
        addChild(carouselVC)
        view.addSubview(carouselVC.view)
        carouselVC.didMove(toParent: self)

        let searchBarVC = SearchBarViewController()
        addChild(searchBarVC)
        view.addSubview(searchBarVC.view)
        searchBarVC.didMove(toParent: self)

        let listVC = ListViewController()
        addChild(listVC)
        view.addSubview(listVC.view)
        listVC.didMove(toParent: self)

        let fab = FloatingActionButton {
            self.showStatistics()
        }
        view.addSubview(fab)

        // Layout code here...

        loadData(for: currentIndex)
    }

    func loadData(for index: Int) {
        let numberOfItems = 20 // Define how many items you want in the list
        let sampleData = (1...numberOfItems).map { i in
            ListItem(image: "lonavala", title: "Title \(index + i)", subtitle: "Subtitle \(index + i)")
        }
        items = sampleData
    }

    func showStatistics() {
        characterCounts = calculateCharacterFrequencies()
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.characterCounts = characterCounts
        present(bottomSheetVC, animated: true, completion: nil)
    }

    func calculateCharacterFrequencies() -> [Character: Int] {
        var counts: [Character: Int] = [:]
        for item in items {
            let combinedText = item.title + item.subtitle
            for char in combinedText {
                counts[char, default: 0] += 1
            }
        }
        return counts
    }
}
