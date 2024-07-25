package objects;

import openfl.Assets;
import flixel.FlxSprite;
import objects.Note;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxTimer;
import states.PlayState;

using StringTools;

//Most of the Original code from Mr.Bruh (mr.bruh69)
//Ported to haxe and edited by glowsoony //gracias glow :mirada_sexy:

class CoverSprite extends FlxSprite
{
  public var boom:Bool = false;
  public var isPlaying:Bool = false;
  public var activatedSprite:Bool = true;
  public var useRGBShader:Bool = false;

  public var spriteId:String = "";
  public var skin:String = "";

  public function initFrames(i:Int, hcolor:String)
  {
    this.skin = "holdCover";
    this.frames = Paths.getSparrowAtlas('HoldNoteEffect/holdCover$hcolor');
  }

  public function initAnimations(i:Int, hcolor:String)
  {
    this.animation.addByPrefix(Std.string(i), 'holdCover$hcolor', 24, true);
    this.animation.addByPrefix(Std.string(i) + 'p', 'holdCoverEnd$hcolor', 24, false);
  }

  public function smoothSprite()
  {
    this.antialiasing = ClientPrefs.data.antialiasing;
    if (skin.contains('pixel') || !ClientPrefs.data.antialiasing)
      this.antialiasing = false;
  }
}

class HoldCover extends FlxTypedSpriteGroup<CoverSprite>
{
  public var enabled:Bool = true;
  public var isPlayer:Bool = false;

  public function new(enabled:Bool, isPlayer:Bool)
  {
    this.enabled = enabled;
    this.isPlayer = isPlayer;
    super(0, 0, 4);
    for (i in 0...maxSize)
      addHolds(i);
  }

  public function addHolds(i:Int)
  {
    var colors:Array<String> = ["Purple", "Blue", "Green", "Red", "Purple", "Blue", "Green", "Red"];
    var hcolor:String = colors[i];
    var hold:CoverSprite = new CoverSprite();
    hold.initFrames(i, hcolor);
    hold.initAnimations(i, hcolor);
    hold.boom = false;
    hold.isPlaying = false;
    hold.visible = false;
    hold.activatedSprite = enabled;
    hold.spriteId = '$hcolor-$i';
    this.add(hold);
  }

  public function spawnOnNoteHit(note:Note, isReady:Bool):Void
  {
    if (note == null) return;
    var noteData:Int = note.noteData;
    var isSus:Bool = note.isSustainNote;
    var isHoldEnd:Bool = note.animation.curAnim.name.endsWith('end');

    if (enabled && isReady)
    {
      var data:Int = noteData;

      if (isSus)
      {
        this.members[data].smoothSprite();

        if (isHoldEnd)
        {
          if (isPlayer)
          {
            this.members[data].isPlaying = false;
            this.members[data].boom = true;
            this.members[data].animation.play(Std.string(data) + 'p');
          }
          else
          {
            this.members[data].isPlaying = false;
            this.members[data].boom = false;
            hideHoldCoverLater(data, 0.075);
          }
        }
        else
        {
          if (this.members[data].isPlaying == false)
          {
            if (this.members[data].boom == false)
              this.members[data].visible = true;
            this.members[data].animation.play(Std.string(data));
            this.members[data].isPlaying = false;
          }
        }
      }
    }
  }

  public function despawnOnMiss(isReady:Bool, direciton:Int, ?note:Note = null):Void
  {
    var noteData:Int = (note != null ? note.noteData : direciton);
    if (enabled && isReady)
    {
      var data:Int = noteData;
      this.members[data].smoothSprite();
      this.members[data].isPlaying = false;
      this.members[data].boom = false;
      this.members[data].visible = false;
      this.members[data].animation.stop();
    }
  }

  private function hideHoldCoverLater(data:Int, delay:Float):Void
  {
      var timer:FlxTimer = new FlxTimer();
      var tag:String = "hideHoldCoverFromStrum" + data;
      PlayState.instance.modchartTimers.set(tag, timer.start(delay, function(timer:FlxTimer)
      {
        this.members[data].visible = false;
        PlayState.instance.modchartTimers.remove(tag);
      }));
  }

  public function updateHold(elapsed:Float, isReady:Bool):Void
  {
    if (enabled && isReady)
    {
      for (i in 0...this.members.length)
      {
        if (this.members[i].x != ni(i, "x") - 110)
        {
          this.members[i].x = ni(i, "x") - 110;
        }
        if (this.members[i].y != ni(i, "y") - 100)
        {
          this.members[i].y = ni(i, "y") - 100;
        }

        if (this.members[i].boom == true)
        {
          if (this.members[i].animation.curAnim.finished)
          {
            this.members[i].visible = false;
            this.members[i].boom = false;
          }
        }
      }
    }
  }

  function ni(note, info):Float
  {
    if (enabled && PlayState.instance != null && !PlayState.instance.inCutscene)
    {
      var game:PlayState = PlayState.instance;
      if (game == null) return 110;
      else
      {
        if (info == "x") return game.strumLineNotes.members[isPlayer ? note + 4 : note].x;
        else if (info == "y") return game.strumLineNotes.members[isPlayer ? note + 4 : note].y;
        return 0;
      }
    }
    return 0;
  }
}
