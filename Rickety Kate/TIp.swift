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
    case Tap_triangle_to_start_game
    case Tap_dice_to_start_game_with_randam_rules
    case Tap_cross_to_end_game
    case Tap_cog_symbol_to_build_your_own_deck_of_cards
    case Tap_cog_symbol_to_change_the_number_of_players
    case Try_to_avoid_winning_Rickety_Kate
    
    case No_Tip

    
    var description : String
    {
            switch self
            {
            case Tap_question_mark_to_learn_rules : return "Tap_question_mark_to_learn_rules".localize
            case Tap_cog_symbol_to_change_rules : return "Tap_cog_symbol_to_change_rules".localize
            case Drag_a_card_to_the_center_to_play : return "Drag_a_card_to_the_center_to_play".localize
            case You_need_to_follow_suite_if_you_can : return "You_need_to_follow_suite_if_you_can".localize
            case Try_to_avoid_winning_penalty_cards : return "Try_to_avoid_winning__".localizeWith(GameSettings.sharedInstance.rules.trumpSuitePlural)
            case The_lowest_score_win : return "The_lowest_score_wins".localize
            case Tap_triangle_to_start_game : return "Tap_triangle_to_start_game".localize
            case Tap_dice_to_start_game_with_randam_rules : return "Tap_dice_to_start_game_with_randam_rules".localize
            case Tap_cross_to_end_game : return "Tap_cross_to_end_game".localize
            case Tap_cog_symbol_to_build_your_own_deck_of_cards : return "Tap_cog_symbol_to_build_your_own_deck_of_cards".localize
            case Tap_cog_symbol_to_change_the_number_of_players : return "Tap_cog_symbol_to_change_the_number_of_players".localize
            case Try_to_avoid_winning_Rickety_Kate : return "Try_to_avoid_winning_Rickety_Kate".localize
            case No_Tip : return ""
            }
    }
    static let demoTips = [Tap_question_mark_to_learn_rules,Tap_cog_symbol_to_change_rules,You_need_to_follow_suite_if_you_can,Try_to_avoid_winning_penalty_cards,The_lowest_score_win,Tap_triangle_to_start_game,Tap_dice_to_start_game_with_randam_rules,Tap_cog_symbol_to_build_your_own_deck_of_cards,Tap_cog_symbol_to_change_the_number_of_players]
    static let gameTips = [Tap_question_mark_to_learn_rules,Drag_a_card_to_the_center_to_play,You_need_to_follow_suite_if_you_can,Try_to_avoid_winning_penalty_cards,The_lowest_score_win,Tap_cross_to_end_game,Try_to_avoid_winning_Rickety_Kate]
    

    static var tips = demoTips
    
    static var lastTip = No_Tip

    static func dispenceTip()->Tip
    {
        var result = No_Tip
        
        repeat {
            result = tips.randomItem!
        } while result==lastTip
        
        lastTip = result
        
    return result
    }
}
