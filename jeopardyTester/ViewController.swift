//
//  ViewController.swift
//  jeopardyTester
//
//  Created by David Lass on 6/9/19.
//  Copyright © 2019 David Lass. All rights reserved.
//

import UIKit

struct Show: Codable{
    var year: Int = 0;
    var month: Int = 0;
    var day: Int = 0;
}

struct Clue: Codable{
    var order: Int = 0;
    var category: String = "";
    var clue: String = "";
    var response: String = "";
    var value: String = "";
}

struct Episode: Codable{
    var show: Show? = nil;
    var jeopardy: [Clue]? = [];
    var doubleJeopardy: [Clue]? = [];
}

class ViewController: UIViewController {

    @IBOutlet weak var showNumber: UITextView!
    
    @IBOutlet weak var Category: UITextView!
    @IBOutlet weak var Clue: UITextView!
    @IBOutlet weak var QuestionNumber: UITextView!
    @IBOutlet weak var Correct: UITextView!
    @IBOutlet weak var NumberCorrect: UITextView!
    @IBOutlet weak var NumberIncorrect: UITextView!
    @IBOutlet weak var ShowAnswerButton: UIButton!
    
    
    @IBAction func ShowAnswer(_ sender: Any) {
        self.ShowAnswerButton.isHidden = true;
        if(!isDouble){
            Correct.text = firstRound[clueIndex].response;
        }else{
            Correct.text = secondRound[clueIndex].response;
        }
    }
    @IBAction func DontCount(_ sender: Any) {
        NextClue()
        self.ShowAnswerButton.isHidden = false;
    }
    @IBAction func Correct(_ sender: Any) {
        NextClue()
        self.ShowAnswerButton.isHidden = false;
    }
    @IBAction func Incorrect(_ sender: Any) {
        NextClue()
        self.ShowAnswerButton.isHidden = false;
    }
    
    func NextClue(){
        if(!isDouble){
            clueIndex = clueIndex + 1;
            if(firstRound.count-1>clueIndex){
                Clue.text = firstRound[clueIndex].clue;
                Correct.text = "";
                Category.text = firstRound[clueIndex].category + " " + firstRound[clueIndex].value;
            }
            else{
                isDouble = true;
                clueIndex = 0;
                Clue.text = secondRound[clueIndex].clue;
                Correct.text = "";
                Category.text = secondRound[clueIndex].category + " " + secondRound[clueIndex].value;
            }
        }else{
            clueIndex = clueIndex + 1;
            if(secondRound.count>clueIndex){
                Clue.text = secondRound[clueIndex].clue;
                Correct.text = "";
                Category.text = secondRound[clueIndex].category + " " + secondRound[clueIndex].value;
            }else{
                randomNumber = Int.random(in: 0 ..< allEpisodes.count);
                showInfo = String(allEpisodes[randomNumber].show!.day) + " " + String(allEpisodes[randomNumber].show!.month) + " " + String(allEpisodes[randomNumber].show!.year);
                
                firstRound = allEpisodes[randomNumber].jeopardy!;
                secondRound = allEpisodes[randomNumber].doubleJeopardy!;
                
                isDouble = false;
                clueIndex = 0;
                showNumber.text = showInfo;
                Clue.text = firstRound[clueIndex].clue;
                Correct.text = "";
                Category.text = firstRound[clueIndex].category + " " + firstRound[clueIndex].value;
                print("GameOver");
            }
        }
        QuestionNumber.text = String(clueIndex + 1);
    }
    
    var allEpisodes: Array<Episode> = [];
    var currentEpisode: Episode = Episode();
    var firstRound : Array<Clue> = [] ;
    var clueIndex = 0;
    var secondRound : Array<Clue> = [] ;
    var showInfo = "";
    var randomNumber = -1;
    var isDouble = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let decoder = JSONDecoder()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            // process files
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        //let fileURLProject = Bundle.main.path(forResource: "temp", ofType: "json")
        let fileURLProject = Bundle.main.path(forResource: "fullJeopardyHistory", ofType: "json")
        
        var readStringProject = ""
        do{
            readStringProject = try String(contentsOfFile:fileURLProject!, encoding:String.Encoding.utf8)
            
            let data = readStringProject.data(using: .utf8)!
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Any]//[Dictionary<String,Any>]
                {
                    randomNumber = Int.random(in: 0 ..< jsonArray.count);
                    
                    var jsonString = jsonArray[randomNumber];
                    
                    
                    let epArray = try decoder.decode([Episode].self, from: data);
                    
                    allEpisodes = epArray;
                    
                    showInfo = String(epArray[randomNumber].show!.day) + " " + String(epArray[randomNumber].show!.month) + " " + String(epArray[randomNumber].show!.year);
                    
                    firstRound = epArray[randomNumber].jeopardy!;
                    secondRound = epArray[randomNumber].doubleJeopardy!;
                    
                    showNumber.text = showInfo;
                    Clue.text = firstRound[0].clue;
                    Correct.text = "";
                    NumberCorrect.text = "0";
                    NumberIncorrect.text = "0";
                    QuestionNumber.text = "1";
                    Category.text = firstRound[clueIndex].category + " " + firstRound[clueIndex].value;
                    
                    
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
            
        }catch let err{
            print("fail")
            print(err)
        }
    }


}

