//
//  MenuViewController.swift
//  TossRoss_v3
//
//  Created by Edward Shin on 9/7/18.
//  Copyright © 2018 Edward Shin. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBAction func backPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil);
    }
    
    @IBAction func gravitySliderMoved(_ sender: UISlider) {
        print(sender.value);
//        GameScene.setGravityMultiplier(sender.value);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
