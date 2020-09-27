//
//  MasterViewController.swift
//  iOSTestDeviget
//
//  Created by Bryan Rodriguez on 9/25/20.
//

import Foundation

import UIKit

class MasterViewController: UIViewController {

    typealias DiffableDataSource = UICollectionViewDiffableDataSource<Section, RedditPostDTO>
    
    enum Section {
      case main
    }
    
    enum Constants {
        static let cellNameAndIdentifier = "RedditPostCollectionViewCell"
    }
    
    enum SegueID {
        static let detailIdentifier = "ShowDetail"
    }
 
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var dismissAllButton: UIButton!
    private let refreshControl = UIRefreshControl()

    lazy var dataSource: DiffableDataSource = makeDataSource()
    
    lazy var viewModel: MasterViewModel = {
        return DefaultMasterViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.topViewController as? DetailViewController
        else {
            fatalError()
        }
        
        viewController.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        viewController.navigationItem.leftItemsSupplementBackButton = true
        
        if let selectedPost = viewModel.selectedPost {
            viewController.viewModel = DefaultDetailViewModel(redditPost: selectedPost)
        }
    }

    func setupView() {
        title = viewModel.screenTitle
        dismissAllButton.setTitle(viewModel.dismissButtonTitle, for: .normal)
        setupRefreshControl()
        setupCollectionView()
        bindToViewModel()
        viewModel.initialize()
    }
    
    func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshRedditPosts(_:)), for: .valueChanged)
        refreshControl.tintColor = .white
    }
    
    func setupCollectionView() {
        registerCells()
        collectionView.backgroundColor = .black
        collectionView.setCollectionViewLayout(makeLayout(), animated: false)
        collectionView.delegate = self
        collectionView.refreshControl = refreshControl
    }
    
    private func registerCells() {
        collectionView.register(UINib(nibName: Constants.cellNameAndIdentifier,
                                      bundle: nil),
                                forCellWithReuseIdentifier: Constants.cellNameAndIdentifier)
    }

    private func bindToViewModel() {
        viewModel.bindingDelegate = self
    }

    private func makeDataSource() -> DiffableDataSource {
        let dataSource = DiffableDataSource(
          collectionView: collectionView,
          cellProvider: { (collectionView, indexPath, redditPost) ->
            UICollectionViewCell? in
                let cell = collectionView.dequeueReusableCell(
                  withReuseIdentifier: Constants.cellNameAndIdentifier,
                  for: indexPath) as? RedditPostCollectionViewCell
                
            var cellViewModel = RedditPostCollectionViewModel(redditPost: redditPost)
            cellViewModel.delegate = self
            cell?.viewModel = cellViewModel
                
            return cell
        })
        return dataSource
    }
    
     private func makeLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) ->
            NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(200))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(200))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
         
         return layout
     }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, RedditPostDTO>()
        snapshot.appendSections([.main])
        snapshot.appendItems(viewModel.redditPosts)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    @IBAction private func didTapDismissAllButton(_ sender: Any) {
        viewModel.dismissAllPosts()
    }
    
    @objc
    private func refreshRedditPosts(_ sender: Any) {
        viewModel.initialize()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
        viewModel.saveStateUsing(coder: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        super.decodeRestorableState(with: coder)
        viewModel.restoreStateUsing(coder: coder)
    }
}

// MARK: - UICollectionViewDelegate

extension MasterViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard let redditPost = dataSource.itemIdentifier(for: indexPath) else {
          return
        }
        viewModel.selectPost(redditPost)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.redditPosts.count - 1 {
            viewModel.requestMorePosts()
        }
    }
}

extension MasterViewController: MasterViewModelBinding {
    func reloadAllData() {
        refreshControl.endRefreshing()
        applySnapshot()
    }
    
    func showDetail() {
        performSegue(withIdentifier: SegueID.detailIdentifier, sender: nil)
    }
}

extension MasterViewController: RedditPostCollectionViewModelDelegate {
    func didTapDismissPost(_ post: RedditPostDTO) {
        viewModel.dismissPost(post)
    }
}
