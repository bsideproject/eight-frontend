//
//  CollectionCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/13.
//

import Then
import UIKit
import SnapKit
import Kingfisher
//MARK: 옷 이미지 컬렉션 셀
final class CollectionCell: DetailPostCell {
    //MARK: - Properties
    var imageUrls = [String]()
    let currentPageLabel = UILabel().then {
        $0.clipsToBounds = true
        $0.textColor = UIColor(colorSet: 117)
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.medium.font(size: 12)
        $0.backgroundColor = .white.withAlphaComponent(0.6)
        $0.layer.cornerRadius = 10
    }
    lazy var pageIndicatorView = PageIndicatorView().then {
        $0.dataSources = self
    }
    lazy var collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.isPagingEnabled = true
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        PhotoCollectionViewCell.register($0)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with imageUrls: [String]?) {
        self.imageUrls = imageUrls ?? []
        
        currentPageLabel.text = "1/\(self.imageUrls.count)"
        collectionView.reloadData()
        pageIndicatorView.reloadData()
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(collectionView)
        contentView.addSubview(currentPageLabel)
        contentView.addSubview(pageIndicatorView)
        
        collectionView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-20)
        }
        currentPageLabel.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.top).offset(13)
            $0.right.equalTo(collectionView.snp.right).offset(-12)
            $0.width.equalTo(34)
            $0.height.equalTo(22)
        }
        pageIndicatorView.snp.makeConstraints {
            $0.top.equalTo(collectionView.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(8)
        }
    }
    
    // set collectionView flow layout
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: Self.height - 20)
        return flowLayout
    }
}

//MARK: - Size 관련
extension CollectionCell {
    static var height: CGFloat {
        let ratio = UIScreen.main.bounds.width / 375
        return ceil(334 * ratio + 20.0)
    }
}

extension CollectionCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withType: PhotoCollectionViewCell.self, indexPath: indexPath)
        
        cell.removePhotoButton.isHidden = true
        cell.removePhotoImageView.isHidden = true
        cell.configure(with: imageUrls[indexPath.item])
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(max(0, round(scrollView.contentOffset.x / scrollView.bounds.width)))
        
        guard currentPage < imageUrls.count else { return }
        
        pageIndicatorView.updatePage(at: currentPage)
        currentPageLabel.text = "\(currentPage + 1)/\(imageUrls.count)"
    }
}

extension CollectionCell: PageIndicatorViewDataSources {
    func numberOfItems() -> Int {
        return imageUrls.count
    }
}
