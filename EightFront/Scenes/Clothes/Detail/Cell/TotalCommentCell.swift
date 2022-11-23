//
//  TotalCommentCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/13.
//

import Then
import SnapKit
import UIKit
//MARK: 댓글 개수 셀
final class TotalCommentCell: DetailPostCell {
    //MARK: - Properties
    private let topLineView = UIView().then {
        $0.backgroundColor = UIColor(colorSet: 245)
    }
    private let titleLabel = UILabel().then {
        $0.text = "댓글"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
        $0.textColor = UIColor(colorSet: 117)
    }
    private let countLabel = UILabel().then {
        $0.text = "0"
        $0.font = Fonts.Pretendard.semiBold.font(size: 16)
        $0.textColor = UIColor(colorSet: 117)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with count: Int?) {
        countLabel.text = "\(count ?? 0)"
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(topLineView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(countLabel)
        
        topLineView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(16)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom).offset(16)
            $0.left.equalToSuperview().offset(16)
            $0.width.equalTo(28)
            $0.height.equalTo(26)
        }
        countLabel.snp.makeConstraints {
            $0.top.equalTo(topLineView.snp.bottom).offset(16)
            $0.left.equalTo(titleLabel.snp.right).offset(4)
            $0.height.equalTo(26)
        }
    }
}

//MARK: - 사이즈 관련
extension TotalCommentCell {
    static var height: CGFloat = 83.0
}
