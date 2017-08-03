class Interpreter
# --------------------------
def long_choice
  s1 = ""
  s2 = ""
  s3 = ""
  s4 = ""
  @list[@index].parameters[0] = []
  case @longchoice
  when 1
    s1 = "There is an element of risk in free societies."
    s2 = "Well, sometimes grim reality can't be helped."
  when 2
    s1 = "You sound like a cheesy women's magazine."
    s2 = "I meditate right after my step-aerobics class."
    s3 = "There are already too many heads in the clouds."
  when 3
    s1 = "Why trifle with tradition?  Rock on, hand-tossed!"
    s2 = "Only deep-dish has the requisite density."
  when 4
    s1 = "Minor transgressions may be forgiven."
    s2 = "A formalized monitoring protocol will be required."
    s3 = "Your dry analysis conceals your depravity."
  when 5
    s1 = "Is that an electron spectrography model?"
    s2 = "There are only so many seconds in a day."
  when 6
    s1 = "Are you sure you don't mean \'dyad of the hour\'?"
    s2 = "Be sure and invite me to the wedding."
  when 7
    s1 = "Being a fugitive from the fashion police is sexy!"
    s2 = "Stones...glass houses.  You know the drill."
  when 8
    s1 = "Such a smooth talker.  Are you hitting on me?"
    s2 = "(Slap him in the face...hard)"
  when 9
    s1 = "I apologize for my breach of decorum earlier."
    s2 = "I need a little more time to reconsider."
  when 10
    s1 = "Politics and politicians enjoy an uneasy symbiosis."
    s2 = "Many negotiations can be truly harrowing."
    s3 = "I must seperate my essence from my occupation."
  when 11
    s1 = "The Ascension War is a confounding variable."
    s2 = "If you always fear death, aren't you already dead?"
  when 12
    s1 = "Berrtram is Xaulmari.  Don't you hate him?"
    s2 = "Sea-lions?"
  when 13
    s1 = "I suppose Boundless Acumen is being...prudent."
    s2 = "Can't someone else assume my duties this time?"
  when 14
    s1 = "This sounds like a worthwhile lecture."
    s2 = "\'Sucker Interfaces\'?  I'm not a sucker!"
  when 15
    s1 = "Some sparring will help me overcome adversity."
    s2 = "I am secure in my innate competence."
  when 16
    s1 = "Symptom recognition."
    s2 = "General etiological categories."
    s3 = "Maladies, prognoses, and remedies."
    s4 = "I don't need anymore information."
  when 17
    s1 = "Let me take command of my future."
    s2 = "I already have command of this information."
  when 18
    s1 = "Lay that textual avalanche on me."
    s2 = "Experience is the best teacher."
  when 19
    s1 = "Your youth excuses your pessimism."
    s2 = "Your youth belies your wisdom."
  when 20
    s1 = "Tell me about the war."
    s2 = "Kravit was militarily involved in the war?"
    s3 = "How does a war hero end up here?"
    s4 = "Your burden is heavy enough."
  when 21
    s1 = "Was there a discrete causal agent?"
    s2 = "What kind of tactics were used?"
    s3 = "What brought about the armistice?"
    s4 = "Have steps been taken to prevent recurrence?"
  when 22
    s1 = "Yeah, it sucks, but why are you up?"
    s2 = "Is anything unusual going on outside?"
    s3 = "(I forgot what a \'Class II Citizen\' is.)"
  when 23
    s1 = "Yeah, it sucks, but why are you up?"
    s2 = "Is anything unusual going on outside?"
    s3 = "(I forgot what a \'Class II Citizen\' is.)"
    s4 = "(Gilad is a really funny name.)"
  when 24
    s1 = "You expected smugglers to be fastidious?"
    s2 = "Nope.  It's just your olfactory receptors."
  when 25
    s1 = "I will relay the message to Parmington."
    s2 = "Petulance does not engender compliance."
  when 26
    s1 = "The smugglers relayed a demand..."
    s2 = "It wouldn't have been had you paid your debts!"
    s3 = "I experienced no difficulty in the transaction."
  when 27
    s1 = "It seems to be a fait accompli."
    s2 = "...And if I fail to comply with your demands?"
    s3 = "(Attempt to fight your way out of this situation.)"
  when 28
    s1 = "Reciprocity and Realpolitik go hand in hand."
    s2 = "I will need your tutelage as to the methodology."
    s3 = "Are you nuts?!  Kravit has capital punishment!"
  when 29
    s1 = "My autonomy has been compromised..."
    s2 = "I can't divulge information about those events."
  when 30
    s1 = "What is that song you're singing?"
    s2 = "Does singing that help you sleep at night?"
    s3 = "You're two octaves off-key."
    s4 = "... ... ..."
  when 31
    s1 = "I am prepared to depart on your order."
    s2 = "I need additional time to gather supplies."
  when 32
    s1 = ".....Maybe my initial impression of you was faulty."
    s2 = "That's the thing about deception..."
  when 33
    s1 = "...Why not execute a coup d'etat?"
    s2 = "...Why not assassinate Prime Minister Alfarius?"
  when 34
    s1 = "Before leaving Beckweth, the chief asked me to..."
    s2 = "I remain ambivalent."
  when 35
    s1 = "I am Syeull from Beckweth village."
    s2 = "My name is Syeull, and don't you forget it!"
  when 36
    s1 = "Historiographers hate \'soundbite interpretation\'."
    s2 = "Even an invertebrate can espouse lofty ideals."
  when 37
    s1 = "Ehlison's prosperity will ultimately benefit Kravit."
    s2 = "An unidentified subsidy?  Sounds enthralling!"
    s3 = "Why should I carry out such a mission?"
  when 38
    s1 = "Have you tried negotiating with them?"
    s2 = "Do they have an exploitable superordinate goal?"
    s3 = "Force is the lingua franca among those types."
  when 39
    s1 = "A mentally-ill companion would be a burden."
    s2 = "Are you sticking me with the dregs?"
  when 40
    s1 = "People will eventually demand a general election."
    s2 = "Isn't it just a hiccup in the business cycle?"
    s3 = "Macroshaping vitalizes related industries."
  when 41
    s1 = "I wish I could crochet with the same aptitude."
    s2 = "Beautiful crochet on a not-so-beautiful model..."
  when 42
    s1 = "Tell me about the Radiating Coverage Model."
    s2 = "How can I optimize my item consumption?"
    s3 = "I don't need to know anything else."
  when 43
    s1 = "Tell me about the Radiating Coverage Model."
    s2 = "How can I optimize my item consumption?"
    s3 = "How can I maximize the effectiveness of filching?"
    s4 = "I don't need to know anything else."
  when 44
    s1 = "Interesting business model.  Where do I sign up?"
    s2 = "Wouldn't reactivity influence the outcome?"
  when 45
    s1 = "Allow me to try and talk to him."
    s2 = "Will such an episode extinguish on its own?"
    s3 = "We can subdue him with an arc formation."
    s4 = "I'll leave this to the professionals."
  when 46
    s1 = "Doing so would be a worthwhile exercise."
    s2 = "That would be an exercise in futility."
  when 47
    s1 = "Angel or not, she may possess vital knowledge."
    s2 = "Our highest priority is our primary mission."
  when 48
    s1 = "You shouldn't be so eager to write him off."
    s2 = "If he's been afflicted for this length of time..."
  when 49
    s1 = "Your antics have cost millions of Yk in commerce."
    s2 = "Your antics have endangered countless lives."
    s3 = "Don't you have any respect for property rights?"
    s4 = "You're poisoning young minds with your dogma."
  when 50
    s1 = "...Suggesting an economic summit."
    s2 = "...Holding public town meetings."
    s3 = "...Declaring a temporary cease-fire."
    s4 = "...Making a few concessions on key points."
  when 51
    s1 = "...surrender unconditionally"
    s2 = "...voluntarily vacate the premises."
    s3 = "...use the teleporter to go into self-imposed exile."
  when 52
    s1 = "...compressing your cranial cavity."
    s2 = "...incapcitating you with non-lethal techniques."
    s3 = "...throwing you off the side of the tower."
    s4 = "...Slashing your entrails with a symphony of slices."
  when 53
    s1 = "A gilded cage is still a cage."
    s2 = "Fighting one's conscience is a losing proposition."
  when 54
    s1 = "I'm ready to put this plan into action."
    s2 = "I want to save my progress."
    s3 = "Did you hear any information that could assist us?"
    s4 = "I need more time to prepare for departure."
  when 55
    s1 = "I suppose the Commandant is venerated in a way."
    s2 = "The Echelon fills an important sociopolitical niche."
    s3 = "Thought reform is transparent to its victims."
    s4 = "Echelon Hegemony!"
  when 56
    s1 = "Have you heard about a new coagulant?"
    s2 = "Is there any medicine stored on the premesis?"
  when 57
    s1 = "Uh...Thanks, I think..."
    s2 = "Why admire me when you can become a lawyer?"
    s3 = "The judge denied the motion, remember?"
  when 58
    s1 = "You didn't say \'Echelon Hegemony!\'"
    s2 = "(Say nothing)"
  when 59
    s1 = "Civil Justice: Administrative Summary."
    s2 = "Criminal Justice: Administrative Summary."
    s3 = "Addendum: Shaping Abilities for Attornies."
    s4 = "I require no more information."
  when 60
    s1 = "Who is this second-year resident?"
    s2 = "Ehhh, Protocol demands that I not inquire further."
  when 61
    s1 = "Indulging emotion at this juncture is unproductive."
    s2 = "We rejected emotional facades with the Echelon..."
  when 62
    s1 = "You got me.  I'm into cheese graters."
    s2 = "I like chests, but now, it's about justice."
  when 63
    s1 = "When you put it that way, how can I refuse?"
    s2 = "I'll keep my urban-dweller credentials."
  when 64
    s1 = "Are you seeking anything specific?"
    s2 = "Doesn't solo exploration pose a threat?"
  when 65
    s1 = "Impart to me this well-kept secret of longevity."
    s2 = "I don't have the ability \"Tolerate Boring Lectures\"."
  when 66
    s1 = "My recall of some of the minutiae is shaky."
    s2 = "Not necessary.  I have an eidetic memory."
  when 67
    s1 = "What illicit operations did the Echelon conduct?"
    s2 = "Qualified immunity doesn't equal carte blanche."
    s3 = "The Echelon has a hand in judicial appointments..."
  when 68
    s1 = "Why invest so heavily in foreign markets?"
    s2 = "Have you become more risk-averse for a reason?"
  when 69
    s1 = "Try giving the disheaveled man the cipher."
    s2 = "Vacate the premesis as he requests."
  when 70
    s1 = "We're ex-Echelon and could use assistance."
    s2 = "I heard there was an activist organization here."
    s3 = "It would be better to not advertise this fact."
  when 71
    s1 = "I'm assistant district attorney Rhiaz."
    s2 = "I'll invest in some remedial slum culture lessons."
  when 72
    s1 = "I think it will be a renewing experience."
    s2 = "The choice of vista needs renewing."
  when 73
    s1 = "Allocate additional funds to public education."
    s2 = "Privatize the education system."
    s3 = "Require educators to have additional credentials."
    s4 = "Your initial premise is unsupported."
  when 74
    s1 = "Read Conservative Party Platform."
    s2 = "Make Political Contribution."
    s3 = "See Contribution Status."
    s4 = "Nothing."
  when 75
    s1 = "Read Modern Reformist Platform."
    s2 = "Make Political Contribution."
    s3 = "See Contribution Status."
    s4 = "Nothing."
  when 76
    s1 = "Read Progressive Party Platform."
    s2 = "Make Political Contribution."
    s3 = "See Contribution Status."
    s4 = "Nothing."
  when 77
    s1 = "Read Socialist Party Platform."
    s2 = "Make Political Contribution."
    s3 = "See Contribution Status."
    s4 = "Nothing."
  when 78
    s1 = "So, it's a semi-covert thought reform initiative."
    s2 = "The early bird gets the electorate, I suppose."
  when 79
    s1 = "Where are these headquarters located?"
    s2 = "Inevitable segregation?  Sounds fatalistic."
  when 80
    s1 = "Progressive Party Headquarters."
    s2 = "Socialist Party Headquarters."
    s3 = "Modern Reformist Party Headquarters."
    s4 = "Conservative Party Headquarters."
  when 81
    s1 = "You have mistaken me for another individual."
    s2 = "When applying, you didn't fill out form 1163..."
  when 82
    s1 = "I will relinquish it in service of the greater good."
    s2 = "I require it for my own purposes."
  when 83
    s1 = "The complexities of litigation are vexing."
    s2 = "I learned all of that in law school."
  when 84
    s1 = "I need to transact additional business in Jacardi."
    s2 = "The geopolitical situation cannot wait."
  when 85
    s1 = "...The greater density of the gas will push it down."
    s2 = "...There must be obstructed ventilation ducts."
  when 86
    s1 = "We intend to scavenge the area for valuables."
    s2 = "We're infiltrating the Specterragon facility."
  end
  if s1 != ""
    @list[@index].parameters[0][0] = s1
  end
  if s2 != ""
    @list[@index].parameters[0][1] = s2
  end
  if s3 != ""
    @list[@index].parameters[0][2] = s3
  end
  if s4 != ""
    @list[@index].parameters[0][3] = s4
  end
  @longchoice = 0
end
# --------------------------
end