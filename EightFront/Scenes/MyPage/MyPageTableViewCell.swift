//
//  MyPageTableViewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/05.
//

import UIKit

final class MyPageTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier = "MyPageTableViewCell"
    
    let title = UILabel().then {
        $0.font = Fonts.Templates.subheader.font
    }
    let iconView = UIView().then {
        $0.layer.cornerRadius = 6
    }
    
    let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
    }
    
    let rightArrow = UIImageView().then {
        $0.image = Images.Trade.rightArrow.image
    }
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(myPageMenus: MyPageViewModel.MyPageMenus) {
        title.text = myPageMenus.title
        icon.image = myPageMenus.image
    }
    
    // MARK: - makeUI
    private func makeUI() {
        addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(29)
            
            iconView.addSubview(icon)
            icon.snp.makeConstraints {
                $0.size.equalTo(24)
                $0.center.equalToSuperview()
            }
        }
        
        addSubview(title)
        title.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
        
        addSubview(rightArrow)
        rightArrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(25)
            $0.width.equalTo(11)
            $0.height.equalTo(16)
        }
    }
    
}
