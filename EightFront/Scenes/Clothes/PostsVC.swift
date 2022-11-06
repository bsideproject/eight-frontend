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
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        CategoryCollectionViewCell.register($0)
    }
    private let navigationView = CommonNavigationView().then {
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
        
        navigationController?.navigationBar.isHidden = true
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
    }
    
    private func configure() {
        stackContainer.delegate = self
        stackContainer.dataSource = self
        
        if !viewModel.dummyCategories.isEmpty {
            collectionView.selectItem(at: IndexPath(item: 0, section: 0),
                                      animated: false,
                                      scrollPosition: .left)
        }
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
        let detailVC = DetailPostVC()
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension PostsVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = 8.0
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        return flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: .zero, left: 16.0, bottom: .zero, right: 100.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CategoryCollectionViewCell.width(text: viewModel.dummyCategories[indexPath.item].name),
                      height: 34.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.dummyCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: CategoryCollectionViewCell.self, indexPath: indexPath)
        
        cell.configure(name: viewModel.dummyCategories[indexPath.item].name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}
