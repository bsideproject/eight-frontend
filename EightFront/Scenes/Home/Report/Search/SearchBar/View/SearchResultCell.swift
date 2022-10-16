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
        $0.textColor = Colors.gray001.color
        $0.font = Fonts.Templates.body1.font
    }
    let addressTitleLabel = UILabel().then {
        $0.text = "주소"
        $0.textColor = Colors.gray001.color
        $0.textAlignment = .center
        $0.backgroundColor = Colors.gray008.color
        $0.font = Fonts.Templates.body1.font
    }
    let subTitleLabel = UILabel().then {
        $0.textColor = Colors.gray005.color
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
        contentView.addSubview(addressTitleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(lineView)
        
        titleLabel.snp.makeConstraints {
            $0.top.left.right.equalTo(16)
            $0.height.equalTo(22)
        }
        addressTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(29)
            $0.height.equalTo(26)
        }
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(addressTitleLabel.snp.right).offset(8)
            $0.centerY.equalTo(addressTitleLabel.snp.centerY)
        }
        lineView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
    }
}

