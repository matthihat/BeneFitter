//
//  TypeOfChallengeCell.swift
//  Activation
//
//  Created by Mattias Törnqvist on 2020-06-30.
//  Copyright © 2020 Mattias Törnqvist. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class TopChallengeCell: UICollectionViewCell {
    
    private let challengeGoal = ChallengeGoal.mostCaloriesBurnt.topChallengeGoal
//    MARK: - TODO Maybe hard code bet amount or other model for top pick
    private let challengeBet = ChallengeGoal.mostCaloriesBurnt
    private let duration = Duration.twentyFourHours
    private let charityOrganization = CharityOrganization.hjartOchLungFonden
//    private var selfChallenges = [SelfChallenge]()
    var delegate: TopChallengeCellDelegate?
    
//    MARK: - TODO create database with top challenge, add functions to fetch top model from db. Create webpage with admin login for editing new top challenges
//    private lazy var topChallenge = TopChallengeModel(image: #imageLiteral(resourceName: "HLF-logotyp"),
//                                             titleLabel: "Hjärt- & lungfonden",
//                                             textBody: "Aid the fight against heart and lung disease by joining this challenge",
//                                             typeOfChallenge: .mostCaloriesBurnt,
//                                             challengeGoal: challengeGoal,
//                                             duration: Duration.twentyFourHours,
//                                             charityOrganization: charityOrganization,
//                                             bet: challengeBet,
//                                             userHasJoined: false,
//                                             progress: 0,
//                                             goal: 500)
    
    override var isSelected: Bool {
        didSet {
//            contentView.layer.borderColor = isSelected ? UIColor.blue.cgColor :  UIColor.clear.cgColor
        }
    }
    
//    MARK: - Properties
    static let identifier = "Identifier"
    private let cornerRadius: CGFloat = 12
    var notificationCenter: NotificationCenter
    var selfChallenge: SelfChallenge?
    
    private lazy var bgView: UIView = {
        let view = UIView()
//        view.backgroundColor = .backgroundBlack
        view.layer.borderWidth = 1
        view.layer.cornerRadius = cornerRadius
        view.layer.shadowColor = UIColor.darkGray.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.8
        return view
    }()
    
    private let popularLabel: UILabel = {
        let label = UILabel()
        label.text = "Most popular"
        label.textColor = .white
//        label.font = .boldSystemFont(ofSize: 22)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        return label
    }()
    
    private let textBody: UITextView = {
        let txtView = UITextView()
        txtView.text = "Loading"
        txtView.textColor = .white
        txtView.backgroundColor = .clear
//        txtView.font = .boldSystemFont(ofSize: 12)
        txtView.font = UIFont.preferredFont(forTextStyle: .caption1)
        txtView.textAlignment = .center
        txtView.showsVerticalScrollIndicator = false
        txtView.isUserInteractionEnabled = false
        txtView.isScrollEnabled = false
        return txtView
    }()
    
    private let goalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let betLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let remainingTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = #imageLiteral(resourceName: "HLF-logotyp")
        return iv
    }()
    
    
    lazy var joinButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Join", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 20
        button.setHeight(to: 40)
        button.setWidth(to: 140)
        button.addTarget(self, action: #selector(didPressJoinButton), for: .touchUpInside)
        return button
    }()
    
    let gradientLayer = CAGradientLayer()
    let font = UIFont.preferredFont(forTextStyle: .body)
    
    enum TextColors {
        case highLight
        case bet
        
        var color: UIColor {
            switch self {
            case .highLight:
                return UIColor.systemRed
            case .bet:
                return UIColor.systemYellow
            }
        }
    }
    
