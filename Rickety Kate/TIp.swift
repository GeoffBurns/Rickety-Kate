//
//  TIp.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 31/12/2015.
//  Copyright © 2015 Geoff Burns All rights reserved.
//

import Foundation


/// Tips on how to play the game
public enum Tip 
{
    case tap_question_mark_to_learn_rules
    case tap_cog_symbol_to_change_rules
    case drag_a_card_to_the_center_to_play
    case you_need_to_follow_suite_if_you_can
    case try_to_avoid_winning_penalty_cards
    case the_lowest_score_win
    case tap_triangle_to_start_game
    case tap_dice_to_start_game_with_random_rules
    case tap_cross_to_end_game
    case tap_cog_symbol_to_build_your_own_deck_of_cards
    case tap_cog_symbol_to_change_the_number_of_players
    case try_to_avoid_winning_Rickety_Kate
    case try_to_block_other_players_by_holding_back_cards
    case try_not_to_block_yourself
    case no_Tip

    /// display tip as string
    var description : String
    {
            switch self
            {
            case .tap_question_mark_to_learn_rules : return "Tap_question_mark_to_learn_rules".localize
            case .tap_cog_symbol_to_change_rules : return "Tap_cog_symbol_to_change_rules".localize
            case .drag_a_card_to_the_center_to_play : return "Drag_a_card_to_the_center_to_play".localize
            case .you_need_to_follow_suite_if_you_can : return "You_need_to_follow_suite_if_you_can".localize
            case .try_to_avoid_winning_penalty_cards : return "Try_to_avoid_winning__".localizeWith(GameSettings.sharedInstance.rules.trumpSuitePlural)
            case .the_lowest_score_win : return "The_lowest_score_wins".localize
            case .tap_triangle_to_start_game : return "Tap_triangle_to_start_game".localize
            case .tap_dice_to_start_game_with_random_rules : return "Tap_dice_to_start_game_with_random_rules".localize
            case .tap_cross_to_end_game : return "Tap_cross_to_end_game".localize
            case .tap_cog_symbol_to_build_your_own_deck_of_cards : return "Tap_cog_symbol_to_build_your_own_deck_of_cards".localize
            case .tap_cog_symbol_to_change_the_number_of_players : return "Tap_cog_symbol_to_change_the_number_of_players".localize
            case .try_to_avoid_winning_Rickety_Kate : return "Try_to_avoid_winning_Rickety_Kate".localize
            case .try_to_block_other_players_by_holding_back_cards : return "Try_to_avoid_winning_Rickety_Kate".localize
            case .try_not_to_block_yourself : return "Try_not_to_block_yourself".localize
            case .no_Tip : return ""
            }
    }
    
    /// Tips shown in demo mode
    static let demoTips = [tap_question_mark_to_learn_rules,tap_cog_symbol_to_change_rules,you_need_to_follow_suite_if_you_can,try_to_avoid_winning_penalty_cards,the_lowest_score_win,tap_triangle_to_start_game,tap_dice_to_start_game_with_random_rules,tap_cog_symbol_to_build_your_own_deck_of_cards,tap_cog_symbol_to_change_the_number_of_players]
    
    /// Tips shown in game mode
    static let gameTips = [tap_question_mark_to_learn_rules,drag_a_card_to_the_center_to_play,you_need_to_follow_suite_if_you_can,try_to_avoid_winning_penalty_cards,the_lowest_score_win,tap_cross_to_end_game,try_to_avoid_winning_Rickety_Kate]
    
    /// current tips displayed
    static var tips = demoTips
    
    /// last tip displayed
    static var lastTip = no_Tip

    /// next tip displayed
    static func dispenceTip()->Tip
    {
        var result = no_Tip
        
        repeat {
            result = tips.randomItem!
        } while result==lastTip
        
        lastTip = result
        
    return result
    }
}
