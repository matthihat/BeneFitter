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
                print("DEBUG successfully authorized healthkit")
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
    }
    
//    MARK: - Handlers
    @objc func handleRefresh() {
        
        topChallengeCVDelegateAndDataSource?.didPressRefresh()
    }
}

class TopChallengeCVDelegateAndDataSource: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let collectionView: UICollectionView
    var selfChallenge: SelfChallenge?
    let notificationCenter: NotificationCenter
    let challengeService: ChallengeService
    let healthKitService: HKService
    
    init(_ collectionView: UICollectionView,
         _ notificationCenter: NotificationCenter = .default,
         _ challengeService: ChallengeService = .shared,
         _ healthKitService: HKService = .shared) {
        self.collectionView = collectionView
        self.notificationCenter = notificationCenter
        self.challengeService = challengeService
        self.healthKitService = healthKitService
        
        super.init()
        
        notificationCenter.addObserver(self, selector: #selector(userHasJoinedTopChallenge), name: .didEnter, object: nil)
        
        checkIfUserAlreadyHasJoinedTopChallenge()
        
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
    
    @objc func userHasJoinedTopChallenge(_ notification: Notification) {
        
        guard let item = notification.userInfo as? [String : SelfChallenge] else { return }
        guard let challenge = item.values.first else { return }
        selfChallenge = challenge
        
    }
    
      private func checkIfUserAlreadyHasJoinedTopChallenge() {
          
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
          challengeService.fetchUsersActiveSelfChallenges(userUid: currentUid) { (result) in
              
              switch result {
              case .success(var selfChallenge):
                  if selfChallenge.isTopChallenge {
                    self.selfChallenge = selfChallenge
                      selfChallenge.state = .alreadyEntered
                  }
    
              case .failure(let error):
                  SVProgressHUD.showError(withStatus: error.localizedDescription)
              }
          }
      }
    
//    MARK TODO check if user already has joined, move function from cell to here
    
    public func didPressRefresh() {
        
        var newProgress: Int?
        let group = DispatchGroup()
        
        guard let startDate = selfChallenge?.startDate,
            let endDate = selfChallenge?.endDate else { return }
        
        group.enter()
        
       healthKitService.getActiveCaloriesCount(since: startDate,
                                                to: endDate) { (result) in
                                                    
            switch result {
            case .success(let activeCalories):
                print("DEBUG ", activeCalories)
                newProgress = Int(activeCalories)
                group.leave()
                
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
            }
        }
        
        group.notify(queue: .main) {
            
            guard let progress = newProgress else { return }
            
            self.selfChallenge?.updateProgress(newProgress: progress, completion: { (result) in
                switch result {
                    
                case .success(let success):
                    print("DEBUG success!", success)
                case .failure(let error):
                    SVProgressHUD.showError(withStatus: error.localizedDescription)
                }
            })
        }
    }
}

extension TopChallengeCVDelegateAndDataSource: TopChallengeCellDelegate {
    func didPressJoinChallenge(in cell: TopChallengeCell,
                               selected challenge: TopChallengeModel) {
        
        let challengeId = UUID().uuidString
        let startDate = Date()
        
        selfChallenge = SelfChallenge(challengeId,
                                      challenge.typeOfChallenge,
                                      challenge.duration,
                                      startDate,
                                      challenge.progress,
                                      challenge.goal,
                                      NotificationCenter.default,
                                      challenge.charityOrganization,
                                      challenge.isTopChallenge,
                                      challenge.bet.topChallengeBet)
        
        selfChallenge?.postChallenge { (result) in
            switch result {
            case .success(_):
                cell.didJoinTopChallenge()
                self.selfChallenge?.state = .didEnter
            case .failure(let error):
                SVProgressHUD.showError(withStatus: error.localizedDescription)
                cell.joinButton.isEnabled = true
            }
        }
    }
    
    
}
