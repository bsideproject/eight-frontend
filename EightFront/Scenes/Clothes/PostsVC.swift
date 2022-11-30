//
//  PostsVC.swift
//  EightFront
//
//  Created by wargi on 2022/09/19.
//

import UIKit
import Then
import SnapKit
//MARK: 버릴까/말까 VC
final class PostsVC: UIViewController {
    //MARK: - Properties
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    var snapshot: CategoriesSnapShot!
    var dataSource: CategoriesDataSource!
    private var viewModel = PostsViewModel()
    private lazy var stackContainer = StackContainerView().then {
        $0.selectionDelegate = self
    }
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        CategoryCollectionViewCell.register($0)
    }
    private let navigationView = CommonNavigationView().then {
        $0.backButton.isHidden = true
        $0.titleLabel.text = "버릴까 말까"
        $0.rightButton.setImage(Images.Navigation.post.image)
    }
    private lazy var filterView = FilterView().then {
        if let type = UserDefaults.standard.object(forKey: viewModel.orderTypeForKey) as? String {
            if type == "LATEST" {
                $0.titleLabel.text = "최신순"
            } else {
                $0.titleLabel.text = "인기순"
            }
        } else {
            $0.titleLabel.text = "최신순"
        }
    }
    private let choiceLabel = UILabel().then {
        $0.text = "Skip"
        $0.textColor = Colors.gray005.color
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.regular.font(size: 18)
    }
    private let storageButton = ChoiceView(isLeftImage: true).then {
        $0.titleLabel.text = "보관해요"
        $0.imageView.image = Images.Trade.leftArrow.image
    }
    private let throwButton = ChoiceView(isLeftImage: false).then {
        $0.titleLabel.text = "버릴래요"
        $0.imageView.image = Images.Trade.rightArrow.image
    }
    private let skipLineView = UIView().then {
        $0.backgroundColor = Colors.gray005.color
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(collectionView)
        view.addSubview(filterView)
        view.addSubview(choiceLabel)
        view.addSubview(storageButton)
        view.addSubview(throwButton)
        view.addSubview(stackContainer)
        view.addSubview(skipLineView)
                
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(34)
        }
        filterView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(15)
            $0.right.equalToSuperview()
            $0.width.equalTo(102)
            $0.height.equalTo(34)
        }
        choiceLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.equalTo(72)
            $0.height.equalTo(26)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-44)
        }
        skipLineView.snp.makeConstraints {
            $0.top.equalTo(choiceLabel.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(32)
            $0.height.equalTo(1)
        }
        storageButton.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalTo(choiceLabel.snp.centerY)
            $0.width.equalTo(98)
            $0.height.equalTo(46)
        }
        throwButton.snp.makeConstraints {
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(choiceLabel.snp.centerY)
            $0.width.equalTo(98)
            $0.height.equalTo(46)
        }
        stackContainer.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(54)
            $0.bottom.equalTo(throwButton.snp.top).offset(-28)
            $0.left.right.equalToSuperview().inset(16)
        }
        configureDataSource()
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationView
            .rightButton
            .tapPublisher
            .sink { [weak self] _ in
                let addPostVC = ReportVC(type: .addPost)
                self?.tabBarController?.navigationController?.pushViewController(addPostVC, animated: true)
            }
            .store(in: &viewModel.bag)
        
        storageButton
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.storageTapped()
            }
            .store(in: &viewModel.bag)
        
        throwButton
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.throwTapped()
            }
            .store(in: &viewModel.bag)
        
        filterView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.filterTapped()
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestCategroies
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self, !self.viewModel.categories.isEmpty else { return }
                
                self.collectionView.collectionViewLayout = self.createLayout(with: self.viewModel.categories)
                self.updateDataSnapshot(with: self.viewModel.categories)
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                               animated: false,
                                               scrollPosition: .centeredHorizontally)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestPosts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] categories in
                self?.stackContainer.reloadData()
            }
            .store(in: &viewModel.bag)
        
        choiceLabel
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard !(self?.stackContainer.subviews.isEmpty ?? true) else { return }
                
                self?.stackContainer.skipCardTapAnimation()
            }
            .store(in: &viewModel.bag)
        
        
        viewModel.input.requestCategroies.send(nil)
        viewModel.input.requestPosts.send(nil)
    }
    
    private func configure() {
        stackContainer.delegate = self
        stackContainer.dataSource = self
    }
    
    //MARK: - Handlers
    @objc
    private func resetTapped() {
        stackContainer.reloadData()
    }
    
    @objc
    private func storageTapped() {
        guard !stackContainer.subviews.isEmpty else { return }
        
        stackContainer.removeCardTapAnimation()
    }
    
    @objc
    private func throwTapped() {
        guard !stackContainer.subviews.isEmpty else { return }
        
        stackContainer.removeCardTapAnimation(isLeft: false)
    }
    
    @objc
    private func filterTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let latest = UIAlertAction(title: "최신순", style: .default) { [weak self] _ in
            guard let self else { return }
            
            UserDefaults.standard.set("LATEST", forKey: self.viewModel.orderTypeForKey)
            self.filterView.titleLabel.text = "최신순"
            self.viewModel.input.requestPosts.send(nil)
        }
        
        let popular = UIAlertAction(title: "인기순", style: .default) { [weak self] _ in
            guard let self else { return }
            
            UserDefaults.standard.set("POPULARITY", forKey: self.viewModel.orderTypeForKey)
            self.filterView.titleLabel.text = "인기순"
            self.viewModel.input.requestPosts.send(nil)
        }
        
        alert.addAction(latest)
        alert.addAction(popular)
        
        present(alert, animated: true)
    }
}

