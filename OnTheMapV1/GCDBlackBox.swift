//
//  GCDBlackBox.swift
//  OnTheMapV1A
//
//  Created by Rick Mc on 7/14/18.
//  Copyright © 2018 Rick Mc. All rights reserved.
//

import Foundation

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
