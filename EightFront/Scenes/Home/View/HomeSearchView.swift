//
//  HomeSearchView.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Foundation
import Then
import SnapKit
import UIKit
//MARK: SearchView
final class HomeSearchView: UIView {
    //MARK: - Properties
    private let searchImageView = UIImageView().then {
        $0.image = Images.Home.search.image
    }
    private let placeholderLabel = UILabel().then {
        $0.text = "수거함 위치를 검색해보세요."
        $0.textColor = Colors.gray006.color
        $0.font = Fonts.Templates.caption1.font
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
        backgroundColor = .white
        
        addSubview(searchImageView)
        addSubview(placeholderLabel)
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(20)
        }
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(searchImageView.snp.right).offset(7)
        }
    }
}
