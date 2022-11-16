//
//  ReportVC.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import Then
import SnapKit
import UIKit
import Combine
import CoreLocation
//MARK: HomeListVC
final class ReportVC: UIViewController {
    //MARK: - Properties
    private let viewModel = ReportViewModel()
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "지도정보수정"
    }
    private let searchImageView = UIImageView().then {
        $0.image = Images.Report.search.image
    }
    private let addressView = CommonTextFieldView(titleWidth: 56.0,
                                                  contentTrailing: 52.0).then {
        $0.titleLabel.text = "주소"
        $0.contentTextField.isUserInteractionEnabled = false
    }
    private let detailView = CommonTextFieldView(titleWidth: 56.0).then {
        $0.titleLabel.text = "상세주소"
    }
    private let questionLabel = UILabel().then {
        $0.text = "요청 내용"
        $0.font = Fonts.Templates.subheader3.font
    }
    private let questionView = CommonTextFieldView(isTitleHidden: true,
                                                   isTextView: true,
                                                   placeholder: "추가 요청사항 혹은 문의사항을 남겨주세요.").then {
        $0.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }
    private let photoLabel = UILabel().then {
        $0.text = "사진 첨부"
        $0.font = Fonts.Templates.subheader3.font
    }
    lazy var addPhotoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: setupFlowLayout()).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.alwaysBounceHorizontal = false
        $0.allowsMultipleSelection = false
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        AddPhotoCollectionViewCell.register($0)
        PhotoCollectionViewCell.register($0)
    }
    private let agreePhotoView = AgreePhotoView()
    private let requestButton = UIButton().then {
        $0.setTitle("등록하기")
        $0.setTitleColor(.white)
        $0.titleLabel?.font = Fonts.Templates.subheader.font
        $0.backgroundColor = Colors.gray006.color
        $0.layer.cornerRadius = 4
    }
    private let deleteButton = UIButton().then {
        $0.setTitle("수거함 삭제요청")
        $0.setTitleColor(Colors.gray005.color)
        $0.titleLabel?.font = Fonts.Templates.caption1.font
        $0.layer.cornerRadius = 4
    }
    private let bottomLineView = UIView().then {
        $0.backgroundColor = Colors.gray006.color
    }
    
    //MARK: - Life Cycle
    init(type: ReportViewModel.ReportType, box: CollectionBox? = nil) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel.type = type
        configure(with: box)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Make UI
    private func makeUI() {
        let isNew = viewModel.type == .new
        
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(addressView)
        view.addSubview(searchImageView)
        view.addSubview(detailView)
        view.addSubview(questionLabel)
        view.addSubview(questionView)
        view.addSubview(photoLabel)
        view.addSubview(addPhotoCollectionView)
        view.addSubview(agreePhotoView)
        view.addSubview(requestButton)
        view.addSubview(deleteButton)
        view.addSubview(bottomLineView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        addressView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(addressView.snp.centerY)
            $0.right.equalTo(addressView.snp.right).offset(-16)
            $0.size.equalTo(20)
        }
        detailView.snp.makeConstraints {
            $0.top.equalTo(addressView.snp.bottom).offset(8)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(50)
        }
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(detailView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        questionView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
        }
        photoLabel.snp.makeConstraints {
            $0.top.equalTo(questionView.snp.bottom).offset(16)
            $0.left.right.equalToSuperview().inset(16)
            $0.height.equalTo(26)
        }
        addPhotoCollectionView.snp.makeConstraints {
            $0.top.equalTo(photoLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview()
            $0.height.equalTo(88)
        }
        requestButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(isNew ? -24 : -38)
            $0.height.equalTo(58)
        }
        agreePhotoView.snp.makeConstraints {
            $0.top.equalTo(addPhotoCollectionView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(requestButton.snp.top).offset(-16)
            $0.height.equalTo(39)
        }
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(requestButton.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(38)
        }
        bottomLineView.snp.makeConstraints {
            $0.top.equalTo(requestButton.snp.bottom).offset(28)
            $0.left.right.equalTo(deleteButton)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        deleteButton.isHidden = isNew
        bottomLineView.isHidden = isNew
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        view.endEditing(true)
    }
    
    func configure(with box: CollectionBox?) {
        guard let box, let lat = box.latitude, let lng = box.longitude else { return }
        
        viewModel.requestLocation = CLLocation(latitude: lat, longitude: lng)
    }
    
    //MARK: - Rx Binding..
    private func bind() {
        addressView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.addressTapped()
            }
            .store(in: &viewModel.bag)
        
        viewModel.$addressString
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .assign(to: \.text, on: addressView.contentTextField)
            .store(in: &viewModel.bag)
        
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .isRequest
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.requestButton.setTitleColor($0 ? Colors.point.color : .white)
                self?.requestButton.backgroundColor = $0 ? Colors.gray002.color : Colors.gray006.color
                self?.requestButton.isUserInteractionEnabled = $0
            }
            .store(in: &viewModel.bag)
        
        requestButton
            .tapPublisher
            .sink { [weak self] in
                guard let self else { return }
                let report = ReportRequest(memberId: "", // TODO: 추후에 로그인 완성후에 추가
                                           address: self.addressView.contentTextField.text ?? "",
                                           detailedAddress: self.detailView.contentTextField.text ?? "",
                                           latitude: self.viewModel.box?.latitude ?? .zero,
                                           longitude: self.viewModel.box?.longitude ?? .zero,
                                           comment: self.questionView.contentTextView.text ?? "")
                
                self.viewModel.input.updateReport.send(report)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .updatedImages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.addPhotoCollectionView.reloadData()
            }
            .store(in: &viewModel.bag)
        
        detailView
            .contentTextField
            .textPublisher
            .compactMap { $0 }
            .map { !$0.isEmpty }
            .sink { [weak self] in
                self?.viewModel.input.isDetailAddress.send($0)
            }
            .store(in: &viewModel.bag)
        
        agreePhotoView
            .gesture(.tap)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.agreePhotoView.isSelected.toggle()
                self?.viewModel.input.isAgreePhoto.send(self?.agreePhotoView.isSelected ?? false)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestReport
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isSuccessed in
                guard isSuccessed, let type = self?.viewModel.type else { return }
                
                let completedVC = ReportCompletedVC(type: type)
                self?.navigationController?.pushViewController(completedVC, animated: true)
            }
            .store(in: &viewModel.bag)
        
        deleteButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let deleteVC = DeleteBoxVC()
                deleteVC.delegate = self
                deleteVC.modalPresentationStyle = .overFullScreen
                self?.present(deleteVC, animated: false)
            }
            .store(in: &viewModel.bag)
    }
    
    // set collectionView flow layout
    private func setupFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 8
        flowLayout.minimumInteritemSpacing = .zero
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 88.0, height: 88.0)
        flowLayout.sectionInset = .zero
        return flowLayout
    }
    
    @objc
    private func addressTapped() {
        let searchMapVC = SearchMapVC(requestLocation: viewModel.requestLocation ?? LocationManager.shared.currentLocation)
        searchMapVC.delegate = self
        navigationController?.pushViewController(searchMapVC, animated: true)
    }
}

