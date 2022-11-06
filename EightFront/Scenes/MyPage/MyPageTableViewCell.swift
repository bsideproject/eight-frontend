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
    let iconView = UIImageView().then {
        $0.layer.cornerRadius = 6
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
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
//    }
    
    func configure(myPageMenus: MyPageViewModel.MyPageMenus) {
        title.text = myPageMenus.title
        iconView.image = UIImage(systemName: myPageMenus.image)
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
        }
        
        title.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
}
