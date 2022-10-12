//
//  AddPhotoCollectionViewCell.swift
//  EightFront
//
//  Created by wargi on 2022/10/10.
//

import UIKit
//MARK: Image 추가 cell
final class AddPhotoCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    // 사진추가 icon_camera => imageView
    let imageView = UIImageView().then {
        $0.image = Images.Report.addPhoto.image
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        makeUI()
    }
    
    //MARK: - Configure UI
    private func makeUI() {
        layer.cornerRadius = 4.0
        layer.borderWidth = 1.0
        layer.borderColor = Colors.gray006.color.cgColor
        
        contentView.backgroundColor = .white
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
}
