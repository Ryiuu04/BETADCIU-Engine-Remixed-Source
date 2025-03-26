package backend;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.ui.FlxUIState;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxGradient;
import flixel.util.FlxTimer;
import backend.Conductor.BPMChangeEvent;
import backend.MusicBeatState;
// import states.substates.MusicBeatSubstate;

class CustomFadeTransition extends MusicBeatSubstate
{
	public static var finishCallback:Void->Void;

	private var leTween:FlxTween = null;

	public static var nextCamera:FlxCamera;

	var isTransIn:Bool = false;
	var transBlack:FlxSprite;
	var transGradient:FlxSprite;

	var transitionSprite:FlxSprite;
	var fade:FlxSprite; // totally not stolen from Sonic Legacy

	public function new(duration:Float, isTransIn:Bool, ?fadeInstead:Bool=false)
	{
		super();

		this.isTransIn = isTransIn;

		var width:Int = Std.int(FlxG.width);
		var height:Int = Std.int(FlxG.height);
		
		if (!fadeInstead) {
			transitionSprite = new FlxSprite(-2600);
			transitionSprite.loadGraphic(Paths.image('transition thingy'));
			transitionSprite.scrollFactor.set(0, 0);
			add(transitionSprite);

			if (isTransIn)
			{
				transitionSprite.x = -620;

				FlxTween.tween(transitionSprite, { x: 1280 }, 0.4, {
					onComplete: function(twn:FlxTween)
					{
						close();
					}
				});
			}
			else
			{
				transitionSprite.x = -2600;

				FlxTween.tween(transitionSprite, { x: -620 }, 0.4, {
					onComplete: function(twn:FlxTween)
					{
						finishCallback();
					}
				});

			}
		} else { // testing fade trans
			fade = new FlxSprite().makeGraphic(1,1,FlxColor.BLACK);
			fade.setGraphicSize(width,height);
			fade.updateHitbox();
			fade.screenCenter();
			fade.scrollFactor.set();
			add(fade);

			if (isTransIn) {
				fade.alpha = 1;
				FlxTween.tween(fade,{alpha: 0}, 0.4, {onComplete: Void-> {
					close();
				}});
			} else {
				fade.alpha = 0;
				FlxTween.tween(fade,{alpha: 1}, 0.4, {onComplete: Void-> {
					finishCallback();
				}});
			}
	
		}

		//quick fix for the character editor/stage editor
		var transitionCamera = new FlxCamera();
		transitionCamera.bgColor.alpha = 0;
		FlxG.cameras.add(transitionCamera, false);

		if (!fadeInstead) transitionSprite.cameras = [transitionCamera];
		else fade.cameras = [transitionCamera];
		//
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	override function destroy()
	{
		if (leTween != null)
		{
			finishCallback();
			leTween.cancel();
		}
		super.destroy();
	}
}
