//
//  PhotoCollectionViewCell.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import UIKit

//MARK: - PhotoCell Delegate
protocol PhotoCellDelegate: AnyObject {
    func removeItemButtonTapped(at index: Int)
}
//MARK: 사진 cell
final class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    var delegate: PhotoCellDelegate?
    // Photo ImageView
    let photoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 4.0
    }
    // Photo remove button
//    let removePhotoButton = UIButton().then {
//        $0.contentMode = .scaleAspectFit
//        $0.setImage(images: (normal: Asset.Images.iconDelete.image, highlighted: Asset.Images.iconDelete.image))
//        $0.applyRoundedCornersWithHeight(11.5)
//        $0.addTarget(self, action: #selector(removePhotoCellDidTapped(sender:)), for: .touchUpInside)
//    }
    
    //MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureUI()
    }
    
    //MARK: Configure UI
    private func configureUI() {
        contentView.layer.cornerRadius = 4.0
        contentView.backgroundColor = .white
               
        contentView.addSubview(photoImageView)
//        contentView.addSubview(removePhotoButton)
        
        photoImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
//        removePhotoButton.snp.makeConstraints {
//            $0.top.right.equalToSuperview().inset(5)
//            $0.width.height.equalTo(35)
//        }
    }
    
    override func prepareForReuse() {
        photoImageView.image = nil
    }
    
    //MARK: Fetch Data
    func fetchData(_ image: UIImage?) {
        photoImageView.image = image
    }
    
    // 사진 삭제 handler
    @objc
    func removePhotoCellDidTapped(sender: UIButton) {
        delegate?.removeItemButtonTapped(at: tag)
    }
}
