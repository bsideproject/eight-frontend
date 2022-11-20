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
    
    let title = UILabel()
    let iconView = UIView().then {
        $0.layer.cornerRadius = 6
    }
    
    let icon = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .white
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
        icon.image = UIImage(systemName: myPageMenus.image)
        iconView.backgroundColor = UIColor(cgColor: myPageMenus.backgroundColor)
    }
    
    // MARK: - makeUI
    private func makeUI() {
        
        addSubview(iconView)
        addSubview(title)
        
        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(29)
            
            iconView.addSubview(icon)
            icon.snp.makeConstraints {
                $0.size.equalTo(23)
                $0.center.equalToSuperview()
            }
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
}
