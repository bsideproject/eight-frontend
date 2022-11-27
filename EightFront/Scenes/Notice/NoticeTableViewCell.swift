//
//  NoticeTableViewCell.swift
//  EightFront
//
//  Created by Jeongwan Kim on 2022/11/27.
//

import UIKit

class NoticeTableViewCell: UITableViewCell {
    
    static let identifier = "NoticeTableViewCell"
    
    // 디자인 안나옴
    private let titleLabel = UILabel().then {
        $0.font = Fonts.Templates.body1.font
    }
    
    // 디자인 안나옴
    private let descriptionLabel = UILabel().then {
        $0.font = Fonts.Templates.body2.font
        $0.textColor = Colors.gray006.color
    }
    
    private let rightArraw = UIImageView().then {
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
    
    func configure(notice: NoticeModel) {
        self.descriptionLabel.text = notice.description
        self.titleLabel.text = notice.title
    }
    
    func makeUI(){
        addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(11)
            $0.left.equalToSuperview()
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(6)
            $0.left.equalToSuperview()
        }
        
        addSubview(rightArraw)
        rightArraw.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().inset(15)
            $0.width.equalTo(8)
            $0.height.equalTo(14)
        }
    }
}