//    MARK: - Init
    override init(frame: CGRect) {
        self.notificationCenter = .default
        super.init(frame: frame)
        
        
        configureUI()
        
        createObservers()
        
        createDefaultTopChallenge()
        
//        checkIfUserAlreadyHasJoinedTopChallenge()
        
        configureLabels()
        
        createGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    MARK: - Helper functions
    private func configureUI() {
        contentView.backgroundColor = .none
        contentView.layer.cornerRadius = cornerRadius
        
        addSubviews(bgView, joinButton)
        
        let bgFrame = CGRect(x: 5,
                             y: 5,
                             width: contentView.frame.width - 10,
                             height: contentView.frame.height - 25)
        bgView.layer.cornerRadius = cornerRadius
        bgView.frame = bgFrame
        
        bgView.addSubviews(popularLabel,
                           imageView,
                           textBody,
                           goalLabel,
                           betLabel,
                           remainingTimeLabel)
        
        popularLabel.centerX(inView: bgView)
        popularLabel.anchor(top: bgView.topAnchor,
                            paddingTop: 8)
        
        imageView.anchor(
            top: popularLabel.bottomAnchor,
////                         MARK: - TODO Scale image instead of neg. padding top and big height
                         paddingTop: -10,
//                         paddingLeft: 8,
                         width: 140,
                         height: 60)
        imageView.centerX(inView: bgView)
        
        textBody.anchor(top: imageView.bottomAnchor,
                        left: bgView.leftAnchor,
                        right: bgView.rightAnchor,
                        paddingTop: -20,
                        paddingLeft: 8,
                        paddingRight: 8)
        
        goalLabel.anchor(top: textBody.bottomAnchor,
                         left: textBody.leftAnchor,
                         paddingTop: 8)
        
        betLabel.anchor(top: goalLabel.bottomAnchor,
                        left: goalLabel.leftAnchor,
                        paddingTop: 4)
        
        remainingTimeLabel.anchor(top: betLabel.topAnchor,
                                  right: bgView.rightAnchor,
                                  paddingRight: 8)

        joinButton.centerX(inView: bgView)
        joinButton.centerYAnchor.constraint(equalTo: bgView.bottomAnchor).isActive = true
    }
    
//    MARK: - TODO create get set method when top challenge is available in database
    private func configureLabels() {
        textBody.text = selfChallenge?.charityOrganization.challengeInfo
        
        let goalAndDurationText = NSMutableAttributedString.withFont(font, "Burn")
        let goalText = NSAttributedString.withFontAndColor(font, selfChallenge?.charityOrganization.topChallengeGoal.description ?? "Not available", color: TextColors.highLight.color)
        let spacer = NSAttributedString(string: " ")
        let units = NSAttributedString.withFontAndText(font, ChallengeGoal.mostCaloriesBurnt.topChallengeDescription)
        let inString = NSAttributedString.withFontAndText(font, "in")
        let duration = NSAttributedString.withFontAndColor(font, selfChallenge?.charityOrganization.topChallengeBet.description ?? "Not available", color: TextColors.highLight.color)
        let hours = NSAttributedString.withFontAndText(font, "h")
        let donateText = NSMutableAttributedString.withFont(font, "Donate ")
        let bet = NSAttributedString.withFontAndColor(font, selfChallenge?.charityOrganization.topChallengeBet.description ?? "Not available", color: .systemYellow)
        let end = NSAttributedString.withFontAndText(font, " kr if you succeed")

        goalAndDurationText.appendMultiple(NSAttributedStrings: spacer, goalText, spacer, units, spacer, inString, spacer, duration, spacer, hours)
        goalLabel.attributedText = goalAndDurationText
        
        donateText.appendMultiple(NSAttributedStrings: bet, end)
        betLabel.attributedText = donateText
    }
    
    private func createGradientLayer() {
        gradientLayer.frame = bgView.bounds
        gradientLayer.cornerRadius = cornerRadius
        gradientLayer.colors = [UIColor.backgroundBlack.cgColor,
                                UIColor.backgroundBlack2.cgColor,
                                UIColor.darkGray.cgColor]
        gradientLayer.locations = [0.4, 0.5, 0.9]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.shadowColor = UIColor.darkGray.cgColor
        gradientLayer.shadowOffset = CGSize(width: 2, height: 2)
        gradientLayer.shadowRadius = 2
        gradientLayer.shadowOpacity = 0.8
        
        bgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func createObservers() {
        notificationCenter.addObserver(self, selector: #selector(alreadyJoinedTopChallenge(_:)), name: .alreadyEntered, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(configureLabelsChallengeIdle), name: .idle, object: nil)
        
        notificationCenter.addObserver(self, selector: #selector(configureLabelsChallengeNotEntered), name: .hasNotEntered, object: nil)
        
//        notificationCenter.addObserver(self, selector: #selector(configureLabelsChallengeAlreadyEntered), name: .alreadyEntered, object: nil)
        
    }
    
    func createDefaultTopChallenge() {
        
        let challengeId = UUID().uuidString
        let startDate = Date()
        
        selfChallenge = SelfChallenge(challengeId,
                                      .mostCaloriesBurnt,
                                      .twentyFourHours,
                                        startDate,
                                        0,
                                        charityOrganization.topChallengeGoal,
                                        NotificationCenter.default,
                                        .hjartOchLungFonden,
                                        true,
                                        charityOrganization.topChallengeBet)
        

    }
    
    func configureLabelsUserHasAlreadyJoined(_ challenge: SelfChallenge) {
        
        let progress = challenge.progress.description
        let formattedProgress = NSAttributedString.withFontAndColor(font, progress, color: TextColors.highLight.color)
        let goal = challenge.goal.description
        let formattedGoal = NSMutableAttributedString.withFont(font, goal)
        let bet = challenge.bettingAmount.description
        let formattedBet = NSAttributedString.withFontAndColor(font, bet, color: TextColors.bet.color)
        var remainingTime = "Loading.."
        
        let progressText = NSMutableAttributedString(attributedString: formattedProgress)
        let progrressText1 = NSAttributedString.withFontAndText(font, "/")
        let progressText2 = NSAttributedString.withFontAndText(font, " kcal done")
        
        progressText.appendMultiple(NSAttributedStrings: progrressText1, formattedGoal, progressText2)
        
        goalLabel.attributedText = progressText
        
        let betText1 = NSAttributedString.withFontAndText(font, "Bet is ")
        let betText2 = NSAttributedString.withFontAndText(font, " kr")
        let betText = NSMutableAttributedString(attributedString: betText1)
        betText.appendMultiple(NSAttributedStrings: formattedBet, betText2)
        
        betLabel.attributedText = betText
        
        remainingTime = calculateRemainingTime(until: challenge.endDate)
        let remainingTime_AttrString = NSAttributedString(string: remainingTime, attributes: [NSAttributedString.Key.foregroundColor : TextColors.bet.color])
        let remainingTimeText1 = NSMutableAttributedString(attributedString: remainingTime_AttrString)
        
        let suffix = NSAttributedString.withFontAndText(font, " left")
        
        remainingTimeText1.append(suffix)

        remainingTimeLabel.attributedText = remainingTimeText1
    }
    
    func calculateRemainingTime(until endDate: Date) -> String {
        
        let timeInterval = endDate.timeIntervalSince(Date())
        let timeRemaining = DateComponentsFormatter.format(duration: timeInterval)
        
        return timeRemaining
    }
    
//    MARK: - Handlers
    @objc func configureLabelsChallengeIdle() {
        let defaultText1 = NSMutableAttributedString.withFont(font, "Loading..")
        let defaultText2 = NSMutableAttributedString.withFont(font, "Loading..")
        
        joinButton.isEnabled = false
        joinButton.setTitle("...", for: .normal)
        joinButton.backgroundColor = .systemGray
        
        goalLabel.attributedText = defaultText1
        betLabel.attributedText = defaultText2
    }
    
    @objc func configureLabelsChallengeNotEntered() {
        joinButton.isEnabled = true
        joinButton.setTitle("Join", for: .normal)
        joinButton.setTitleColor(.white, for: .normal)
        joinButton.backgroundColor = .systemRed
    }
    
    @objc public func didJoinTopChallenge() {
        
        joinButton.isEnabled = false
        joinButton.setTitle("Joined ✓", for: .normal)
        joinButton.backgroundColor = .systemGreen
    }
    
    @objc func alreadyJoinedTopChallenge(_ notification: Notification) {
        
        guard let item = notification.userInfo as? [String : SelfChallenge] else { return }
        guard let challenge = item.values.first else { return }
        selfChallenge = challenge
        
//        topChallenge.userHasJoined = true
        joinButton.isEnabled = false
        joinButton.setTitle("Joined ✓", for: .normal)
        joinButton.backgroundColor = .systemGreen
        
        configureLabelsUserHasAlreadyJoined(challenge)
    }
    
//    private func checkIfUserAlreadyHasJoinedTopChallenge() {
//
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//
//        ChallengeService.shared.fetchUsersActiveSelfChallenges(userUid: currentUid) { (result) in
//
//            switch result {
//            case .success(var selfChallenge):
//                if selfChallenge.isTopChallenge {
//                    self.didJoinTopChallenge()
//                    selfChallenge.state = .alreadyEntered
//                }
//
//            case .failure(let error):
//                SVProgressHUD.showError(withStatus: error.localizedDescription)
//            }
//        }
//    }
    
//    MARK: - Handlers
    @objc func didPressJoinButton() {
        joinButton.isEnabled = false
        
        guard let challenge = selfChallenge else {
            return
        }
        
        delegate?.didPressJoinChallenge(in: self, selected: challenge)
    }
}
