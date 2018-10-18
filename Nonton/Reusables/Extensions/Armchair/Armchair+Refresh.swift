//
//  Armchair+Refresh.swift
//  Nonton
//
//  Created by Michael Fromage on 11/04/18.
//  Copyright © 2018 icehousecorp. All rights reserved.
//

import Foundation
import Armchair

extension ArmchairManager {
	
	func reset() {
		Armchair.resetDefaults()
		Armchair.resetAllCounters()
		Armchair.useStoreKitReviewPrompt(true)
		Armchair.appID("944875099")
		Armchair.userDidSignificantEvent(true)
		Armchair.significantEventsUntilPrompt(0)
		Armchair.daysUntilPrompt(7)//7days
		Armchair.usesUntilPrompt(3)
		Armchair.daysBeforeReminding(1)
		Armchair.shouldPromptIfRated(true)
		Armchair.reviewTitle("Review Appku")
		Armchair.reviewMessage("Review Message")
		Armchair.cancelButtonTitle("Cancel")
		Armchair.rateButtonTitle("Rate")
		Armchair.remindButtonTitle("Later")
		Armchair.opensInStoreKit(true)
	}
	
}
