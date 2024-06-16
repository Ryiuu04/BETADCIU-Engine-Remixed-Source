package;

#if sys
import sys.FileSystem;
#end
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import openfl.media.Sound;

//import states.TitleState;
import states.*;//fuck it.
import preload.*;//balls.
import backend.Highscore;//balls.
import backend.KadeEngineData;//balls.
import backend.ClientPrefs;//balls.
import backend.CoolUtil;//balls.
import backend.MusicBeatState;//balls.
import flixel.graphics.FlxGraphic;//balls.

import objects.Character;//testing
import objects.Stage;//testing

import flixel.FlxState;
import lime.utils.Assets;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxText;
import openfl.system.System;
//import openfl.utils.Future;
//import flixel.addons.util.FlxAsyncLoop;
//import extensions.flixel.FlxUIStateExt;

using StringTools;

class PreloadState extends FlxState
{
    //Cool Preloader Made by Rozebud for his engine(FPS Plus), Huge props to him

    var nextState:FlxState = new TitleState();

    var splash:FlxSprite;
    var loadingBar:FlxBar;
    var loadingText:FlxText;

    var currentLoaded:Int = 0;
    var loadTotal:Int = 0;

    var songsCached:Bool;
    public static final songs:Array<String> =   ["Tutorial", 
                                "Bopeebo", "Fresh", "Dadbattle", 
                                /*"Spookeez", "South", "Monster",
                                "Pico", "Philly", "Blammed", 
                                "Satin-Panties", "High", "Milf", 
                                "Cocoa", "Eggnog", "Winter-Horrorland", 
                                "Senpai", "Roses", "Thorns",
                                "Ugh", "Guns", "Stress"*/]; //Start of the non-gameplay songs.
                                
    //List of character graphics and some other stuff.
    //Just in case it want to do something with it later.
    var charactersCached:Bool;
    var startCachingCharacters:Bool = false;
    var charI:Int = 0;

    public static final characters:Array<String> =   ["BOYFRIEND", "bfCar", "bfChristmas", "bfPixel", "bfPixelsDEAD",//Boyfriend
                                    "GF_assets", "gfCar", "gfChristmas", "gfPixel", "gfTankmen",//Girlfriend
                                    /*"DADDY_DEAREST", //week1
                                    "spooky_kids_assets", "Monster_Assets",//week2
                                    "Pico_FNF_assetss",//week3
                                    "Mom_Assets", "momCar",//week4
                                    "mom_dad_christmas_assets", "monsterChristmas",//week5
                                    "senpai", "spirit",//week6
                                    "tankmanCaptain",//week7*/
                                    "nogf_assets", "nogf_christmas_assets", //the speakers
                                    "emptygf_assets"];//we totally need to preload this 1x1 image

    var graphicsCached:Bool;
    var startCachingGraphics:Bool = false;
    var gfxI:Int = 0;
    public static final graphics:Array<String> =    ["images/logoBumpin", "images/titleEnter", 
                                    "images/stageback", "images/stagefront", "images/stagecurtains",
                                    "images/bruhtf", "images/menuBGStorm", "images/menuBGTemplate", "images/menuBGTemplate2" //some random images that are used sometimes
                                    /*"week2/images/halloween_bg",
                                    "week3/images/philly/sky", "week3/images/philly/city", "week3/images/philly/behindTrain", "week3/images/philly/train", "week3/images/philly/street", "week3/images/philly/windowWhite", "week3/images/philly/windowWhiteGlow",
                                    "week4/images/limo/bgLimo", "week4/images/limo/fastCarLol", "week4/images/limo/limoDancer", "week4/images/limo/limoDrive", "week4/images/limo/limoSunset",
                                    "week5/images/christmas/bgWalls", "week5/images/christmas/upperBop", "week5/images/christmas/bgEscalator", "week5/images/christmas/christmasTree", "week5/images/christmas/bottomBop", "week5/images/christmas/fgSnow", "week5/images/christmas/santa",
                                    "week5/images/christmas/evilBG", "week5/images/christmas/evilTree", "week5/images/christmas/evilSnow",
                                    "week6/images/weeb/weebSky", "week6/images/weeb/weebSchool", "week6/images/weeb/weebStreet", "week6/images/weeb/weebTreesBack", "week6/images/weeb/weebTrees", "week6/images/weeb/petals", "week6/images/weeb/bgFreaks",
                                    "week6/images/weeb/animatedEvilSchool", "week6/images/weeb/senpaiCrazy",
                                    "images/tank/tank0", "images/tank/tank1", "images/tank/tank2", "images/tank/tank3", "images/tank/tank4", "images/tank/tank5", "images/tank/tankmanKilled1", 
"images/tank/smokeLeft", "images/tank/smokeRight", "images/tank/tankBuildings", "images/tank/tankClouds", "images/tank/tankGround", "images/tank/tankMountains", "images/tank/tankRolling", "images/tank/tankRuins", "images/tank/tankSky", "images/tank/tankWatchtower"*/];

