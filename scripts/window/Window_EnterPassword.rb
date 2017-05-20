class Window_EnterPassword < Window_Base
  # ----------------------------------
  attr_accessor :mode
  # ----------------------------------
  ENGLISH_TABLE =
  [
    "A","B","C","D","E",
    "F","G","H","I","J",
    "K","L","M","N","O",
    "P","Q","R","S","T",
    "U","V","W","X","Y",
    "Z","","","","",
    "0","1","2","3","4",
    "5", "6" ,"7", "8" ,"9",
    "","","","","",
    "a", "b" ,"c", "d" ,"e",
    "f","g","h","i","j",
    "k","l","m","n","o",
    "p","q","r","s","t",
    "u","v","w","x","y",
    "z","","","","",
    ".",",","?","!","/",
    "\\","<",">",";",":",
    "","", "" , "" , "" ,
    "@","#","$","%","^",
    "&","*","(",")","",
    "[","]","'","\"","~",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "", "" ,"", "" ,"",
    "","","","","",
  ]
  HIRAGANA_TABLE =
  [
    "あ","い","う","え","お",
    "か","き","く","け","こ",
    "さ","し","す","せ","そ",
    "た","ち","つ","て","と",
    "な","に","ぬ","ね","の",
    "は","ひ","ふ","へ","ほ",
    "ま","み","む","め","も",
    "や", "" ,"ゆ", "" ,"よ",
    "ら","り","る","れ","ろ",
    "わ", "" ,"を", "" ,"ん",
    "が","ぎ","ぐ","げ","ご",
    "ざ","じ","ず","ぜ","ぞ",
    "だ","ぢ","づ","で","ど",
    "ば","び","ぶ","べ","ぼ",
    "ぱ","ぴ","ぷ","ぺ","ぽ",
    "ゃ","ゅ","ょ","っ","ゎ",
    "ぁ","ぃ","ぅ","ぇ","ぉ",
    "ー","・", "" , "" , "" ,
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
  ]
  KATAKANA_TABLE =
  [
    "ア","イ","ウ","エ","オ",
    "カ","キ","ク","ケ","コ",
    "サ","シ","ス","セ","ソ",
    "タ","チ","ツ","テ","ト",
    "ナ","ニ","ヌ","ネ","ノ",
    "ハ","ヒ","フ","ヘ","ホ",
    "マ","ミ","ム","メ","モ",
    "ヤ", "" ,"ユ", "" ,"ヨ",
    "ラ","リ","ル","レ","ロ",
    "ワ", "" ,"ヲ", "" ,"ン",
    "ガ","ギ","グ","ゲ","ゴ",
    "ザ","ジ","ズ","ゼ","ゾ",
    "ダ","ヂ","ヅ","デ","ド",
    "バ","ビ","ブ","ベ","ボ",
    "パ","ピ","プ","ペ","ポ",
    "ャ","ュ","ョ","ッ","ヮ",
    "ァ","ィ","ゥ","ェ","ォ",
    "ー","・","ヴ", "" , "" ,
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
    "","","","","",
  ]
  # ----------------------------------
  def initialize
    super(160, 128, 480, 352)
    self.contents = Bitmap.new(width - 32, height - 32)
    self.active = false
    @index = -1
    @mode = 1
    refresh
    update_cursor_rect
  end
  # ----------------------------------
  def index=(value)
    @index = value
    update_cursor_rect
  end
  #--------------------------------------
  def character
    if @mode == 1
    return ENGLISH_TABLE[@index]
  elsif @mode == 2
    return HIRAGANA_TABLE[@index]
  else
    return KATAKANA_TABLE[@index]
    end
  end
  # ----------------------------------
  def refresh
    self.contents.clear
    for i in 0..134
      x = 4 + i / 5 / 9 * 152 + i % 5 * 28
      y = i / 5 % 9 * 32
      if @mode == 1
      self.contents.font.name = "Arial"
      self.contents.font.size = 24
      self.contents.draw_text(x, y, 28, 32, ENGLISH_TABLE[i], 1)
    elsif @mode == 2
      self.contents.font.name = "ＭＳ Ｐゴシック"
      self.contents.font.size = 22
      self.contents.draw_text(x, y, 28, 32, HIRAGANA_TABLE[i], 1)
    else
      self.contents.font.name = "ＭＳ Ｐゴシック"
      self.contents.font.size = 22
      self.contents.draw_text(x, y, 28, 32, KATAKANA_TABLE[i], 1)
      end
    end
  end
  # ----------------------------------
  def update_cursor_rect
    if self.active == false
      self.cursor_rect.empty
    else
      x = 4 + @index / 5 / 9 * 152 + @index % 5 * 28
      y = @index / 5 % 9 * 32
      self.cursor_rect.set(x, y, 28, 32)
    end
  end
  # ----------------------------------
  def update
    super
    if @index >= 0 && @index <= 134
      if Input.repeat?(Input::RIGHT)
        $game_system.se_play($data_system.cursor_se)
          if @index % 5 == 4
            if @index < 94
              @index += 41
            end
          else
            @index += 1
          end
        end
      if Input.repeat?(Input::LEFT)
        $game_system.se_play($data_system.cursor_se)
          if @index % 5 == 0
            if @index < 45
              self.active = false
              @index = -999
              return
            else
              @index -= 41
            end
          else
            @index -= 1
          end
      end
      if Input.repeat?(Input::DOWN)
        $game_system.se_play($data_system.cursor_se)
        if @index % 45 < 40
          @index += 5
        end
      end
      if Input.repeat?(Input::UP)
        if Input.trigger?(Input::UP) or @index % 45 >= 5
          $game_system.se_play($data_system.cursor_se)
          if @index % 45 >= 5
            @index -= 5
          end
        end
      end
    end
    update_cursor_rect
  end
end

