//
//  ViewController.swift
//  CovidWidget
//
//  Created by wickedRun on 2021/12/12.
//

import UIKit
import WidgetKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    enum Section: Int, CaseIterable {
        case DailyTotalInfo
        case WeeklyTotalInfo
        case DailyGubunInfo
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model: DailyCovidInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        
        update()
    }
    
    // MARK: Infomation Update
    func update() {
        WeeklyTotalInfoRequest().send { result in
            switch result {
            case .success(let dict):
                self.model = DailyCovidInfo(with: dict)
                DailyCovidInfo.dailyTotalInfo = self.model!.dailyTotal
                
                DispatchQueue.main.async {
                    if let kind = Bundle.main.bundleIdentifier {
                        WidgetCenter.shared.reloadTimelines(ofKind: kind)
                    }
                    self.updateView()
                }
                
            case .failure(let error):
                let errorMsg: String
                if let apiError = error as? APIError {
                    errorMsg = apiError.name
                } else {
                    errorMsg = error.localizedDescription
                }
                DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "데이터를 불러오지 못 했습니다.\n에러메시지: \(errorMsg)", message: nil, preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateView() {
        collectionView.reloadData()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Section.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        if section == Section.DailyGubunInfo.rawValue {
            return model.dailyInfos.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let model = model, let section = Section(rawValue: indexPath.section) else {
            fatalError("해당하는 셀이 없습니다.")
        }
        switch section {
        case .DailyTotalInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyTotalInfoCell", for: indexPath) as! DailyTotalInfoCollectionViewCell
            
            cell.titleLabel.text = model.dateFormatter.string(from: model.dailyTotal.standardDay)
            cell.incDecLabel.text = "\(model.dailyTotal.incDec)명"
            
            return cell
            
        case .WeeklyTotalInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeeklyTotalInfoCell", for: indexPath) as! WeeklyTotalInfoCollectionViewCell
            let weeklyTotalInfos = model.weeklyInfoDict[CovidInfoCategory.total.rawValue]!.sorted { $0.standardDay < $1.standardDay }
            let xAxis = weeklyTotalInfos.map { cell.dateFormatter.string(from: $0.standardDay) }
            let yAxis = weeklyTotalInfos.map { $0.incDec }
            
            cell.setChart(xAxis: xAxis, yAxis: yAxis)
            
            return cell
            
        case .DailyGubunInfo:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyGubunInfoCell", for: indexPath) as! DailyGubunInfoCollectionViewCell
            
            cell.titleLabel.text = model.dailyInfos[indexPath.row].gubun
            
            return cell
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            guard let section = Section(rawValue: sectionIndex) else { return nil }
            switch section {
            case .DailyTotalInfo:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.8
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = .init(top: 0, leading: halfOfRemainingWidth, bottom: 20, trailing: halfOfRemainingWidth)
                
                return section
                
            case .WeeklyTotalInfo:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
                
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.8
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = .init(top: 0, leading: halfOfRemainingWidth, bottom: 20, trailing: halfOfRemainingWidth)
                
                return section
                
            case .DailyGubunInfo:
                let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 8, trailing: 5)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 3)
                
                let availableLayoutWidth = layoutEnvironment.container.effectiveContentSize.width
                let groupWidth = availableLayoutWidth * 0.8
                let remainingWidth = availableLayoutWidth - groupWidth
                let halfOfRemainingWidth = remainingWidth / 2
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: halfOfRemainingWidth, bottom: 40, trailing: halfOfRemainingWidth)
                
                return section
            }
        }
        
        return layout
    }
}

