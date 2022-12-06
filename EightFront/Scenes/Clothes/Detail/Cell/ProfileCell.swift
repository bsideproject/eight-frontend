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
    let profileBackgroundView = UIView().then {
        $0.backgroundColor = Colors.gray007.color
        $0.layer.cornerRadius = 17
    }
    let profileImageView = UIImageView().then {
        $0.image = Images.dropIcon.image
        $0.contentMode = .scaleToFill
        $0.backgroundColor = Colors.gray007.color
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
    let moreImageView = UIImageView().then {
        $0.image = Images.Detail.more.image
    }
    let moreButton = UIButton()
    
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
        
        contentView.addSubview(profileBackgroundView)
        profileBackgroundView.addSubview(profileImageView)
        
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(moreImageView)
        contentView.addSubview(moreButton)
        
        profileBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(14)
            $0.left.equalToSuperview().offset(10)
            $0.size.equalTo(34)
        }
        profileImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(16)
            $0.height.equalTo(19.428571)
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
        moreImageView.snp.makeConstraints {
            $0.center.equalTo(moreButton)
            $0.size.equalTo(24)
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