//MARK: - 카드 DataSources & Delegate
extension PostsVC: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return viewModel.posts.count
    }

    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModel.posts[index]
        return card
    }

    func emptyView() -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor(colorSet: 238)
        
        let imageView = UIImageView()
        imageView.image = Images.Trade.empty.image
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(49)
            $0.width.equalTo(166)
            $0.height.equalTo(161)
        }
        
        return view
    }   
}

extension PostsVC: SwipeCardsDelegate {
    func swipeDidSelect(view: SwipeCardView, at index: Int) {
        let detailVC = DetailPostVC(id: viewModel.posts[index].id ?? 0)
        detailVC.delegate = self
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        return flowLayout
    }
}

extension PostsVC {
    typealias CategoriesSnapShot = NSDiffableDataSourceSnapshot<PostsVC.Section, String>
    typealias CategoriesDataSource = UICollectionViewDiffableDataSource<PostsVC.Section, String>
    
    enum Section {
        case category
    }
    
    private func configureDataSource() {
        dataSource = CategoriesDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, category in
            guard let self else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(withType: CategoryCollectionViewCell.self, indexPath: indexPath)
            
            cell.configure(name: category,
                           isSelected: self.viewModel.selectedCategoryItem.contains(indexPath.row))
            
            return cell
        }
    }
    
    private func updateDataSnapshot(with categories: [String]) {
        snapshot = CategoriesSnapShot()
        snapshot.appendSections([.category])
        snapshot.appendItems(categories)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createLayout(with categories: [String]) -> UICollectionViewLayout {
        var items = [NSCollectionLayoutItem]()
        
        categories.forEach {
            let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(CategoryCollectionViewCell.width(text: $0)),
                                                  heightDimension: .absolute(34.0))
            items.append(NSCollectionLayoutItem(layoutSize: itemSize))
        }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(34.0))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: items)
        group.interItemSpacing = .fixed(8.0)
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = NSDirectionalEdgeInsets(top: .zero, leading: 16.0, bottom: .zero, trailing: 100.0)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

extension PostsVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            viewModel.selectedCategoryItem = Set<Int>([0])
        } else {
            if viewModel.selectedCategoryItem.contains(0) {
                viewModel.selectedCategoryItem.remove(0)
            }
            viewModel.selectedCategoryItem.insert(indexPath.row)
        }
        
        viewModel.input.requestPosts.send(nil)
        collectionView.reloadData()
    }
}

extension PostsVC: DetailSelectionDelegate {
    func keep() {
        stackContainer.removeCardTapAnimation()
    }
    
    func drop() {
        stackContainer.removeCardTapAnimation(isLeft: false)
    }
    
    func skip() {
        stackContainer.skipCardTapAnimation()
    }
}

extension PostsVC: StackContainerViewDelegate {
    func keepOrDrop(isKeep: Bool?) {
        guard let isKeep else { return }
        
        let result = isKeep ? "KEEP" : "DROP"
        viewModel.input.requestPostVote.send(result)
    }
}
