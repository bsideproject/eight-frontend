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
        $0.text = "의류수거함 찾기"
        $0.textColor = .white
        $0.textAlignment = .center
        $0.font = Fonts.Templates.subheader2.font
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
    private func makeUI() {
        addSubview(addressLabel)
        
        addressLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
