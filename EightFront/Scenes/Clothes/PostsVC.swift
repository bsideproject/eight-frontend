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
    
    private var viewModel = PostsViewModel()
    private let stackContainer = StackContainerView()
    var snapshot: CategoriesSnapShot!
    var dataSource: CategoriesDataSource!
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout()).then {
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
    private let filterView = FilterView().then {
        $0.titleLabel.text = "최신순"
    }
    private let choiceLabel = UILabel().then {
        $0.text = "나였다면?"
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.semiBold.font(size: 18)
    }
    private let storageButton = ChoiceView(isLeftImage: true).then {
        $0.titleLabel.text = "보관해요"
        let image = Images.Trade.leftArrow.image.withRenderingMode(.alwaysTemplate)
        $0.imageView.image = image
        $0.imageView.tintColor = Colors.gray001.color
        $0.backgroundColor = Colors.point.color
    }
    private let throwButton = ChoiceView(isLeftImage: false).then {
        $0.titleLabel.text = "버릴래요"
        $0.titleLabel.textColor = Colors.point.color
        let image = Images.Trade.rightArrow.image.withRenderingMode(.alwaysTemplate)
        $0.imageView.image = image
        $0.imageView.tintColor = Colors.point.color
        $0.backgroundColor = Colors.gray001.color
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
        
        let cardWidth = UIScreen.main.bounds.width - 32
        let cardHeight = cardWidth * 0.75
        
        stackContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-30)
            $0.width.equalTo(cardWidth)
            $0.height.equalTo(cardHeight)
        }
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-44)
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
        
        configureDataSource()
    }
    
    //MARK: - Binding..
    private func bind() {
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
            .sink { [weak self] categories in
                guard let self, !categories.isEmpty else { return }
                
                self.collectionView.collectionViewLayout = self.createLayout(with: categories)
                self.updateDataSnapshot(with: categories)
                self.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .left)
            }
            .store(in: &viewModel.bag)
        
        viewModel.input.requestCategroies.send(nil)
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
        stackContainer.removeCardTapAnimation()
    }
    
    @objc
    private func throwTapped() {
        stackContainer.removeCardTapAnimation(isLeft: false)
    }
    
    @objc
    private func filterTapped() {
        
    }
}

//MARK: - 카드 DataSources & Delegate
extension PostsVC: SwipeCardsDataSource {
    func numberOfCardsToShow() -> Int {
        return viewModel.dummyData.count
    }

    func card(at index: Int) -> SwipeCardView {
        let card = SwipeCardView()
        card.dataSource = viewModel.dummyData[index]
        return card
    }

    func emptyView() -> UIView? {
        return nil
    }   
}

extension PostsVC: SwipeCardsDelegate {
    func swipeDidSelect(view: SwipeCardView, at index: Int) {
        let detailVC = DetailPostVC(id: 1)
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
        dataSource = CategoriesDataSource(collectionView: collectionView) { collectionView, indexPath, category in
            let cell = collectionView.dequeueReusableCell(withType: CategoryCollectionViewCell.self, indexPath: indexPath)
            
            cell.configure(name: category)
            
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
