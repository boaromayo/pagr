class Window_TutorialData < Window_Base
# ----------------------------
def show_tut6
  ability_img = Bitmap.new("Graphics/Stuff/tut08.png")
  conditional_img =  Bitmap.new("Graphics/Stuff/tut09.png")
  combo_img =  Bitmap.new("Graphics/Stuff/tut10.png")
  no1_img = RPG::Cache.icon("label01")
  no2_img = RPG::Cache.icon("label02")
  self.contents.font.size = 16
  text1 = "Nepthe learns new skills using the Fractured Cognition"
  text2 = "System.  Each Shaping Ability Nepthe learns is assigned"
  text3 = "one of four neurotransmitter types: Seretonin, Dopamine,"
  text4 = "Norepinephrine, or Aspartate.  By using skills of a"
  text5 = "certain type, Nepthe can learn skills of that type more"
  text6 = "quickly, provided Schizo Combos are used judiciously."
  text7 = "The amount of NT "
  text8 = "(neurotransmitters)"
  text9 = "required to gain"
  text10 = "a new skill of"
  text11 = "that type is shown"
  text12 = "in the upper-left"
  text13 = "corner of Nepthe's"
  text14 = "ability screen."
  text15 = "When a new skill"
  text16 = "is learned, a message to that effect will appear at the"
  text17 = "end of battle.  There are some skills that require multiple"
  text18 = "types of NT to learn.  The requirements to learn these"
  text19 = "skills are not shown."
  text20 = "After each"
  text21 = "battle, you"
  text22 = "will gain"
  text23 = "at least a"
  text24 = "certain"
  text25 = "number of"
  text26 = "NT for each"
  text27 = "of the four neurotransmitter types.  By using Schizo"
  text28 = "Combos, you can increase the amount of NT gained.  On"
  text29 = "Nepthe's ability screen, a set of conditions is"
  text30 = "displayed under the word \"Schizoconditionals\".  If you"
  text31 = "satisfy at least two of those conditions when Nepthe uses"
  text32 = "a Shaping Ability, a Schizo Combo will be formed.  For"
  text33 = "each of the four neurotransmitter types, you will gain"
  text34 = "an amount of NT equal to either the minimum value or"
  text35 = "the highest combo you made using a Shaping ability of that"
  text36 = "type, whichever is higher."
  text37 = "Whenever a Schizo"
  text38 = "Combo is formed,"
  text39 = "the information"
  text40 = "shown in the picture"
  text41 = "at left is shown."
  text42 = "The two parts of"
  text43 = "the picture are"
  text44 = "explained below:"
  text45 = "The number of synapses in the combo.  This will"
  text46 = "be higher if you satisfy more Schizoconditionals."
  text47 = "If you get a large combo, special effects such"
  text48 = "as \"FT Cost Zero\", which makes the Shaping"
  text49 = "Ability cost no FT, or \"Status Strike\", which adds"
  text50 = "a status effect to an ability that targets one or more"
  text51 = "enemies, can be added to the Shaping Ability."
  text52 = "There are a total of 20 different effects in all, each"
  text53 = "with a different minimum synapse requirement and"
  text54 = "probability of appearing."
  text55 = "Nepthe cannot use physical attacks, so optimizing Nepthe's"
  text56 = "performance requires frequent use of Schizo Combos."
  self.contents.blt(6, 125, ability_img, Rect.new(0, 0, 210, 132))
  self.contents.blt(6, 350, conditional_img, Rect.new(0, 0, 250, 96))
  self.contents.blt(5, 636, combo_img, Rect.new(0, 0, 200, 136))
  self.contents.blt(6, 796, no1_img, Rect.new(0, 0, 24, 24))
  self.contents.blt(6, 892, no2_img, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(4, 32, 348, 32, text3)
  self.contents.draw_text(4, 48, 348, 32, text4)
  self.contents.draw_text(4, 64, 348, 32, text5)
  self.contents.draw_text(4, 80, 348, 32, text6)
  self.contents.draw_text(230, 112, 348, 32, text7)
  self.contents.draw_text(230, 128, 348, 32, text8)
  self.contents.draw_text(230, 144, 348, 32, text9)
  self.contents.draw_text(230, 160, 348, 32, text10)
  self.contents.draw_text(230, 176, 348, 32, text11)
  self.contents.draw_text(230, 192, 348, 32, text12)
  self.contents.draw_text(230, 208, 348, 32, text13)
  self.contents.draw_text(230, 224, 348, 32, text14)
  self.contents.draw_text(230, 240, 348, 32, text15)
  self.contents.draw_text(4, 256, 348, 32, text16)
  self.contents.draw_text(4, 272, 348, 32, text17)
  self.contents.draw_text(4, 288, 348, 32, text18)
  self.contents.draw_text(4, 304, 348, 32, text19)
  self.contents.draw_text(270, 336, 348, 32, text20)
  self.contents.draw_text(270, 352, 348, 32, text21)
  self.contents.draw_text(270, 368, 348, 32, text22)
  self.contents.draw_text(270, 384, 348, 32, text23)
  self.contents.draw_text(270, 400, 348, 32, text24)
  self.contents.draw_text(270, 416, 348, 32, text25)
  self.contents.draw_text(270, 432, 348, 32, text26)
  self.contents.draw_text(4, 448, 348, 32, text27)
  self.contents.draw_text(4, 464, 348, 32, text28)
  self.contents.draw_text(4, 480, 348, 32, text29)
  self.contents.draw_text(4, 496, 348, 32, text30)
  self.contents.draw_text(4, 512, 348, 32, text31)
  self.contents.draw_text(4, 528, 348, 32, text32)
  self.contents.draw_text(4, 544, 348, 32, text33)
  self.contents.draw_text(4, 560, 348, 32, text34)
  self.contents.draw_text(4, 576, 348, 32, text35)
  self.contents.draw_text(4, 592, 348, 32, text36)
  self.contents.draw_text(220, 632, 348, 32, text37)
  self.contents.draw_text(220, 648, 348, 32, text38)
  self.contents.draw_text(220, 664, 348, 32, text39)
  self.contents.draw_text(220, 680, 348, 32, text40)
  self.contents.draw_text(220, 696, 348, 32, text41)
  self.contents.draw_text(220, 712, 348, 32, text42)
  self.contents.draw_text(220, 728, 348, 32, text43)
  self.contents.draw_text(220, 744, 348, 32, text44)
  self.contents.draw_text(40, 784, 348, 32, text45)
  self.contents.draw_text(40, 800, 348, 32, text46)
  self.contents.draw_text(40, 832, 348, 32, text47)
  self.contents.draw_text(40, 848, 348, 32, text48)
  self.contents.draw_text(40, 864, 348, 32, text49)
  self.contents.draw_text(40, 880, 348, 32, text50)
  self.contents.draw_text(40, 896, 348, 32, text51)
  self.contents.draw_text(40, 912, 348, 32, text52)
  self.contents.draw_text(40, 928, 348, 32, text53)
  self.contents.draw_text(40, 944, 348, 32, text54)
  self.contents.draw_text(4, 976, 348, 32, text55)
  self.contents.draw_text(4, 992, 348, 32, text56)
end
# ----------------------------
def show_tut7
  ability_img = Bitmap.new("Graphics/Stuff/tut11.png")
  vector_img =  Bitmap.new("Graphics/Stuff/tut12.png")
  item_img =  Bitmap.new("Graphics/Stuff/tut13.png")
  book_icon = RPG::Cache.icon("misc09")
  self.contents.font.size = 16
  text1 = "Auto-"
  text2 = "abilities" 
  text3 = "are"
  text4 = "those"
  text5 = "abilities that either remain in effect continuously or trigger"
  text6 = "without intervention by the player upon the satisfaction"
  text7 = "of certain conditions.  For example, the ability"
  text8 = "\"Dexterity+10%\" shown in the picture above raises the"
  text9 = "character's dexterity stat by 10% as long as it is equipped."
  text10 = "You'll notice that in the picture above, the name of the"
  text11 = "ability is accompanied by a number.  This number is"
  text12 = "the cost to equip the skill in Acumen Vectors."
  text13 = "Acumen Vectors"
  text14 = "express the"
  text15 = "degree of inter-"
  text16 = "connectedness of"
  text17 = "a person's"
  text18 = "neuropathways."
  text19 = "The greater the number of Acumen Vectors, the greater"
  text20 = "the number and potency of auto-abilities that can be"
  text21 = "equipped simultaneously.  The picture above shows the"
  text22 = "Acumen Vector window that will appear when you navigate"
  text23 = "to the auto-ability section of a character's Shaping"
  text24 = "menu.  The left number shows the number of free"
  text25 = "Acumen Vectors, while the right number shows the"
  text26 = "total number of Acumen Vectors.  When an ability is"
  text27 = "equipped, the number of Acumen Vectors shown are"
  text28 = "consumed.  When the ability is unequipped, the Vectors"
  text29 = "are freed."
  text30 = "There are two"
  text31 = "ways in which"
  text32 = "a character"
  text33 = "can learn auto-abilities.  The first method is by"
  text34 = "utilizing their unique development system.  Some"
  text35 = "auto-abilities will be learned in the course of normal"
  text36 = "development.  The second method is to find various"
  text37 = "treatises (     ).  By reading a treatise, a character can"
  text38 = "learn the ability it describes.  Most abilities contained in"
  text39 = "treatises have prerequisite stats that must be satisfied"
  text40 = "before the character can learn the ability."
  text41 = "You will gain one Acumen Vector per five levels gained."
  text42 = "Otherwise, Acumen Vectors must be earned in the course"
  text43 = "of normal development.  If you comb the countryside,"
  text44 = "you may find a treatise that can raise Acumen Vectors!"
  self.contents.blt(6, 14, ability_img, Rect.new(0, 0, 310, 54))
  self.contents.blt(6, 230, vector_img, Rect.new(0, 0, 244, 102))
  self.contents.blt(6, 522, item_img, Rect.new(0, 0, 254, 49))
  self.contents.blt(60, 628, book_icon, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(310, 0, 348, 32, text1)
  self.contents.draw_text(310, 16, 348, 32, text2)
  self.contents.draw_text(310, 32, 348, 32, text3)
  self.contents.draw_text(310, 48, 348, 32, text4)
  self.contents.draw_text(4, 64, 348, 32, text5)
  self.contents.draw_text(4, 80, 348, 32, text6)
  self.contents.draw_text(4, 96, 348, 32, text7)
  self.contents.draw_text(4, 112, 348, 32, text8)
  self.contents.draw_text(4, 128, 348, 32, text9)
  self.contents.draw_text(4, 160, 348, 32, text10)
  self.contents.draw_text(4, 176, 348, 32, text11)
  self.contents.draw_text(4, 192, 348, 32, text12)
  self.contents.draw_text(248, 224, 348, 32, text13)
  self.contents.draw_text(248, 240, 348, 32, text14)
  self.contents.draw_text(248, 256, 348, 32, text15)
  self.contents.draw_text(248, 272, 348, 32, text16)
  self.contents.draw_text(248, 288, 348, 32, text17)
  self.contents.draw_text(248, 304, 348, 32, text18)
  self.contents.draw_text(4, 320, 348, 32, text19)
  self.contents.draw_text(4, 336, 348, 32, text20)
  self.contents.draw_text(4, 352, 348, 32, text21)
  self.contents.draw_text(4, 368, 348, 32, text22)
  self.contents.draw_text(4, 384, 348, 32, text23)
  self.contents.draw_text(4, 400, 348, 32, text24)
  self.contents.draw_text(4, 416, 348, 32, text25)
  self.contents.draw_text(4, 432, 348, 32, text26)
  self.contents.draw_text(4, 448, 348, 32, text27)
  self.contents.draw_text(4, 464, 348, 32, text28)
  self.contents.draw_text(4, 480, 348, 32, text29)
  self.contents.draw_text(256, 512, 348, 32, text30)
  self.contents.draw_text(256, 528, 348, 32, text31)
  self.contents.draw_text(256, 544, 348, 32, text32)
  self.contents.draw_text(4, 560, 348, 32, text33)
  self.contents.draw_text(4, 576, 348, 32, text34)
  self.contents.draw_text(4, 592, 348, 32, text35)
  self.contents.draw_text(4, 608, 348, 32, text36)
  self.contents.draw_text(4, 624, 348, 32, text37)
  self.contents.draw_text(4, 640, 348, 32, text38)
  self.contents.draw_text(4, 656, 348, 32, text39)
  self.contents.draw_text(4, 672, 348, 32, text40)
  self.contents.draw_text(4, 704, 348, 32, text41)
  self.contents.draw_text(4, 720, 348, 32, text42)
  self.contents.draw_text(4, 736, 348, 32, text43)
  self.contents.draw_text(4, 752, 348, 32, text44)
end
# ----------------------------
def show_tut8
  c_button_img = RPG::Cache.icon("talk05")
  menu_img = Bitmap.new("Graphics/Stuff/tut14.png")
  facts_img = Bitmap.new("Graphics/Stuff/tut15.png")
  stats_img =  Bitmap.new("Graphics/Stuff/tut16.png")
  self.contents.font.size = 16
  text1 = "The Simplified Adversarial Development System (SADS)"
  text2 = "allows Rhiaz to unlock his true Shaping potential" 
  text3 = "in the course of conducting litigation."
  text4 = "When a secondary"
  text5 = "menu is not being"
  text6 = "displayed, three"
  text7 = "important stats are"
  text8 = "displayed."
  text9a = "Legal Skill:"
  text9b = "This represents Rhiaz's proficiency in the"
  text10 = "art of litigation.  Rhiaz can gain legal experience"
  text11 = "in two ways.  The primary method of gaining legal"
  text12 = "experience is by uncovering information relevant to"
  text13 = "the case.  His legal skill will also rise somewhat as"
  text14 = "his level increases."
  text15a = "Case Evaluation:"
  text15b = "The estimated strength of Rhiaz's case"
  text16 = "based on the currently-constructed argument."
  text17 = "Constructing a particularly persuasive argument may"
  text18 = "allow Rhiaz to learn a new ability."
  text19a = "Resolving Action:"
  text19b = "The currently resolving Law Action."
  text20 = "Law Actions allow Rhiaz to develop his case in"
  text21 = "various ways.  At Legal Skill Level 1, \"Prepare"
  text22 = "Case\" is the only action available to Rhiaz."
  text23 = "As his Legal Skill rises, additional actions will"
  text24 = "become available."
  text25 = "Legal actions are initiated"
  text26 = "from the menu shown at left."
  text27 = "The available commands"
  text28 = "depend on Rhiaz's Legal"
  text29 = "Skill Level.  When selected,"
  text30 = "each command opens a secondary"
  text31 = "menu containing some subset"
  text32 = "of the information Rhiaz"
  text33 = "has collected so far."
  text34 = "Since \"Facts\" is the only"
  text35 = "command available at Legal"
  text36 = "Skill level 1, it will be"
  text37 = "used as an example."
  text38 = "When the \"Facts\""
  text39 = "menu is opened, a"
  text40 = "color-coded list of"
  text41 = "all facts Rhiaz has"
  text42 = "gathered."
  text43 = "The colors shown"
  text44 = "correspond to each"
  text45 = "fact's state of"
  text46 = "inclusion in Rhiaz's argument."
  text47a = "White:"
  text47b = "The fact is not included in Rhiaz's argument."
  text48a = "Yellow:"
  text48b = "The fact is included in Rhiaz's argument."
  text49a = "Aqua:"
  text49b = "Rhiaz is preparing to include the fact in his"
  text49c = "argument."
  text50a = "Red:"
  text50b = "Rhiaz is preparing to exclude the fact from his"
  text50c = "argument."
  text51a = "If no Law Action is resolving, you can press "
  text51b = "to toggle"
  text52 = "facts in and out of Rhiaz's argument.  If the new"
  text53 = "configuration of facts differs from the present"
  text54 = "argument, you will be asked to confirm that you wish to"
  text55 = "use a law action to reorganize your case."
  text56 = "Law actions take time to resolve.  When a law action"
  text57 = "has finished resolving, you will be notified both"
  text58 = "audibly and visually.  When you next access Rhiaz's"
  text59 = "screen, you may be notified of changes the action"
  text60 = "produced.  Some law actions can fail."
  self.contents.blt(4, 72, stats_img, Rect.new(0, 0, 200, 85))
  self.contents.blt(4, 472, menu_img, Rect.new(0, 0, 160, 318))
  self.contents.blt(64, 682, facts_img, Rect.new(0, 0, 160, 128))
  self.contents.blt(256, 996, c_button_img, Rect.new(0, 0, 24, 24))
  self.contents.draw_text(4, 0, 348, 32, text1)
  self.contents.draw_text(4, 16, 348, 32, text2)
  self.contents.draw_text(4, 32, 348, 32, text3)
  self.contents.draw_text(214, 64, 348, 32, text4)
  self.contents.draw_text(214, 80, 348, 32, text5)
  self.contents.draw_text(214, 96, 348, 32, text6)
  self.contents.draw_text(214, 112, 348, 32, text7)
  self.contents.draw_text(214, 128, 348, 32, text8)
  self.contents.font.color = Color.new(255, 255, 0)
  self.contents.draw_text(4, 160, 348, 32, text9a)
  self.contents.font.color = normal_color
  self.contents.draw_text(72, 160, 348, 32, text9b)
  self.contents.draw_text(4, 176, 348, 32, text10)
  self.contents.draw_text(4, 192, 348, 32, text11)
  self.contents.draw_text(4, 208, 348, 32, text12)
  self.contents.draw_text(4, 224, 348, 32, text13)
  self.contents.draw_text(4, 240, 348, 32, text14)
  self.contents.font.color = Color.new(255, 255, 0)
  self.contents.draw_text(4, 272, 348, 32, text15a)
  self.contents.font.color = normal_color
  self.contents.draw_text(106, 272, 348, 32, text15b)
  self.contents.draw_text(4, 288, 348, 32, text16)
  self.contents.draw_text(4, 304, 348, 32, text17)
  self.contents.draw_text(4, 320, 348, 32, text18)
  self.contents.font.color = Color.new(255, 255, 0)
  self.contents.draw_text(4, 352, 348, 32, text19a)
  self.contents.font.color = normal_color
  self.contents.draw_text(108, 352, 348, 32, text19b)
  self.contents.draw_text(4, 368, 348, 32, text20)
  self.contents.draw_text(4, 384, 348, 32, text21)
  self.contents.draw_text(4, 400, 348, 32, text22)
  self.contents.draw_text(4, 416, 348, 32, text23)
  self.contents.draw_text(4, 432, 348, 32, text24)
  self.contents.draw_text(176, 464, 348, 32, text25)
  self.contents.draw_text(176, 480, 348, 32, text26)
  self.contents.draw_text(176, 496, 348, 32, text27)
  self.contents.draw_text(176, 512, 348, 32, text28)
  self.contents.draw_text(176, 528, 348, 32, text29)
  self.contents.draw_text(176, 544, 348, 32, text30)
  self.contents.draw_text(176, 560, 348, 32, text31)
  self.contents.draw_text(176, 576, 348, 32, text32)
  self.contents.draw_text(176, 592, 348, 32, text33)
  self.contents.draw_text(176, 608, 348, 32, text34)
  self.contents.draw_text(176, 624, 348, 32, text35)
  self.contents.draw_text(176, 640, 348, 32, text36)
  self.contents.draw_text(176, 656, 348, 32, text37)
  self.contents.draw_text(236, 672, 348, 32, text38)
  self.contents.draw_text(236, 688, 348, 32, text39)
  self.contents.draw_text(236, 704, 348, 32, text40)
  self.contents.draw_text(236, 720, 348, 32, text41)
  self.contents.draw_text(236, 736, 348, 32, text42)
  self.contents.draw_text(236, 752, 348, 32, text43)
  self.contents.draw_text(236, 768, 348, 32, text44)
  self.contents.draw_text(236, 784, 348, 32, text45)
  self.contents.draw_text(4, 800, 348, 32, text46)
  self.contents.draw_text(4, 832, 348, 32, text47a)
  self.contents.draw_text(60, 832, 348, 32, text47b)
  self.contents.font.color = Color.new(255, 255, 0)
  self.contents.draw_text(4, 864, 348, 32, text48a)
  self.contents.font.color = normal_color
  self.contents.draw_text(60, 864, 348, 32, text48b)
  self.contents.font.color = Color.new(49, 255, 160)
  self.contents.draw_text(4, 896, 348, 32, text49a)
  self.contents.font.color = normal_color
  self.contents.draw_text(60, 896, 348, 32, text49b)
  self.contents.draw_text(60, 912, 348, 32, text49c)
  self.contents.font.color = Color.new(255, 0, 136)
  self.contents.draw_text(4, 944, 348, 32, text50a)
  self.contents.font.color = normal_color
  self.contents.draw_text(60, 944, 348, 32, text50b)
  self.contents.draw_text(60, 960, 348, 32, text50c)
  self.contents.draw_text(4, 992, 348, 32, text51a)
  self.contents.draw_text(282, 992, 348, 32, text51b)
  self.contents.draw_text(4, 1008, 348, 32, text52)
  self.contents.draw_text(4, 1024, 348, 32, text53)
  self.contents.draw_text(4, 1040, 348, 32, text54)
  self.contents.draw_text(4, 1056, 348, 32, text55)
  self.contents.draw_text(4, 1088, 348, 32, text56)
  self.contents.draw_text(4, 1104, 348, 32, text57)
  self.contents.draw_text(4, 1120, 348, 32, text58)
  self.contents.draw_text(4, 1136, 348, 32, text59)
  self.contents.draw_text(4, 1152, 348, 32, text60)
end
# ----------------------------
end
