//
//  MyClothesTableViewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/24.
//

import UIKit

final class MyClothesTableViewCell: UITableViewCell {
    
    static let identifier = "MyClothesTableViewCell"
    
    private let titleLabel = UILabel().then {
        $0.text = "파타고니아 후리스"
        $0.font = Fonts.Templates.subheader3.font
        $0.textColor = Colors.gray001.color
    }
    
    private let contentLabel = UILabel().then {
        $0.text = "산지 5년정도 된 옷이라 고민중 이에요 ㅠ"
        $0.font = Fonts.Templates.body1.font
        $0.textColor = Colors.gray005.color
    }
    
    private let rightArrow = UIImageView().then {
        let image = Images.Trade.rightArrow.image
        $0.image = image
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func makeUI() {
        addSubview(rightArrow)
        rightArrow.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.height.equalTo(12)
            $0.width.equalTo(6)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(16)
            $0.left.equalToSuperview().inset(16)
        }
            
        addSubview(contentLabel)
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalTo(rightArrow.snp.left).offset(16)
        }
    }
    
    private func bind() {
        
    }
    
    func configure(myCloth: MyCloth) {
        self.titleLabel.text = myCloth.title
        self.contentLabel.text = myCloth.content
    }
    
}
