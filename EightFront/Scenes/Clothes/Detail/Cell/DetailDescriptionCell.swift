//
//  DetailDescriptionCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/18.
//

import Then
import SnapKit
import UIKit
//MARK: 옷에 대한 설명 셀
final class DetailDescriptionCell: DetailPostCell {
    //MARK: - Properties
    let titleLabel = UILabel().then {
        $0.font = Fonts.Pretendard.semiBold.font(size: 20)
    }
    let descLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.font = Fonts.Templates.subheader.font
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withTitle title: String?, desc: String?) {
        titleLabel.text = title
        descLabel.text = desc
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.right.equalToSuperview().inset(16)
        }
    }
}

extension DetailDescriptionCell {
    static func height(with desc: String?) -> CGFloat {
        guard let desc else { return .zero }
        
        return 53.0 + UILabel.textHeight(withWidth: UIScreen.main.bounds.width - 32.0,
                                         font: Fonts.Templates.subheader.font,
                                         text: desc)
    }
}
