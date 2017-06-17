class Window_TutorialData < Window_Base
# ----------------------------
attr_accessor :tutorial
# ----------------------------
def initialize
  super(256, 32, 384, 416)
  self.contents = Bitmap.new(width - 32, height - 32)
  @tutorial = 0
  self.opacity = 0
  self.oy = 0
  refresh
end
# ----------------------------
def refresh
  case @tutorial
  when 1
    self.contents.dispose
    self.contents = Bitmap.new(352, 416)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut1
  when 2
    self.contents.dispose
    self.contents = Bitmap.new(352, 464)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut2
  when 3
    self.contents.dispose
    self.contents = Bitmap.new(352, 848)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut3
  when 4
    self.contents.dispose
    self.contents = Bitmap.new(352, 1168)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut4
  when 5
    self.contents.dispose
    self.contents = Bitmap.new(352, 1200)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut5
  when 6
    self.contents.dispose
    self.contents = Bitmap.new(352, 1024)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut6
  when 7
    self.contents.dispose
    self.contents = Bitmap.new(352, 784)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut7
  when 8
    self.contents.dispose
    self.contents = Bitmap.new(352, 1184)
    self.contents.font.name = "Arial"
    self.contents.font.size = 24
    show_tut8
  end
end
# ----------------------------
def tutorial=(value)
  @tutorial = value
  refresh
