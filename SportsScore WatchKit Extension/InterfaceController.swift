//
//  InterfaceController.swift
//  SportsScore WatchKit Extension
//
//  Created by Alberto González Hernández on 16/12/20.
//

import WatchKit
import Foundation

struct Sport {
    var name = ""
    var competitorName = ""
    var pointNames: [String] = []
    var iconName = ""
    var scoreFunc: (_ competitor: String, _ pointType: String) -> Void
}

struct FootBallScore {
    var goals: Int = 0
}

struct TennisScore {
    var points: Int = 0
    var games: Int = 0
    var sets: Int = 0
}

struct PingPongScore {
    var points: Int = 0
    var games: Int = 0
}

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var sportsPicker: WKInterfacePicker!
    @IBOutlet weak var sportNameLabel: WKInterfaceLabel!
    @IBOutlet weak var competitorALabel: WKInterfaceLabel!
    @IBOutlet weak var competitorBLabel: WKInterfaceLabel!
    @IBOutlet weak var competitorAScoreLabel: WKInterfaceLabel!
    @IBOutlet weak var competitorBSocreLabel: WKInterfaceLabel!
    @IBOutlet weak var firstPointAButton: WKInterfaceButton!
    @IBOutlet weak var firstPointBButton: WKInterfaceButton!
    @IBOutlet weak var secondPointAButton: WKInterfaceButton!
    @IBOutlet weak var secondPointBButton: WKInterfaceButton!
    @IBOutlet weak var thirdPointAButton: WKInterfaceButton!
    @IBOutlet weak var thirdPointBButton: WKInterfaceButton!
    @IBOutlet weak var secondAddGroup: WKInterfaceGroup!
    @IBOutlet weak var thirdAddGroup: WKInterfaceGroup!
    
    public var sportsList: [Sport] = []
    public var currentSport: Sport!
    
    public var footballAScore = FootBallScore()
    public var footballBScore = FootBallScore()
    public var tennisAScore = TennisScore()
    public var tennisBScore = TennisScore()
    public var pingpongAScore = PingPongScore()
    public var pingpongBScore = PingPongScore()

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        initSportList()
        resetValues(sportName: "Football")
        setCurrentSport(currentSportIndex: 1)
        sportsPicker.setSelectedItemIndex(1)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    @IBAction func selectSport(_ value: Int) {
        setCurrentSport(currentSportIndex: value)
        resetValues(sportName: currentSport.name)
    }
    
    @IBAction func firstAddScoreA() {
        currentSport.scoreFunc("A", "point")
    }
    @IBAction func firstAddScoreB() {
        currentSport.scoreFunc("B", "point")
    }
    @IBAction func secondAddScoreA() {
        currentSport.scoreFunc("A", "game")
    }
    @IBAction func secondAddScoreB() {
        currentSport.scoreFunc("B", "game")
    }
    @IBAction func thirdAddScoreA() {
        currentSport.scoreFunc("A", "set")

    }
    @IBAction func thirdAddScoreB() {
        currentSport.scoreFunc("B", "set")
    }

    
    private func initSportList() {
        sportsList.append(Sport(name: "Tennis", competitorName: "Player", pointNames: ["Point", "Game", "Set"], iconName: "tennis-icon", scoreFunc: addTennisPoint))
        sportsList.append(Sport(name: "Football", competitorName: "Team", pointNames: ["Goal"], iconName: "football-icon", scoreFunc: addFootballPoint))
        sportsList.append(Sport(name: "Ping Pong", competitorName: "Player", pointNames: ["Point", "Game"], iconName: "pingpong-icon", scoreFunc: addPingPongPoint))
        
        sportsPicker.setItems(composePickerItemList(sports: sportsList))
    }

    private func composePickerItemList(sports: [Sport]) -> [WKPickerItem] {
        var itemList: [WKPickerItem] = []
        for sport in sports {
            itemList.append(composePickerItem(iconName: sport.iconName))
        }
        
        return itemList
    }

    private func composePickerItem(iconName: String) -> WKPickerItem {
        let pickerItem = WKPickerItem()
        pickerItem.contentImage = WKImage(imageName: iconName)
        return pickerItem
    }
    
    private func setCurrentSport(currentSportIndex: Int) {
        let selectedSport = sportsList[currentSportIndex]
        currentSport = selectedSport
        sportNameLabel.setText(currentSport.name)
        competitorALabel.setText("\(currentSport.competitorName) A")
        competitorBLabel.setText("\(currentSport.competitorName) B")
        
        secondAddGroup.setHidden(true)
        thirdAddGroup.setHidden(true)
        for (index, pointName) in currentSport.pointNames.enumerated() {
            if index == 0 {
                firstPointAButton.setTitle("\(pointName) +1")
                firstPointBButton.setTitle("\(pointName) +1")
            } else if index == 1 {
                secondAddGroup.setHidden(false)
                secondPointAButton.setTitle("\(pointName) +1")
                secondPointBButton.setTitle("\(pointName) +1")
            } else if index == 2 {
                thirdAddGroup.setHidden(false)
                thirdPointAButton.setTitle("\(pointName) +1")
                thirdPointBButton.setTitle("\(pointName) +1")
            }
        }
    }
    
    private func resetValues(sportName: String) {
        footballAScore = FootBallScore()
        footballBScore = FootBallScore()
        tennisAScore = TennisScore()
        tennisBScore = TennisScore()
        pingpongAScore = PingPongScore()
        pingpongBScore = PingPongScore()
        
        var initialScoreText = "0"
        if sportName == "Football" {
            initialScoreText = "0"
        } else if sportName == "Tennis" {
            initialScoreText = "0 | 0 | 0"
        } else if sportName == "Ping Pong" {
            initialScoreText = "0 | 0"
        }
        
        competitorAScoreLabel.setText(initialScoreText)
        competitorBSocreLabel.setText(initialScoreText)
    }
    
    private func addFootballPoint(competitor: String, _ pointType: String) {
        if competitor == "A" {
            footballAScore.goals+=1
            competitorAScoreLabel.setText(String(footballAScore.goals))
        } else if competitor == "B" {
            footballBScore.goals+=1
            competitorBSocreLabel.setText(String(footballBScore.goals))
        }
    }
    
    private func addPingPongPoint(competitor: String, _ pointType: String) {
        if competitor == "A" {
            switch pointType {
                case "point":
                    pingpongAScore.points = pingpongAScore.points < 12 ? pingpongAScore.points + 1 : 0
                case "game":
                    pingpongAScore.games = pingpongAScore.games < 4 ? pingpongAScore.games + 1 : 0
                default:
                    pingpongAScore.points = 0
                    pingpongAScore.games = 0
            }
            
            competitorAScoreLabel.setText("\(String(pingpongAScore.games)) | \(getPingPongPointName(pointNumber: pingpongAScore.points))")
        } else if competitor == "B" {
            switch pointType {
                case "point":
                    pingpongBScore.points = pingpongBScore.points < 12 ? pingpongBScore.points + 1 : 0
                case "game":
                    pingpongBScore.games = pingpongBScore.games < 4 ? pingpongBScore.games + 1 : 0
                default:
                    pingpongBScore.points = 0
                    pingpongBScore.games = 0
            }
            
            competitorBSocreLabel.setText("\(String(pingpongBScore.games)) | \(getPingPongPointName(pointNumber: pingpongBScore.points))")
        }
    }
    
    private func getPingPongPointName(pointNumber: Int) -> String {
        var pointName = ""
        if pointNumber > 11 {
            pointName = "AD"
        } else {
            pointName = String(pointNumber)
        }
        return pointName
    }
    
    private func addTennisPoint(competitor: String, _ pointType: String) {
        if competitor == "A" {
            switch pointType {
                case "point":
                    tennisAScore.points = tennisAScore.points < 4 ? tennisAScore.points + 1 : 0
                case "game":
                    tennisAScore.games = tennisAScore.games < 7 ? tennisAScore.games + 1 : 0
                case "set":
                    tennisAScore.sets = tennisAScore.sets < 3 ? tennisAScore.sets + 1 : 0
                default:
                    tennisAScore.points = 0
                    tennisAScore.games = 0
                    tennisAScore.sets = 0
            }
            
            competitorAScoreLabel.setText("\(String(tennisAScore.sets)) | \(String(tennisAScore.games)) | \(getTennisPointName(pointNumber: tennisAScore.points))")
        } else if competitor == "B" {
            switch pointType {
                case "point":
                    tennisBScore.points = tennisBScore.points < 4 ? tennisBScore.points + 1 : 0
                case "game":
                    tennisBScore.games = tennisBScore.games < 7 ? tennisBScore.games + 1 : 0
                case "set":
                    tennisBScore.sets = tennisBScore.sets < 3 ? tennisBScore.sets + 1 : 0
                default:
                    tennisBScore.points = 0
                    tennisBScore.games = 0
                    tennisBScore.sets = 0
            }
            
            competitorBSocreLabel.setText("\(String(tennisBScore.sets)) | \(String(tennisBScore.games)) | \(getTennisPointName(pointNumber: tennisBScore.points))")
        }
    }
    
    private func getTennisPointName(pointNumber: Int) -> String {
        var pointName = ""
        switch pointNumber {
            case 0:
                pointName = "0"
            case 1:
                pointName = "15"
            case 2:
                pointName = "30"
            case 3:
                pointName = "40"
            case 4:
                pointName = "AD"
            default:
                pointName = ""
        }
        return pointName
    }
    
}
