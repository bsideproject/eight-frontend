//
//  HomeAddressView.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
//MARK: HomeAddressView
final class HomeAddressView: UIView {
    //MARK: - Properties
    let addressLabel = UILabel().then {
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = Fonts.Pretendard.medium.font(size: 14)
    }
    let detailImageView = UIImageView().then {
        $0.image = Images.Home.detail.image
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not Created View")
    }
    
    //MARK: - Make UI
    func makeUI() {
        addSubview(addressLabel)
        addSubview(detailImageView)
        
        addressLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-8)
        }
        detailImageView.snp.makeConstraints {
            $0.left.equalTo(addressLabel.snp.right).offset(4)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(12)
            $0.height.equalTo(6)
        }
    }
}
