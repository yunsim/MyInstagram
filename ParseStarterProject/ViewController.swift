/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        /*
        let user = PFObject(className: "Users")
        user["name"] = "Yunsi"
        user.saveInBackground { (success, error) in
            if success {
                print("Object has been saved")
            } else {
                if let error = error {
                    print (error)
                } else {
                    print("Error")
                }
            }
        }
        */
        
        let query = PFQuery(className: "Users")
        query.getObjectInBackground(withId: "mSGNNXHnGvO3") { (object, error) in
            if error != nil {
                print(error ?? -1)
            } else {
                if let user = object {
                    print(user["name"])
                    // update
                    user["name"] = "Mou"
                    user.saveInBackground {(success, error) in
                        if success {
                            print("Updated")
                        } else {
                            print("Error")
                        }
                    }
                }
            }
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