    private static var canStartPreloading:Bool = false;
    private static var preloadCompleted:Bool = false;
    var cacheStart:Bool = false;

    public static var thing = false;

	override function create()
	{
        FlxG.save.bind('funkin', 'ninjamuffin99');

        FlxG.sound.volume = FlxG.save.data.volume;

        //FlxG.autoPause = false;
        FlxG.mouse.visible = false;

        songsCached = false;
        charactersCached = false;
        graphicsCached = false;

        /*splash = new FlxSprite(0, 0);
        splash.frames = Paths.getSparrowAtlas('rozeSplash');//using the fps plus anim as a placeHolder
        splash.animation.addByPrefix('start', 'Splash Start', 24, false);
        splash.animation.addByPrefix('end', 'Splash End', 24, false);
        add(splash);
        splash.animation.play("start");
        splash.updateHitbox();
        splash.screenCenter();*/

        splash = new FlxSprite(0, FlxG.height).loadGraphic(Paths.file2("funkay-dark", "assets/images", "png"));
		add(splash);
		splash.setGraphicSize(0, FlxG.height);
		splash.updateHitbox();
		splash.screenCenter();
		splash.antialiasing = true;

        /*FlxTween.tween(splash, {"scale.x": 1, "alpha": 1}, 0.9, {
            ease: FlxEase.backOut
        });

        FlxTween.tween(splash, {"scale.y": 1}, 1.1, {ease: FlxEase.backOut,
            onComplete: function(twn:FlxTween) {
                canStartPreloading = true;
            }
        });*/

        /*FlxTween.tween(splash, {"alpha": 1}, 1.1, {ease: FlxEase.cubeOut,
            onComplete: function(twn:FlxTween) {
                canStartPreloading = true;
            }
        });*/

        loadTotal = (!songsCached ? songs.length : 0) + (!charactersCached ? characters.length : 0) + (!graphicsCached ? graphics.length : 0);

        if(loadTotal > 0){
            loadingBar = new FlxBar(0, 720-24, LEFT_TO_RIGHT, 1280, 24, this, 'currentLoaded', 0, loadTotal);
            loadingBar.createFilledBar(0xFF333333, 0xFF822193);
            loadingBar.screenCenter(X);
            loadingBar.visible = true;
            add(loadingBar);
        }

        loadingText = new FlxText(5, FlxG.height - 30 - 24, 0, "", 24);
        loadingText.setFormat(Paths.font("phantomMuff.ttf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        add(loadingText);

        #if web
        FlxG.sound.play(Paths.sound("tick"), 0);   
        #end

        /*new FlxTimer().start(1.1, function(tmr:FlxTimer)
        {
            FlxG.sound.play(Paths.sound("scrollMenu"));   
        });*/

        FlxG.sound.play(Paths.sound("scrollMenu"));   
        canStartPreloading = true;

        super.create();
    }

    public static var cache:Map<String, FlxGraphic> = new Map<String, FlxGraphic>();

    override function update(elapsed) 
    {
        
        if(canStartPreloading == true && !cacheStart){
            
            #if web
            new FlxTimer().start(1.5, function(tmr:FlxTimer)
            {
                songsCached = true;
                charactersCached = true;
                graphicsCached = true;
            });
            #else
            if(!songsCached || !charactersCached || !graphicsCached){
                preload(); 
            }
            #end
            
            cacheStart = true;
        }
        if(preloadCompleted == true){
            trace('Preload Finished!');
            System.gc();
            FlxG.switchState(nextState); 
        }

        if(songsCached && charactersCached && graphicsCached /*&& splash.animation.curAnim.finished && !(splash.animation.curAnim.name == "end")*/){
            
            //System.gc();
            //splash.animation.play("end");

            splash.updateHitbox();
            splash.screenCenter();

            new FlxTimer().start(0.3, function(tmr:FlxTimer){
                daFuckingSound();

                loadingText.text = "Done!";
                if(loadingBar != null){

                    FlxTween.tween(splash, {alpha: 0}, 1);
                    FlxTween.tween(loadingText, {alpha: 0}, 1);
                    FlxTween.tween(loadingBar, {alpha: 0}, 1, {
                        onComplete: function(twn:FlxTween) {
                            preloadCompleted = true;
                        }
                    });
                }
            });
        }

        if(startCachingCharacters){
            if(charI >= characters.length){
                loadingText.text = "Characters cached...";
                startCachingCharacters = false;
                charactersCached = true;
            }
            else{
                var CharacterPath:String = Paths.file2(characters[charI], "assets/images/characters", "png");
                var CharacterPathButShared:String = Paths.file2(characters[charI], "assets/shared/images/characters", "png");//Check Shared too!

                if(CoolUtil.exists(CharacterPath)){
                    ImageCache.add(CharacterPath);
                    trace("Character: " + characters[charI] + " Loaded.");
                }else if(CoolUtil.exists(CharacterPathButShared)){//Check Shared too!
                    ImageCache.add(CharacterPathButShared);
                    trace("Character: " + characters[charI] + " Loaded.");
                }else{
                    trace("Character: File at " + characters[charI] + " not found, skipping cache.");
                }

                charI++;
                currentLoaded++;
            }
        }

        if(startCachingGraphics){
            if(gfxI >= graphics.length){
                loadingText.text = "Graphics cached...";
                startCachingGraphics = false;
                graphicsCached = true;
            }
            else{
                var imagePath:String = Paths.file2(graphics[gfxI], "assets", "png");
                var imagePathButShared:String = Paths.file2(graphics[gfxI], "assets/shared", "png");//Check Shared too!

                if(CoolUtil.exists(imagePath)){
                    ImageCache.add(imagePath);
                    trace("Graphic: " + graphics[gfxI] + " Loaded.");
                }else if(CoolUtil.exists(imagePathButShared)){//Check Shared too!
                    ImageCache.add(imagePathButShared);
                    trace("Graphic: " + graphics[gfxI] + " Loaded.");
                }else{
                    trace("Graphic: File at " + graphics[gfxI] + " not found, skipping cache.");
                }
                gfxI++;
                currentLoaded++;
            }
        }
        
        super.update(elapsed);

    }

    private var confirmSoundIsPlaying:Bool = false;

    function daFuckingSound(){ //prob there's a easier way to do this but im a potato at haxe coding
        if(!confirmSoundIsPlaying){
            confirmSoundIsPlaying = true;
            FlxG.sound.play(Paths.sound("cancelMenu"));       
        }
    }


    function preload(){

        loadingText.text = "Caching Assets...";
        
        if(loadingBar != null){
            loadingBar.visible = true;
        }
        
        if(!songsCached){ 
            #if sys sys.thread.Thread.create(() -> { #end
                preloadMusic();
            #if sys }); #end
        }
        
        if(!charactersCached){
            startCachingCharacters = true;
        }

        if(!graphicsCached){
            startCachingGraphics = true;
        }

    }

    function preloadMusic(){
        for(x in songs){
            if(CoolUtil.exists(Paths.inst(x))){
                FlxG.sound.cache(Paths.inst(x));
            }
            else if(CoolUtil.exists(Paths.music(x))){
                FlxG.sound.cache(Paths.music(x));
            }
            currentLoaded++;
        }
        loadingText.text = "Songs cached...";
        songsCached = true;
    }

    function preloadCharacters(){
        for(x in characters){
            ImageCache.add(Paths.file2(x, "images", "png"));
            //trace("Chached " + x);
        }
        loadingText.text = "Characters cached...";
        charactersCached = true;
    }

    function preloadGraphics(){
        for(x in graphics){
            ImageCache.add(Paths.file2(x, "images", "png"));
            //trace("Chached " + x);
        }
        loadingText.text = "Graphics cached...";
        graphicsCached = true;
    }
}