extension ReportVC: SearchMapDelegate {
    func fetch(location: CLLocation?) {
        viewModel.requestLocation = location
    }
}

//MARK: - UICollectionViewDataSource
extension ReportVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = viewModel.imageCount
        return count == 3 ? 3 : count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let count = viewModel.imageCount
        guard indexPath.item != count else {
            let addPhotoCell = collectionView.dequeueReusableCell(withType: AddPhotoCollectionViewCell.self, indexPath: indexPath)
            return addPhotoCell
        }
        
        let cell = collectionView.dequeueReusableCell(withType: PhotoCollectionViewCell.self, indexPath: indexPath)
        
        cell.tag = indexPath.item
        cell.delegate = self
        cell.fetchData(viewModel.image(at: indexPath.item))
        
        return cell
    }
    
}

//MARK: - UICollectionViewDelegate
extension ReportVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard viewModel.imageCount == indexPath.item else { return }
        
        ImagePickerManager.shared.pickImageWithAlert(self) { [weak self] image in
            self?.viewModel.add(image: image)
        }
    }
}

//MARK: - PhotoCellDelegate
extension ReportVC: PhotoCellDelegate {
    func removeItemButtonTapped(at index: Int) {
        viewModel.removeImage(at: index)
    }
}

extension ReportVC: DeleteBoxVCDelegate {
    func deleteTapped() {
        viewModel.input.deleteReport.send(nil)
    }
}
