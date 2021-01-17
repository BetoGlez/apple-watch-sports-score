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
    var scoreFunc: (_ competitor: String) -> Void
}

struct FootBallScore {
    var goals: Int = 0
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
    
    // Tennis scorer
    public var playerAPoints = 0
    public var playerAGames = 0
    public var playerASets = 0

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        initSportList()
        resetValues()
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
        resetValues()
        setCurrentSport(currentSportIndex: value)
    }
    
    @IBAction func firstAddScoreA() {
        currentSport.scoreFunc("A")
    }
    @IBAction func secondAddScoreB() {
        currentSport.scoreFunc("B")
    }
    
    private func initSportList() {
        sportsList.append(Sport(name: "Tennis", competitorName: "Player", pointNames: ["Point", "Game", "Set"], iconName: "tennis-icon", scoreFunc: addSinglePoint(competitor:)))
        sportsList.append(Sport(name: "Football", competitorName: "Team", pointNames: ["Goal"], iconName: "football-icon", scoreFunc: addSinglePoint(competitor:)))
        sportsList.append(Sport(name: "Ping Pong", competitorName: "Player", pointNames: ["Point", "Game"], iconName: "pingpong-icon", scoreFunc: addSinglePoint(competitor:)))
        
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
    
    private func resetValues() {
        secondAddGroup.setHidden(true)
        thirdAddGroup.setHidden(true)
        
        footballAScore = FootBallScore()
        footballBScore = FootBallScore()
        competitorAScoreLabel.setText("0")
        competitorBSocreLabel.setText("0")
    }
    
    private func addSinglePoint(competitor: String) {
        if competitor == "A" {
            footballAScore.goals+=1
            competitorAScoreLabel.setText(String(footballAScore.goals))
        } else if competitor == "B" {
            footballBScore.goals+=1
            competitorBSocreLabel.setText(String(footballBScore.goals))
        }
    }
    
    
}
