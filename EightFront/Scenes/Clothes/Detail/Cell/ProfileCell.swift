//
//  ProfileCell.swift
//  EightFront
//
//  Created by wargi on 2022/11/13.
//

import Then
import SnapKit
import UIKit

protocol DetailPostProtocol {}
typealias DetailPostCell = UITableViewCell & DetailPostProtocol

//MARK: 최상단 프로파일 셀
final class ProfileCell: DetailPostCell {
    //MARK: - Properties
    weak var delegate: ReportPopupOpenDelegate?
    let profileImageView = UIImageView().then {
        $0.image = Images.Detail.defaultProfile.image
    }
    let nicknameLabel = UILabel().then {
        $0.font = Fonts.Pretendard.semiBold.font(size: 14)
        $0.textAlignment = .left
    }
    let dateLabel = UILabel().then {
        $0.font = Fonts.Pretendard.regular.font(size: 14)
        $0.textColor = UIColor(colorSet: 117)
        $0.textAlignment = .left
    }
    let moreButton = UIButton().then {
        $0.setImage(Images.Detail.more.image, for: .normal)
        $0.setImage(Images.Detail.more.image, for: .highlighted)
    }
    
    //MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeUI()
        
        moreButton.addTarget(self, action: #selector(moreButtonTouched), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Make UI
    private func makeUI() {
        selectionStyle = .none
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moreButton)
        
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(46)
        }
        nicknameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.left.equalTo(profileImageView.snp.right)
            $0.height.equalTo(22)
        }
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom)
            $0.left.equalTo(profileImageView.snp.right)
            $0.height.equalTo(18)
        }
        moreButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.right.equalToSuperview()
            $0.width.equalTo(56)
        }
    }
    
    func configure(withName name: String?, dateString: String?) {
        guard let name else { return }
        
        nicknameLabel.text = name
        dateLabel.text = DateManager.shared.timeString(target: dateString)
    }
    
    @objc
    private func moreButtonTouched() {
        delegate?.openPopup()
    }
}

//MARK: - Size 관련
extension ProfileCell {
    static var height: CGFloat = 72.0
}