end
# ----------------------------
def show_tut1
  conduit_img = RPG::Cache.icon("jewel01")
  axon_img = RPG::Cache.icon("jewel02")
  facilitator_img = RPG::Cache.icon("jewel03")
  tetra_img = RPG::Cache.icon("jewel04")
  self.contents.font.size = 16
  text1 = "Succor Interfaces allow you to access the Item, Shaping"
  text2 = "and Ability menus.  You can obtain Succor Interfaces"
  text3 = "by defeating enemies, searching treasure chests, and"
  text4 = "occassionally buying them."
  text5 = "There are four types of interfaces, explained below:"
  text6 = "Omnidimensional Conduits:"
  text7 = "Allows you to access the Item menu."
  text8 = "Axon Augmenters:"
  text9 = "Allows you to access the Shaping menu."
  text10 = "Conduction Facilitators:"
  text11 = "Allows you to access the Ability menu."
  text12 = "Crystalline Tetrahedrons:"
  text13 = "Can act as a substitute for the other three Succor"
  text14 = "Interfaces.  Can also be used to copy the time"
  text15 = "stream."
  text16 = "Note that if you possess a Crystalline Tetrahedron, it"
  text17 = "will substitute for other Interfaces without"
  text18 = "confirmation, so exercise caution."
  self.contents.blt(8, 129, conduit_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(8, 178, axon_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(8, 226, facilitator_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(8, 288, tetra_img, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(4, 32, 348, 32, text3)
  self.contents.draw_text(4, 48, 348, 32, text4)
  self.contents.draw_text(4, 80, 348, 32, text5)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(48, 118, 348, 32, text6)
  self.contents.font.color = normal_color
  self.contents.draw_text(48, 134, 348, 32, text7)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(48, 166, 348, 32, text8)
  self.contents.font.color = normal_color
  self.contents.draw_text(48, 182, 348, 32, text9)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(48, 214, 348, 32, text10)
  self.contents.font.color = normal_color
  self.contents.draw_text(48, 230, 348, 32, text11)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(48, 262, 348, 32, text12)
  self.contents.font.color = normal_color
  self.contents.draw_text(48, 278, 348, 32, text13)
  self.contents.draw_text(48, 294, 348, 32, text14)
  self.contents.draw_text(48, 310, 348, 32, text15)
  self.contents.draw_text(4, 348, 348, 32, text16)
  self.contents.draw_text(4, 364, 348, 32, text17)
  self.contents.draw_text(4, 380, 348, 32, text18)
end
# ----------------------------
def show_tut2
  active_img = RPG::Cache.icon("cmd01")
  passive_img = RPG::Cache.icon("cmd02")
  r_button_img = RPG::Cache.icon("talk03")
  l_button_img = RPG::Cache.icon("talk04")
  c_button_img = RPG::Cache.icon("talk05")
  self.contents.font.size = 16
  text1 = "Command Abilities represent the battle commands that a"
  text2 = "character has at his or her disposal.  To open the"
  text3 = "Command Abilities screen, open the Shaping menu and"
  text4 = "use the"
  text5 = "and"
  text6 = "buttons to navigate to the Command"
  text7 = "Abilities screen."
  text8 = "On the Command Abilities screen, you can equip and"
  text9 = "unequip commands by pressing button"
  text10 = "."
  text11 = "There are two types of Command Abilities, explained"
  text12 = "below:"
  text13 = "Active Abilities:"
  text14 = "These abilities make the character"
  text15 = "take some discrete action.  They directly consume"
  text16 = "FT.  Examples of Active Abilities include \'Attack\""
  text17 = "and \"Item-Once\"."
  text18 = "Passive Abilities:"
  text19 = "These abilities make the character"
  text20 = "take some indirect action that persists until"
  text21 = "the character chooses a different command."
  text22 = "While not directly consuming FT, these"
  text23 = "commands either slow or halt FT recovery."
  text24 = "You can have up to eight abilities equipped at once."
  text25 = "Unequipped commands will be shown in gray.  Commands"
  text26 = "will appear in the battle menu in the order in which"
  text27 = "you equip them.  You can preview this order using"
  text28 = "the Status command on the main menu."
  self.contents.blt(50, 54, l_button_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(100, 54, r_button_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(228, 116, c_button_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(8, 220, active_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(8, 308, passive_img, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(4, 32, 348, 32, text3)
  self.contents.draw_text(4, 48, 348, 32, text4)
  self.contents.draw_text(76, 48, 348, 32, text5)
  self.contents.draw_text(128, 48, 348, 32, text6)
  self.contents.draw_text(4, 64, 348, 32, text7)
  self.contents.draw_text(4, 96, 348, 32, text8)
  self.contents.draw_text(4, 112, 348, 32, text9)
  self.contents.draw_text(250, 112, 348, 32, text10)
  self.contents.draw_text(4, 144, 348, 32, text11)
  self.contents.draw_text(4, 160, 348, 32, text12)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(48, 192, 348, 32, text13)
  self.contents.font.color = normal_color
  self.contents.draw_text(140, 192, 348, 32, text14)
  self.contents.draw_text(48, 208, 348, 32, text15)
  self.contents.draw_text(48, 224, 348, 32, text16)
  self.contents.draw_text(48, 240, 348, 32, text17)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(48, 272, 348, 32, text18)
  self.contents.font.color = normal_color
  self.contents.draw_text(152, 272, 348, 32, text19)
  self.contents.draw_text(48, 288, 348, 32, text20)
  self.contents.draw_text(48, 304, 348, 32, text21)
  self.contents.draw_text(48, 320, 348, 32, text22)
  self.contents.draw_text(48, 336, 348, 32, text23)
  self.contents.draw_text(4, 368, 348, 32, text24)
  self.contents.draw_text(4, 384, 348, 32, text25)
  self.contents.draw_text(4, 400, 348, 32, text26)
  self.contents.draw_text(4, 416, 348, 32, text27)
  self.contents.draw_text(4, 432, 348, 32, text28)
end
# ----------------------------
def show_tut3
  self.contents.font.size = 16
  text1 = "The Variable-Effect Synthesis System (VESS) allows"
  text2 = "Syeull to increase his primary stats and learn"
  text3 = "abilities from his weapons and armor.  He does"
  text4 = "not, however, gain any stats and abilities by"
  text5 = "levelling up."
  text6 = "Each time Syeull wins a battle, any weapons"
  text7 = "and armor he has equipped will gain Synthesis Points"
  text8 = "(SP), based on the difficulty of the enemies, his level,"
  text9 = "and a small random factor."
  text10 = "Each weapon and armor Syeull can equip has a Mastery"
  text11 = "Value, expressed in SP.  At any time, Syeull can choose"
  text12 = "to learn the ability contained within it (even if the"
  text13 = "number of SP earned for that item is less than the"
  text14 = "Mastery Value).  However, if Syeull chooses to learn"
  text15 = "the ability before the amount of SP accrued has reached"
  text16 = "the Mastery Value, the amount of stat points gained will"
  text17 = "be lower (for stat gains) or the power and accuracy"
  text18 = "will be lower, and the FT cost higher (for abilities)."
  text19 = "You can also choose to continue to gain SP for an"
  text20 = "item beyond the Mastery Value, up to double the"
  text21 = "Mastery Value.  This will increase stat gains and"
  text22 = "make the power, accuracy, and FT cost of abilities"
  text23 = "more favorable.  The first table below shows how"
  text24 = "many points of Strength the ability \"Strength+5\""
  text25 = "will grant based on percentage of the Mastery"
  text26 = "Value:"
  text27 = "Mastery"
  text28 = "Points Gained"
  text29 = "25%"
  text30 = "1"
  text31 = "50%"
  text32 = "2"
  text33 = "100%"
  text34 = "5"
  text35 = "150%"
  text36 = "6"
  text37 = "200%"
  text38 = "7"
  text39 = "The next table shows the attack power, accuracy, and"
  text40 = "FT cost for the \"Oblique Trajectory\" skill at various"
  text41 = "levels of mastery:"
  text42 = "Mastery"
  text43 = "Power"
  text44 = "Accuracy"
  text45 = "FT Cost"
  text46 = "25%"
  text47 = "4"
  text48 = "22"
  text49 = "63"
  text50 = "50%"
  text51 = "8"
  text52 = "45"
  text53 = "54"
  text54 = "100%"
  text55 = "16"
  text56 = "90"
  text57 = "36"
  text58 = "150%"
  text59 = "18"
  text60 = "95"
  text61 = "34"
  text62 = "200%"
  text63 = "20"
  text64 = "100"
  text65 = "32"
  text66 = "At any time, you can Bifurcate a learned skill or stat"
  text67 = "gain.  This causes the ability to be unleared and its"
  text68 = "SP reset to 0.  This allows you to relearn the ability"
  text69 = "under more favorable circumstances."
  self.contents.fill_rect(84, 490, 180, 1, normal_color)
  self.contents.fill_rect(16, 666, 320, 1, normal_color)
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(4, 32, 348, 32, text3)
  self.contents.draw_text(4, 48, 348, 32, text4)
  self.contents.draw_text(4, 64, 348, 32, text5)
  self.contents.draw_text(4, 96, 348, 32, text6)
  self.contents.draw_text(4, 112, 348, 32, text7)
  self.contents.draw_text(4, 128, 348, 32, text8)
  self.contents.draw_text(4, 144, 348, 32, text9)
  self.contents.draw_text(4, 176, 348, 32, text10)
  self.contents.draw_text(4, 192, 348, 32, text11)
  self.contents.draw_text(4, 208, 348, 32, text12)
  self.contents.draw_text(4, 224, 348, 32, text13)
  self.contents.draw_text(4, 240, 348, 32, text14)
  self.contents.draw_text(4, 256, 348, 32, text15)
  self.contents.draw_text(4, 272, 348, 32, text16)
  self.contents.draw_text(4, 288, 348, 32, text17)
  self.contents.draw_text(4, 304, 348, 32, text18)
  self.contents.draw_text(4, 320, 348, 32, text19)
  self.contents.draw_text(4, 336, 348, 32, text20)
  self.contents.draw_text(4, 352, 348, 32, text21)
  self.contents.draw_text(4, 368, 348, 32, text22)
  self.contents.draw_text(4, 384, 348, 32, text23)
  self.contents.draw_text(4, 400, 348, 32, text24)
  self.contents.draw_text(4, 416, 348, 32, text25)
  self.contents.draw_text(4, 432, 348, 32, text26)
  self.contents.draw_text(94, 464, 348, 32, text27)
  self.contents.draw_text(172, 464, 348, 32, text28)
  self.contents.draw_text(102, 488, 35, 32, text29, 1)
  self.contents.draw_text(210, 488, 12, 32, text30, 1)
  self.contents.draw_text(102, 504, 35, 32, text31, 1)
  self.contents.draw_text(210, 504, 12, 32, text32, 1)
  self.contents.draw_text(102, 520, 35, 32, text33, 1)
  self.contents.draw_text(210, 520, 12, 32, text34, 1)
  self.contents.draw_text(102, 536, 35, 32, text35, 1)
  self.contents.draw_text(210, 536, 12, 32, text36, 1)
  self.contents.draw_text(102, 552, 35, 32, text37, 1)
  self.contents.draw_text(210, 552, 12, 32, text38, 1)
  self.contents.draw_text(4, 584, 348, 32, text39)
  self.contents.draw_text(4, 600, 348, 32, text40)
  self.contents.draw_text(4, 616, 348, 32, text41)
  self.contents.draw_text(24, 640, 348, 32, text42)
  self.contents.draw_text(108, 640, 348, 32, text43)
  self.contents.draw_text(184, 640, 348, 32, text44)
  self.contents.draw_text(272, 640, 348, 32, text45)
  self.contents.draw_text(32, 664, 35, 32, text46, 1)
  self.contents.draw_text(116, 664, 24, 32, text47, 1)
  self.contents.draw_text(200, 664, 24, 32, text48, 1)
  self.contents.draw_text(284, 664, 24, 32, text49, 1)
  self.contents.draw_text(32, 680, 35, 32, text50, 1)
  self.contents.draw_text(116, 680, 24, 32, text51, 1)
  self.contents.draw_text(200, 680, 24, 32, text52, 1)
  self.contents.draw_text(284, 680, 24, 32, text53, 1)
  self.contents.draw_text(32, 696, 35, 32, text54, 1)
  self.contents.draw_text(116, 696, 24, 32, text55, 1)
  self.contents.draw_text(200, 696, 24, 32, text56, 1)
  self.contents.draw_text(284, 696, 24, 32, text57, 1)
  self.contents.draw_text(32, 712, 35, 32, text58, 1)
  self.contents.draw_text(116, 712, 24, 32, text59, 1)
  self.contents.draw_text(200, 712, 24, 32, text60, 1)
  self.contents.draw_text(284, 712, 24, 32, text61, 1)
  self.contents.draw_text(32, 728, 35, 32, text62, 1)
  self.contents.draw_text(116, 728, 24, 32, text63, 1)
  self.contents.draw_text(200, 728, 24, 32, text64, 1)
  self.contents.draw_text(284, 728, 24, 32, text65, 1)
  self.contents.draw_text(4, 764, 348, 32, text66)
  self.contents.draw_text(4, 780, 348, 32, text67)
  self.contents.draw_text(4, 796, 348, 32, text68)
  self.contents.draw_text(4, 812, 348, 32, text69)
end
# ----------------------------
def show_tut4
  self.contents.font.size = 16
  cc_text = "Chronic Course"
  ac_text = "Acute Course"
  text1 = "There are fourteen negative status effects in Phylomortis:"
  text2 = "Avant-Garde.  They are explained below:"
  text3 = "Defeated"
  text4 = "Inflicted when HP reaches 0.  The afflicted character cannot"
  text5 = "act.  Some enemies can inflict this status directly."
  text6 = "Can be cured by the Vitaeus Lux series of items."
  text7 = "Poison"
  text8 = "Damage is dealt at regular intervals during battle and with"
  text9 = "each step taken on the field map.  Can be cured with Prius"
  text10 = "Antivenin."
  text11 = "Paralysis"
  text12 = "The afflicted character cannot act.  Can be cured with"
  text13 = "a Motion Facilitator."
  text14 = "Stun"
  text15 = "The afflicted character cannot act.  This condition recovers"
  text16 = "naturally in a few seconds or at the end of battle."
  text17 = "Insane"
  text18 = "The afflicted character will attack randomly.  Can be"
  text19 = "cured with Cogniphosphorous or at the end of battle."
  text20 = "Puppet"
  text21 = "The afflicted character will attack allies.  Can be"
  text22 = "cured with Cogniphosporous or at the end of battle."
  text23 = "Desynch"
  text24 = "The afflicted character cannot use Shaping Abilities."
  text25 = "Can be cured with Clarity Poultice."
  text26 = "Disease"
  text27 = "Items that recover HP, FT, EX and status effects"
  text28 = "besides Disease have no effect.  Can be cured with"
  text29 = "Protomorphic Enzyme."
  text30 = "Fear"
  text31 = "Afflicted character cannot attack.  Can be cured with"
  text32 = "Embolden Arpeggio or at the end of battle."
  text33 = "Unsteady"
  text34 = "Afflicted character's hit ratio decreases dramatically."
  text35 = "Can be cured with a Motion Facilitator or at the end"
  text36 = "of battle."
  text37 = "Sluggish"
  text38 = "Afflicted character's fatigue recovery rate is halved,"
  text39 = "and command execution is delayed.  Can be cured with"
  text40 = "a Motion Facilitator or at the end of battle."
  text41 = "Plague"
  text42 = "All of afflicted character's stats are lowered and damage"
  text43 = "is dealt at regular intervals during battle and on"
  text44 = "the field map.  The plague may spread to other characters."
  text45 = "Can be cured with Retroviral Antibody."
  text46 = "Stupify"
  text47 = "Afflicted character cannot gain experience.  Can be cured"
  text48 = "with Clarity Poultice."
  text49 = "Sleep"
  text50 = "Afflicted character cannot act.  Can be cured with Reticula"
  text51 = "Mist, by taking physical damage, or at the end of battle."
  self.contents.fill_rect(4, 56, 1, 16, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(20, 56, 1, 16, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(4, 56, 16, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(4, 72, 16, 1, Color.new(255, 255, 255, 255))
  self.contents.fill_rect(4, 144, 16, 16, Color.new(0, 187, 0, 255))
  self.contents.fill_rect(4, 232, 16, 16, Color.new(255, 255, 0, 255))
  self.contents.fill_rect(4, 304, 16, 16, Color.new(153, 160, 119, 255))
  self.contents.fill_rect(4, 376, 16, 16, Color.new(255, 204, 136, 255))
  self.contents.fill_rect(4, 448, 16, 16, Color.new(255, 204, 0, 255))
  self.contents.fill_rect(4, 520, 16, 16, Color.new(204, 0, 255, 255))
  self.contents.fill_rect(4, 592, 16, 16, Color.new(119, 0, 0, 255))
  self.contents.fill_rect(4, 680, 16, 16, Color.new(255, 0, 0, 255))
  self.contents.fill_rect(4, 752, 16, 16, Color.new(85, 85, 0, 255))
  self.contents.fill_rect(4, 840, 16, 16, Color.new(153, 255, 204, 255))
  self.contents.fill_rect(4, 928, 16, 16, Color.new(133, 133, 133, 255))
  self.contents.fill_rect(4, 1032, 16, 16, Color.new(0, 0, 255, 255))
  self.contents.fill_rect(4, 1104, 16, 16, Color.new(0, 255, 255, 255))
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(24, 48, 348, 32, text3)
  self.contents.draw_text(264, 48, 348, 32, cc_text)
  self.contents.draw_text(4, 72, 348, 32, text4)
  self.contents.draw_text(4, 88, 348, 32, text5)
  self.contents.draw_text(4, 104, 348, 32, text6)
  self.contents.draw_text(24, 136, 348, 32, text7)
  self.contents.draw_text(264, 136, 348, 32, cc_text)
  self.contents.draw_text(4, 160, 348, 32, text8)
  self.contents.draw_text(4, 176, 348, 32, text9)
  self.contents.draw_text(4, 192, 348, 32, text10)
  self.contents.draw_text(24, 224, 348, 32, text11)
  self.contents.draw_text(264, 224, 348, 32, cc_text)
  self.contents.draw_text(4, 248, 348, 32, text12)
  self.contents.draw_text(4, 264, 348, 32, text13)
  self.contents.draw_text(24, 296, 348, 32, text14)
  self.contents.draw_text(274, 296, 348, 32, ac_text)
  self.contents.draw_text(4, 320, 348, 32, text15)
  self.contents.draw_text(4, 336, 348, 32, text16)
  self.contents.draw_text(24, 368, 348, 32, text17)
  self.contents.draw_text(274, 368, 348, 32, ac_text)
  self.contents.draw_text(4, 392, 348, 32, text18)
  self.contents.draw_text(4, 408, 348, 32, text19)
  self.contents.draw_text(24, 440, 348, 32, text20)
  self.contents.draw_text(274, 440, 348, 32, ac_text)
  self.contents.draw_text(4, 464, 348, 32, text21)
  self.contents.draw_text(4, 480, 348, 32, text22)
  self.contents.draw_text(24, 512, 348, 32, text23)
  self.contents.draw_text(264, 512, 348, 32, cc_text)
  self.contents.draw_text(4, 536, 348, 32, text24)
  self.contents.draw_text(4, 552, 348, 32, text25)
  self.contents.draw_text(24, 584, 348, 32, text26)
  self.contents.draw_text(264, 584, 348, 32, cc_text)
  self.contents.draw_text(4, 608, 348, 32, text27)
  self.contents.draw_text(4, 624, 348, 32, text28)
  self.contents.draw_text(4, 640, 348, 32, text29)
  self.contents.draw_text(24, 672, 348, 32, text30)
  self.contents.draw_text(274, 672, 348, 32, ac_text)
  self.contents.draw_text(4, 696, 348, 32, text31)
  self.contents.draw_text(4, 712, 348, 32, text32)
  self.contents.draw_text(24, 744, 348, 32, text33)
  self.contents.draw_text(274, 744, 348, 32, ac_text)
  self.contents.draw_text(4, 768, 348, 32, text34)
  self.contents.draw_text(4, 784, 348, 32, text35)
  self.contents.draw_text(4, 800, 348, 32, text36)
  self.contents.draw_text(24, 832, 348, 32, text37)
  self.contents.draw_text(274, 832, 348, 32, ac_text)
  self.contents.draw_text(4, 856, 348, 32, text38)
  self.contents.draw_text(4, 872, 348, 32, text39)
  self.contents.draw_text(4, 888, 348, 32, text40)
  self.contents.draw_text(24, 920, 348, 32, text41)
  self.contents.draw_text(264, 920, 348, 32, cc_text)
  self.contents.draw_text(4, 944, 348, 32, text42)
  self.contents.draw_text(4, 960, 348, 32, text43)
  self.contents.draw_text(4, 976, 348, 32, text44)
  self.contents.draw_text(4, 992, 348, 32, text45)
  self.contents.draw_text(24, 1024, 348, 32, text46)
  self.contents.draw_text(264, 1024, 348, 32, cc_text)
  self.contents.draw_text(4, 1048, 348, 32, text47)
  self.contents.draw_text(4, 1064, 348, 32, text48)
  self.contents.draw_text(24,1096, 348, 32, text49)
  self.contents.draw_text(274, 1096, 348, 32, ac_text)
  self.contents.draw_text(4, 1120, 348, 32, text50)
  self.contents.draw_text(4, 1136, 348, 32, text51)
end
# ----------------------------
def show_tut5
  bs1_img = Bitmap.new("Graphics/Stuff/tut01.png")
  bs2_img = Bitmap.new("Graphics/Stuff/tut02.png")
  bs3_img = Bitmap.new("Graphics/Stuff/tut03.png")
  bs4_img = Bitmap.new("Graphics/Stuff/tut04.png")
  bs5_img = Bitmap.new("Graphics/Stuff/tut05.png")
  bs6_img = Bitmap.new("Graphics/Stuff/tut06.png")
  bs7_img = Bitmap.new("Graphics/Stuff/tut07.png")
  x_button_img = RPG::Cache.icon("talk06")
  self.contents.font.size = 16
  text1 = "Phylomortis: Avant-Garde uses the Segment-Based"
  text2 = "Fatigue System (SBFS).  This is an active battle system"
  text3 = "Rather than taking turns in a specified order or based"
  text4 = "on time bars, characters\' actions resolve immediately,"
  text5 = "and they may take another action immediately afterward."
  text6 = "Each"
  text7 = "character"
  text8 = "has Fatigue"
  text9 = "Points (FT) that are consumed when actions are taken," 
  text10 = "and recover naturally as time passes."
  text11 = "A character's current FT has an effect on his or her"
  text12 = "stats.  A character with less than 0 FT will have"
  text13 = "reduced stats, while a character with more than 0 FT"
  text14 = "will have increased stats.  A character's FT is shown"
  text15 = "visually in the form of a bar like the one in the"
  text16 = "picture above.  A red bar indicates negative FT, while"
  text17 = "a positive FT is indicated by a blue bar."
  text18 = "Each character also has an Exertion"
  text19 = "(EX) value.  This value is usually"
  text20 = "increased by 100% each time an"
  text21 = "action is taken.  EX decreases gradually while a character"
  text22 = "stands idle."
  text23 = "The FT cost of actions a character takes is increased by his"
  text24 = "or her EX value.  For example, an attack costs 20 FT, but if"
  text25 = "a character attacks with 100% EX, that attack will cost 40 FT."
  text26 = "If a character's FT drops below -100 (full red bar), that"
  text27 = "character will faint and be unable to take any actions."
  text28 = "Additionally, a character with"
  text29 = "less than -100 FT runs the risk"
  text30 = "of Overfatigue. A character that"
  text31 = "suffers from Overfatigue dies"
  text32 = "instantly. The risk of Overfatigue is proportional to the"
  text33 = "degree to which the character's FT is below -100."
  text34 = "Characters resurrected during battle typically do not"
  text35 = "recover FT as a consequence of resurrection, so take"
  text36 = "care not to Overfatigue often."
  text37 = "Like"
  text38 = "other"
  text39 = "battle commands, Shaping abilities cost FT to use.  They"
  text40 = "also have an additional cost, called the Energy cost."
  text41 = "Each character starts with 100% energy.  If a character's"
  text42 = "Energy is below 100%, his or her fatigue recovery rate"
  text43 = "will be negatively affected.  The cost of a Shaping"
  text44 = "ability is shown as FT cost, followed by a slash,"
  text45 = "followed by Energy cost, as shown in the picture above."
  text46 = "There are three types of surprise in Phylomortis: Avant-"
  text47 = "Garde.  They are explained below:"
  text48 = "Tactical Ambush:"
  text49 = "All members of the"
  text50 = "group that has the"
  text51 = "advantage can take"
  text52 = "one action before the other side can respond.  If the party"
  text53 = "gets a Tactical Ambush, time will not start to flow until"
  text54 = "you press      ."
  text55 = "Initiative:"
  text56 = "The party that"
  text57 = "has the advantage"
  text58 = "can act unopposed"
  text59 = "for an random amount of time."
  text60 = "Support Crush:"
  text61 = "Between one and"
  text62 = "one less than"
  text63 = "the size of the"
  text64 = "surprised party cannot use Shaping abilities or items"
  text65 = "that heal or enhance the party for the duration of"
  text66 = "the battle."
  self.contents.blt(4, 104, bs1_img, Rect.new(0, 0, 256, 48))
  self.contents.blt(4, 312, bs2_img, Rect.new(0, 0, 112, 48))
  self.contents.blt(4, 488, bs3_img, Rect.new(0, 0, 148, 64))
  self.contents.blt(4, 648, bs4_img, Rect.new(0, 0, 296, 32))
  self.contents.blt(4, 856, bs5_img, Rect.new(0, 0, 200, 64))
  self.contents.blt(4, 984, bs6_img, Rect.new(0, 0, 200, 64))
  self.contents.blt(4, 1080, bs7_img, Rect.new(0, 0, 200, 64))
  self.contents.blt(62, 948, x_button_img, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(4, 32, 348, 32, text3)
  self.contents.draw_text(4, 48, 348, 32, text4)
  self.contents.draw_text(4, 64, 348, 32, text5)
  self.contents.draw_text(270, 96, 348, 32, text6)
  self.contents.draw_text(270, 112, 348, 32, text7)
  self.contents.draw_text(270, 128, 348, 32, text8)
  self.contents.draw_text(4, 144, 348, 32, text9)
  self.contents.draw_text(4, 160, 348, 32, text10)
  self.contents.draw_text(4, 176, 348, 32, text11)
  self.contents.draw_text(4, 192, 348, 32, text12)
  self.contents.draw_text(4, 208, 348, 32, text13)
  self.contents.draw_text(4, 224, 348, 32, text14)
  self.contents.draw_text(4, 240, 348, 32, text15)
  self.contents.draw_text(4, 256, 348, 32, text16)
  self.contents.draw_text(4, 272, 348, 32, text17)
  self.contents.draw_text(126, 304, 348, 32, text18)
  self.contents.draw_text(126, 320, 348, 32, text19)
  self.contents.draw_text(126, 336, 348, 32, text20)
  self.contents.draw_text(4, 352, 348, 32, text21)
  self.contents.draw_text(4, 368, 348, 32, text22)
  self.contents.draw_text(4, 384, 348, 32, text23)
  self.contents.draw_text(4, 400, 348, 32, text24)
  self.contents.draw_text(4, 416, 348, 32, text25)
  self.contents.draw_text(4, 432, 348, 32, text26)
  self.contents.draw_text(4, 448, 348, 32, text27)
  self.contents.draw_text(162, 480, 348, 32, text28)
  self.contents.draw_text(162, 496, 348, 32, text29)
  self.contents.draw_text(162, 512, 348, 32, text30)
  self.contents.draw_text(162, 528, 348, 32, text31)
  self.contents.draw_text(4, 544, 348, 32, text32)
  self.contents.draw_text(4, 560, 348, 32, text33)
  self.contents.draw_text(4, 576, 348, 32, text34)
  self.contents.draw_text(4, 592, 348, 32, text35)
  self.contents.draw_text(4, 608, 348, 32, text36)
  self.contents.draw_text(310, 640, 348, 32, text37)
  self.contents.draw_text(310, 656, 348, 32, text38)
  self.contents.draw_text(4, 672, 348, 32, text39)
  self.contents.draw_text(4, 688, 348, 32, text40)
  self.contents.draw_text(4, 704, 348, 32, text41)
  self.contents.draw_text(4, 720, 348, 32, text42)
  self.contents.draw_text(4, 736, 348, 32, text43)
  self.contents.draw_text(4, 752, 348, 32, text44)
  self.contents.draw_text(4, 768, 348, 32, text45)
  self.contents.draw_text(4, 800, 348, 32, text46)
  self.contents.draw_text(4, 816, 348, 32, text47)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(214, 848, 348, 32, text48)
  self.contents.font.color = normal_color
  self.contents.draw_text(214, 864, 348, 32, text49)
  self.contents.draw_text(214, 880, 348, 32, text50)
  self.contents.draw_text(214, 896, 348, 32, text51)
  self.contents.draw_text(4, 912, 348, 32, text52)
  self.contents.draw_text(4, 928, 348, 32, text53)
  self.contents.draw_text(4, 944, 348, 32, text54)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(214, 976, 348, 32, text55)
  self.contents.font.color = normal_color
  self.contents.draw_text(214, 992, 348, 32, text56)
  self.contents.draw_text(214, 1008, 348, 32, text57)
  self.contents.draw_text(214, 1024, 348, 32, text58)
  self.contents.draw_text(4, 1040, 348, 32, text59)
  self.contents.font.color = Color.new(255, 255, 0, 255)
  self.contents.draw_text(214, 1072, 348, 32, text60)
  self.contents.font.color = normal_color
  self.contents.draw_text(214, 1088, 348, 32, text61)
  self.contents.draw_text(214, 1104, 348, 32, text62)
  self.contents.draw_text(214, 1120, 348, 32, text63)
  self.contents.draw_text(4, 1136, 348, 32, text64)
  self.contents.draw_text(4, 1152, 348, 32, text65)
  self.contents.draw_text(4, 1168, 348, 32, text66)
end
# ----------------------------
def draw_lines
  rect = Rect.new(4, 30, 352, 1)
  self.contents.fill_rect(rect, normal_color)
end
# ----------------------------
end
