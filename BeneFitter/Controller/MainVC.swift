//
//  MainView.swift
//  abseil
//
//  Created by Mattias Törnqvist on 2020-07-01.
//

import UIKit
import Firebase
import SVProgressHUD

class TopChallengeView: UIView {
    
//    MARK: - Properties
    let topChallengeCV: UICollectionView
    
//    MARK: - Init
    init(topChallengeCV: UICollectionView) {
        self.topChallengeCV = topChallengeCV
        super.init(frame: CGRect.zero)
        
        backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder, topChallengeCV: UICollectionView) {
        self.topChallengeCV = topChallengeCV
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        addSubviews(topChallengeCV)
        
        topChallengeCV.anchor(top: safeAreaLayoutGuide.topAnchor, paddingTop: 4, width: 320, height: 250)
        topChallengeCV.centerX(inView: self)
    }
    
}

class MainVC: UIViewController {
    
//    MARK: - Properties
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 5
//        layout.itemSize = CGSize(width: 120, height: 120)
        
        return layout
    }()
    
    let frame: CGRect = {
        let frame = CGRect.zero
        return frame
    }()
    
    lazy var topChallengeCV: UICollectionView = {
        let cv = UICollectionView.collectionView(with: layout, with: frame)
        return cv
    }()
    
    var topChallengeCVDelegateAndDataSource: TopChallengeCVDelegateAndDataSource?
    
//    MARK: - Lifecycle
    override func viewDidLoad() {
        view.backgroundColor = .green
        
        checkIfUserIsLoggedIn()
        
        configureNavBar()
        
        configureView()
        
        configureTopCollectionView()
        
        authorizeHealthKit()
        
    }
    
    func configureNavBar() {
        self.prefersLargeNCTitles()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleRefresh))
    }
    
    func configureView() {
        let view = TopChallengeView(topChallengeCV: topChallengeCV)
        self.view = view
    }
    
    func configureTopCollectionView() {
        topChallengeCVDelegateAndDataSource = TopChallengeCVDelegateAndDataSource(topChallengeCV)
        topChallengeCV.delegate = topChallengeCVDelegateAndDataSource
        topChallengeCV.dataSource = topChallengeCVDelegateAndDataSource
        
        topChallengeCV.register(TopChallengeCell.self, forCellWithReuseIdentifier: TopChallengeCell.identifier)
    }
    
    //    check if user is logged in and if not set LoginVC as root VC
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            
            DispatchQueue.main.async {
            let nav = UINavigationController(rootViewController: LoginVC())
            if #available(iOS 13.0, *) {
                nav.isModalInPresentation = true
            }
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: false, completion: nil)
            }
            
        }
    }
    
    func authorizeHealthKit() {
        HealthKitAssistant.authorizeHealthKit { (result) in
            
            switch result {
            case .success(_):
                Void()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
//    MARK: - Handlers
    @objc func handleRefresh() {
        
    }
}

class TopChallengeCVDelegateAndDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView
    
    init(_ collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopChallengeCell.identifier, for: indexPath) as! TopChallengeCell
        cell.delegate = self
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 320, height: 220)
    }
}

extension TopChallengeCVDelegateAndDataSource: TopChallengeCellDelegate {
    func didPressJoinChallenge(in cell: TopChallengeCell, selected challenge: TopChallengeModel) {
        
        let challengeId = UUID().uuidString
        let startDate = Date()
        
        let challenge = SelfChallenge(challengeId: challengeId,
                                      challengeType: challenge.typeOfChallenge,
                                      duration: challenge.duration,
                                      startDate: startDate,
                                      progress: challenge.progress,
                                      goal: challenge.goal,
                                      charityOrganization: challenge.charityOrganization,
                                      isTopChallenge: challenge.isTopChallenge,
                                      bettingAmount: challenge.bet.topChallengeBet)
        
        challenge.postChallenge { (result) in
            switch result {
            case .success(_):
                cell.didJoinTopChallenge()
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                cell.joinButton.isEnabled = true
            }
        }
    }
    
    
}
