//
//  DetailPostVC.swift
//  EightFront
//
//  Created by wargi on 2022/11/06.
//

import Then
import SnapKit
import UIKit
import Combine

protocol ReportPopupOpenDelegate: AnyObject {
    func openPopup()
}

//MARK: 게시물 상세보기 VC
final class DetailPostVC: UIViewController {
    //MARK: - Properties
    weak var delegate: DetailSelectionDelegate?
    var viewModel: DetailPostViewModel!
    var keyboardHeight: CGFloat = .zero
    private let navigationView = CommonNavigationView().then {
        $0.titleLabel.text = "버릴까 말까"
    }
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        $0.separatorStyle = .none
        $0.keyboardDismissMode = .onDrag
        ProfileCell.register($0)
        CollectionCell.register($0)
        DetailDescriptionCell.register($0)
        DetailCountCell.register($0)
        TotalCommentCell.register($0)
        DetailSelectionCell.register($0)
        CommentsCell.register($0)
    }
    let commentInputView = CommentInputView()
    let backgroundView = UIView().then {
        $0.isHidden = true
        $0.alpha = .zero
        $0.backgroundColor = .black
    }
    lazy var reportPopupView = ReportPopupView().then {
        $0.delegate = self
        $0.isHidden = true
        $0.backgroundColor = .white
    }
    lazy var cutOffView = CutOffPopupView().then {
        $0.alpha = .zero
        $0.isHidden = true
        $0.delegate = self
        $0.backgroundColor = .white
    }
    
    //MARK: - Life Cycle
    init(id: Int?) {
        super.init(nibName: nil, bundle: nil)
        
        self.viewModel = DetailPostViewModel(id: id)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bind()
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        tabBarController?.tabBar.isHidden = true
    }
    
    func configure() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - Make UI
    private func makeUI() {
        view.backgroundColor = .white
        
        view.addSubview(navigationView)
        view.addSubview(tableView)
        view.addSubview(commentInputView)
        view.addSubview(backgroundView)
        view.addSubview(reportPopupView)
        view.addSubview(cutOffView)
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(47)
        }
        commentInputView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(59)
        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(commentInputView.snp.top)
        }
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        reportPopupView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(300)
        }
        cutOffView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(317)
            $0.height.equalTo(236)
        }
    }
    
    //MARK: - Binding..
    private func bind() {
        navigationView.backButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &viewModel.bag)
        
        viewModel
            .output
            .requestComments
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                let lineCell = IndexPath(item: 5, section: 0)
                let commentsCell = IndexPath(item: 6, section: 0)
                self?.tableView.reloadRows(at: [lineCell, commentsCell], with: .none)
                
                guard self?.viewModel.isRequestComment ?? false else { return }
                self?.viewModel.isRequestComment = false
                let point = CGPoint(x: 0.0, y: .greatestFiniteMagnitude)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self?.tableView.setContentOffset(point, animated: false)
                }
            }
            .store(in: &viewModel.bag)
        
        Publishers
            .CombineLatest(viewModel.output.requestPost, viewModel.output.requestComments)
            .receive(on: DispatchQueue.main)
            .compactMap { $0 && $1 }
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &viewModel.bag)
        
        backgroundView
            .gesture()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.endPopup()
            }
            .store(in: &viewModel.bag)
        
        commentInputView
            .inputTextField
            .textPublisher
            .compactMap { $0 }
            .map { $0.count != 0 }
            .sink { [weak self] isEnable in
                let disableColor = UIColor(red: 0.712, green: 0.702, blue: 0.701, alpha: 1)
                let enableColor = UIColor(red: 0.075, green: 0.075, blue: 0.075, alpha: 1)
                
                self?.commentInputView.sumitButton.isEnabled = isEnable
                self?.commentInputView.sumitButton.setTitleColor(isEnable ? enableColor : disableColor)
            }
            .store(in: &viewModel.bag)
        
        commentInputView
            .sumitButton
            .tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.viewModel.isRequestComment = true
                self?.viewModel.input.requestComment.send(self?.commentInputView.inputTextField.text)
                self?.commentInputView.inputTextField.text = nil
                self?.commentInputView.inputTextField.resignFirstResponder()
            }
            .store(in: &viewModel.bag)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let animator = UIViewPropertyAnimator(duration: 0.3, curve: .easeInOut)
            
            animator.addAnimations { [weak self] in
                guard let self else { return }
                self.keyboardHeight = keyboardFrame.height
                self.tableView.contentOffset.y = self.tableView.contentOffset.y + keyboardFrame.height
                
                self.commentInputView.snp.remakeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(-self.keyboardHeight)
                    $0.height.equalTo(59)
                }
            }
            
            animator.startAnimation()
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        commentInputView.snp.remakeConstraints {
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(59)
        }
    }
    
}

