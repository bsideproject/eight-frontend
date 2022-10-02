//
//  SearchView.swift
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
    let searchImageView = UIImageView().then {
        $0.image = Images.homeSearch.image
    }
    let placeholderLabel = UILabel().then {
        $0.text = "수거함 위치를 검색해보세요."
        $0.textColor = Colors.gray006.color
        $0.font = Fonts.Pretendard.regular.font(size: 12)
    }
    let listButton = UIButton().then {
        $0.setImage(Images.homeSearch.image, for: .normal)
        $0.setImage(Images.homeSearch.image, for: .highlighted)
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
        backgroundColor = .white
        
        addSubview(searchImageView)
        addSubview(placeholderLabel)
        addSubview(listButton)
        
        searchImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.size.equalTo(20)
        }
        placeholderLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(searchImageView.snp.leading).offset(7)
        }
        listButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-11)
            $0.size.equalTo(20)
        }
    }
}
