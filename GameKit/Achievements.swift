//
//  Achievements.swift
//  Rickety Kate
//
//  Created by Geoff Burns on 21/12/2015.
//  Copyright © 2015 Nereids Gold. All rights reserved.
//

import Foundation

public enum Achievement : String
{
    case HooliganHearts = "grp.Won1HooliganHeart"
    case HooliganJacks = "grp.hooliganjacks1win"
    case HooliganSpades = "grp.HooliganSpades1Win"
    case SoccerHearts = "grp.SoccerHeartsWin"
    case SoccerJacks = "grp.SoccerJackWIn"
    case SoccerSpades = "grp.SoccerSpadesWin"
    case BussingHearts = "grp.BussingHeartsWin"
    case BussingJacks = "grp.BussingJacksWin"
    case BussingSpades = "grp.BussingSpadesWin"
    case StraightHearts = "grp.StraightHeartsWin"
    case StraightJacks = "grp.StraightJacksWin"
    case StraightSpades = "grp.StraightSpadesWin"
    case ShootingTheMoon = "grp.ShootingTheMoon"
    case NinesWin = "grp.NinesWin"
    case EightsWin = "grp.EightsWin"
    case SevensWin = "grp.SevensWin"
    case SixesWin = "grp.SixesWin"
    case FivesWin = "grp.FivesWin"
    case None = ""

}

extension Achievement
{
    func SevenAchieventFor(_ number:Int) -> Achievement
    {
   
        switch number
        {
        case 5 : return Achievement.FivesWin
        case 6 : return Achievement.SixesWin
        case 7 : return Achievement.SevensWin
        case 8 : return Achievement.EightsWin
        case 9 : return Achievement.NinesWin
        default: return Achievement.None
        }
    }
}

public enum LearderBoard : String
{
    case Spades = "grp.spades"
    case Hearts = "grp.hearts"
    case Jacks = "grp.Jacks"
    case RicketyKate = "grp.Rickety"
    case Sevens = "grp.Sevens"
    case None = ""
}