extension DetailPostVC: UITableViewDataSource, UITableViewDelegate {
    enum CellType: Int, CaseIterable {
        case profile = 0
        case images
        case description
        case count
        case selection
        case line
        case comment
        case none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellType = CellType(rawValue: indexPath.row) ?? .none
        
        switch cellType {
        case .profile:
            return ProfileCell.height
        case .images:
            return CollectionCell.height
        case .description:
            return DetailDescriptionCell.height(with: viewModel.info?.description)
        case .count:
            return DetailCountCell.height
        case .selection:
            return DetailSelectionCell.height
        case .line:
            return TotalCommentCell.height
        case .comment:
            return CommentsCell.height(with: viewModel.comments)
        case .none:
            return 26.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let post = viewModel.info else { return UITableViewCell() }
        
        let cellType = CellType(rawValue: indexPath.row) ?? .none
        
        switch cellType {
        case .profile:
            let cell = tableView.dequeueReusableCell(withType: ProfileCell.self, for: indexPath)
            
            cell.delegate = self
            cell.configure(withName: post.nickname, dateString: post.createdAt)
            
            return cell
        case .images:
            let cell = tableView.dequeueReusableCell(withType: CollectionCell.self, for: indexPath)
            
            cell.configure(with: post.images)
            
            return cell
        case .description:
            let cell = tableView.dequeueReusableCell(withType: DetailDescriptionCell.self, for: indexPath)
            
            cell.configure(withTitle: post.title, desc: post.description)
            
            return cell
        case .count:
            let cell = tableView.dequeueReusableCell(withType: DetailCountCell.self, for: indexPath)
            
            cell.configure(withLockCount: post.keepCount, throwCount: post.dropCount)
            
            return cell
        case .selection:
            let cell = tableView.dequeueReusableCell(withType: DetailSelectionCell.self, for: indexPath)
            
            cell.delegate = self
            
            return cell
        case .line:
            let cell = tableView.dequeueReusableCell(withType: TotalCommentCell.self, for: indexPath)
            
            cell.configure(with: viewModel.comments?.count ?? 0)
            
            return cell
        case .comment:
            let cell = tableView.dequeueReusableCell(withType: CommentsCell.self, for: indexPath)
            
            cell.delegate = self
            cell.configure(with: viewModel.comments)
            
            return cell
        case .none:
            return UITableViewCell()
        }
    }
}

//MARK: - 옵션 선택(신고/차단)
extension DetailPostVC: ReportPopupOpenDelegate, ReportPopupViewDelegate {
    func openPopup() {
        backgroundView.isHidden = false
        reportPopupView.isHidden = false
        
        let animator = UIViewPropertyAnimator(duration: 0.22, curve: .easeInOut)
        animator.addAnimations { [weak self] in
            guard let self else { return }
            
            self.backgroundView.alpha = 0.65
            self.reportPopupView.snp.updateConstraints {
                $0.top.equalTo(self.view.snp.bottom).offset(-182)
            }
        }
        
        animator.startAnimation()
    }
    
    func endPopup() {
        cutOffView.isHidden = true
        backgroundView.isHidden = true
        reportPopupView.isHidden = true
        
        self.cutOffView.alpha = .zero
        self.backgroundView.alpha = .zero
        
        self.reportPopupView.snp.updateConstraints {
            $0.top.equalTo(self.view.snp.bottom)
        }
    }
    
    func cancelButtonTapped() {
        endPopup()
    }
    
    func moveReport() {
        endPopup()
        
        let reportPostVC = ReportPostVC(type: .report)
        navigationController?.pushViewController(reportPostVC, animated: true)
    }
    
    func moveCutoff() {
        cutOffView.isHidden = false
        reportPopupView.isHidden = true
        
        self.reportPopupView.snp.updateConstraints {
            $0.top.equalTo(self.view.snp.bottom)
        }
        
        let animator = UIViewPropertyAnimator(duration: 0.22, curve: .linear)
        animator.addAnimations { [weak self] in
            guard let self else { return }
            self.cutOffView.alpha = 1.0
        }
        
        animator.startAnimation()
    }
}

//MARK: - 차단 하기
extension DetailPostVC: CutOffPopupViewDelegate {
    func cancelTapped() {
        endPopup()
    }
    
    func cutoffTapped() {
        endPopup()
        
        navigationController?.popViewController(animated: true)
    }
}

extension DetailPostVC: DetailSelectionDelegate {
    func keep() {
        navigationController?.popViewController(animated: true)
        delegate?.keep()
    }
    
    func drop() {
        navigationController?.popViewController(animated: true)
        delegate?.drop()
    }
    
    func skip() {
        navigationController?.popViewController(animated: true)
        delegate?.skip()
    }
}
