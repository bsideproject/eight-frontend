//
//  DetailCountCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/18.
//

import Then
import SnapKit
import UIKit
//MARK: 보관 및 버림 카운트 셀
final class DetailCountCell: DetailPostCell {
    //MARK: - Properties
    let lockTitleLabel = UILabel().then {
        $0.text = "보관해요"
        $0.textColor = UIColor(colorSet: 117)
        $0.font = Fonts.Templates.caption1.font
    }
    let lockCountLabel = UILabel().then {
        $0.font = Fonts.Templates.caption1.font
    }
    let throwTitleLabel = UILabel().then {
        $0.text = "버릴래요"
        $0.textColor = UIColor(colorSet: 117)
        $0.font = Fonts.Templates.caption1.font
    }
    let throwCountLabel = UILabel().then {
        $0.font = Fonts.Templates.caption1.font
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withLockCount lockCount: Int?, throwCount: Int?) {
        lockCountLabel.text = "\(lockCount ?? 0)"
        throwCountLabel.text = "\(throwCount ?? 0)"
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(lockTitleLabel)
        contentView.addSubview(lockCountLabel)
        contentView.addSubview(throwTitleLabel)
        contentView.addSubview(throwCountLabel)
        
        lockTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(23)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(42)
            $0.height.equalTo(26)
        }
        lockCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(lockTitleLabel.snp.centerY)
            $0.left.equalTo(lockTitleLabel.snp.right).offset(4)
            $0.height.equalTo(26)
        }
        throwTitleLabel.snp.makeConstraints {
            $0.centerY.equalTo(lockCountLabel.snp.centerY)
            $0.left.equalTo(lockCountLabel.snp.right).offset(8)
            $0.width.equalTo(42)
            $0.height.equalTo(26)
        }
        throwCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(lockTitleLabel.snp.centerY)
            $0.left.equalTo(throwTitleLabel.snp.right).offset(4)
            $0.height.equalTo(26)
        }
    }
}

extension DetailCountCell {
    static var height: CGFloat = 49.0
}
