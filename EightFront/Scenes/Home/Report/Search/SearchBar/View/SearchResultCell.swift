//
//  SearchResultCell.swift
//  EightFront
//
//  Created by wargi on 2022/10/07.
//

import Then
import SnapKit
import UIKit
//MARK: SearchResultCell
final class SearchResultCell: UITableViewCell {
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.textColor = Colors.gray006.color
        $0.font = Fonts.Templates.subheader3.font
    }
    let subTitleLabel = UILabel().then {
        $0.textColor = Colors.gray005.color
        $0.font = Fonts.Templates.body1.font
    }
    let distanceLabel = UILabel().then {
        $0.textColor = Colors.gray001.color
        $0.textAlignment = .right
        $0.font = Fonts.Templates.body1.font
    }
    let lineView = UIView().then {
        $0.backgroundColor = Colors.gray007.color
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(distanceLabel)
        contentView.addSubview(lineView)
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        distanceLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.right.equalToSuperview().offset(-16)
        }
        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.left.equalToSuperview().inset(16)
            $0.right.equalTo(distanceLabel.snp.left).offset(4)
        }
        lineView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

