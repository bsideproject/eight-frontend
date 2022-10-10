//
//  NaverMapMarker.swift
//  EightFront
//
//  Created by wargi on 2022/10/03.
//

import NMapsMap
//MARK: Naver Map Marker View
final class NaverMapMarker: NMFMarker {
    //MARK: - Properties
    var isSelected: Bool = false { didSet { updatedLayout() } }
    private var markerView = CustomAnnotationView(frame: CGRect(x: 0, y: 0, width: 24, height: 30))
        
    init(type: CustomAnnotationView.MarkerType) {
        self.markerView.type = type
        
        super.init()
        
        self.updatedLayout()
    }
    
    //MARK: - Set UI
    private func updatedLayout() {
        markerView.mapMarkerImageView.image = isSelected ? markerView.fetchMarkerImage(type: .selected) : markerView.fetchMarkerImage(type: markerView.type)
        iconImage = NMFOverlayImage(image: markerView.asImage())
    }
}

//MARK: 지도에서 실질적으로 표시 되는 뷰
final class CustomAnnotationView: UIView {
    enum MarkerType {
        case selected
        case none
    }
    // MARK: - Properties
    var type: MarkerType = .none
    var boxInfo: CollectionBox? // 수거함 정보
    var isSelected: Bool = false {
        didSet {
            mapMarkerImageView.image = isSelected ? fetchMarkerImage(type: .selected) : fetchMarkerImage(type: type)
        }
    }
    var mapMarkerImageView = UIImageView().then {
        $0.frame = CGRect(x: 0, y: 0, width: 26, height: 32)
        $0.layer.masksToBounds = true
        $0.image = Images.Map.markerNone.image
    }
    
    //MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set UI
    private func makeUI() {
        addSubview(mapMarkerImageView)
    }
    
    fileprivate func fetchMarkerImage(type: MarkerType) -> UIImage {
        switch type {
        case .selected:
            return Images.Map.markerSelect.image
        case .none:
            return Images.Map.markerNone.image
        }
    }
}
