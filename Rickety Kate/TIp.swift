//
//  TIp.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 31/12/2015.
//  Copyright © 2015 Geoff Burns All rights reserved.
//

import Foundation

public enum Tip 
{
    case Tap_question_mark_to_learn_rules
    case Tap_cog_symbol_to_change_rules
    case Drag_a_card_to_the_center_to_play
    case You_need_to_follow_suite_if_you_can
    case Try_to_avoid_winning_penalty_cards
    case The_lowest_score_win
    
    var description : String
    {
            switch self
            {
            case Tap_question_mark_to_learn_rules : return "Tap_question_mark_to_learn_rules".localize
            case Tap_cog_symbol_to_change_rules : return "Tap_cog_symbol_to_change_rules".localize
            case Drag_a_card_to_the_center_to_play : return "Drag_a_card_to_the_center_to_play".localize
            case You_need_to_follow_suite_if_you_can : return "You_need_to_follow_suite_if_you_can".localize
            case Try_to_avoid_winning_penalty_cards : return "Try_to_avoid_winning__".localizeWith(GameSettings.sharedInstance.rules.trumpSuitePlural)
            case The_lowest_score_win : return "The_lowest_score_win".localize
            }
    }

}
