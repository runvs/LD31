package;

import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;
import flixel.util.FlxColorUtil;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import haxe.Int32;
import openfl.geom.Rectangle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

    private var _player: Player;

    private var _enemyList : FlxTypedGroup<Enemy>;
    private var _spawner : EnemySpawner;

    private var _shotList : FlxTypedGroup<Shot>;
    private var _pickupList : FlxTypedGroup<Pickup>;
    

    private var _backgroundSprite : FlxSprite;
    private var _backgroundOverlay1 : FlxSprite;
    private var _overlayList = [];
    private var _goreLayer :FlxSprite;
    
    private var _vignetteSprite:FlxSprite;
    
    private var _ending = false;
    private var _score = 0;
    
    private var _gameOverFade:FlxSprite;
    private var _gameOverText:FlxText;
    private var _gameOverScoreText:FlxText;
    private var _gameOverAgainText:FlxText;
    
    private var _tutorialText1:FlxText; // movement wasd
    private var _tutorialText2:FlxText; // shoot lmb
    private var _tutorialText3:FlxText; // reload rmb
    
    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();
        
        _gameOverFade = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
        
        _gameOverText = new FlxText(0, FlxG.height / 2 - 20, FlxG.width, "Game Over!");
        _gameOverText.setFormat(null, 32, 0xAAFFFFFF, "center");
        
        _gameOverScoreText = new FlxText(0, FlxG.height / 2 + 20, FlxG.width, "Score: ");
        _gameOverScoreText.setFormat(null, 32, 0xAAFFFFFF, "center");
        
        _gameOverAgainText = new FlxText(0, FlxG.height - 40, FlxG.width, "To try again press SPACE.");
        _gameOverAgainText.setFormat(null, 32, 0xAAFFFFFF, "center");
        
        _player = new Player(640, 380, this);
        
        _backgroundSprite = new FlxSprite();
        _backgroundSprite.loadGraphic(AssetPaths.background__png);
        
        _backgroundOverlay1 = new FlxSprite();
        _backgroundOverlay1.loadGraphic(AssetPaths.backgroundOverlay1__png);
        
        _goreLayer = new FlxSprite();
        _goreLayer.makeGraphic(1280, 720, FlxColorUtil.makeFromARGB(0.1, 100, 35, 20));
        
        //createVignetteSprite();
        _vignetteSprite = new FlxSprite();
        _vignetteSprite.loadGraphic(AssetPaths.filter_vignette__png, false, 1280, 720);
        _vignetteSprite.alpha = 0.5;
        // Create random positions for the overlays
        for (i in 0...100)
        {
            _overlayList[i] = new FlxPoint(Std.random(1280), Std.random(720));
        }

        _enemyList = new FlxTypedGroup<Enemy>();
        
        _spawner = new EnemySpawner(this);
        add(_spawner);
        
        _shotList = new FlxTypedGroup<Shot>();
        
        _pickupList = new FlxTypedGroup<Pickup>();
        
        #if flash
        FlxG.sound.playMusic(AssetPaths.LD31_OST__mp3,0.5);
        #else
        FlxG.sound.playMusic(AssetPaths.LD31_OST__ogg,0.5);
        #end
        
        
        _tutorialText1 = new FlxText(500, 100, 500, "Move - W A S D", 15, true);
        _tutorialText2 = new FlxText(500, 150, 500, "Shoot - Left Mouse Button", 15, true);
        _tutorialText3 = new FlxText(500, 200, 500, "Reload - Right Mouse Button", 15, true);
        _tutorialText1.alpha = _tutorialText2.alpha = _tutorialText3.alpha = 0;
        //_tutorialText1.scale.x = _tutorialText1.scale.y = _tutorialText2.scale.x = _tutorialText2.scale.y = _tutorialText3.scale.x = _tutorialText3.scale.y = 0;
        
        FlxTween.tween(_tutorialText1, { alpha : 1 }, 0.5);
        var t2In :FlxTimer = new FlxTimer(0.5, function (t:FlxTimer) { FlxTween.tween(_tutorialText2, { alpha : 1 }, 0.5);  } );
        var t3In :FlxTimer = new FlxTimer(1.0, function (t:FlxTimer) { FlxTween.tween(_tutorialText3, { alpha : 1 }, 0.5); } );
        
        var t1Out : FlxTimer = new FlxTimer(4.5, function (t:FlxTimer) { FlxTween.tween(_tutorialText1, { alpha:0 }, 0.5  ); } );
        var t2Out : FlxTimer = new FlxTimer(5.0, function (t:FlxTimer) { FlxTween.tween(_tutorialText2, { alpha:0 }, 0.5  ); } );
        var t3Out : FlxTimer = new FlxTimer(5.5, function (t:FlxTimer) { FlxTween.tween(_tutorialText3, { alpha:0 }, 0.5  ); } );

    }

    /**
     * Function that is called when this state is destroyed - you might want to 
     * consider setting all objects this state uses to null to help garbage collection.
     */
    override public function destroy():Void
    {
        super.destroy();
    }

    /**
     * Function that is called once every frame.
     */
    override public function update():Void
    {
        super.update();
        
        if (_ending)
        {
            _player.stopSound();
            if (FlxG.keys.justPressed.SPACE)
            {
                resetGame();
            }
            return;
        }
        
        cleanUp();
        
        _player.update();
        
        for (j in 0 ... _shotList.length)
        {
            var s:Shot = _shotList.members[j];
            s.update();
        }
        
        for (j in 0 ... _pickupList.length)
        {
            var p:Pickup = _pickupList.members[j];
            p.update();
            
            if (FlxG.overlap(p, _player))
            {
                _player.pickUp(p.type);
                p.alive = false;
                p.exists = false;
            }
        }
        
        
        for (j in 0 ... _enemyList.length)
        {
            var e:Enemy = _enemyList.members[j];
            e.update();
        }
        
        doCollisions();
    }

    override public function draw():Void
    {
        super.draw();
        
        // Draw background sprites
        var i = 0.0;
        while (i <= 1280)
        {
            var j = 0.0;
            while (j <= 720)
            {
                _backgroundSprite.x = i;
                _backgroundSprite.y = j;
                _backgroundSprite.draw();
                
                j += _backgroundSprite.height;
            }
            
            i += _backgroundSprite.width;
        }
        
        // Draw background overlays
        for (i in 0..._overlayList.length)
        {
            var p = _overlayList[i];
            _backgroundOverlay1.x = p.x;
            _backgroundOverlay1.y = p.y;
            _backgroundOverlay1.draw();
        }
        
        _goreLayer.draw();
        
        _player.draw();
        
        for (j in 0 ... _enemyList.length)
        {
            var e:Enemy = _enemyList.members[j];
            e.draw();
        }
        for (j in 0 ... _pickupList.length)
        {
            var p:Pickup = _pickupList.members[j];
            p.draw();
        }
        for (j in 0... _shotList.length)
        {
            var s:Shot = _shotList.members[j];
            s.draw();
        }

        _player.drawHUD();
        
        _tutorialText1.draw();
        _tutorialText2.draw();
        _tutorialText3.draw();
        
        if (_ending)
        {
            _gameOverFade.draw();
            _gameOverText.draw();
            _gameOverScoreText.draw();
            _gameOverAgainText.draw();
        }
        _vignetteSprite.draw();
        
    }
    
    private function resetGame():Void
    {
        FlxG.switchState(new PlayState());
    }

    private function cleanUp():Void
    {
        {
            var newShotList:FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
            _shotList.forEach(function(s:Shot) { if (s.alive) { newShotList.add(s); } else { s.destroy(); } } );
            _shotList = newShotList;
        }
        {
            var newEnemyList:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
            _enemyList.forEach(function(e:Enemy) { if (e.alive) { newEnemyList.add(e); }} );
            _enemyList = newEnemyList;
        }
        {
           var newPickupList :FlxTypedGroup<Pickup> = new FlxTypedGroup<Pickup>();
           _pickupList.forEach(function(p:Pickup) { if (p.alive) { newPickupList.add(p); }} );
            _pickupList = newPickupList;
        }
    }

    private function doCollisions ():Void
    {
        for (i in 0..._enemyList.length)
        {
            var e:Enemy = _enemyList.members[i];
            if (!(e.alive && e.exists))
            {
                continue;
            }
            
            for (j in 0... _shotList.length)
            {
                var s:Shot = _shotList.members[j];
                if (!(s.alive && s.exists && !s.disabled))
                {
                    continue;
                }
                
                // Check for collision enemy<->shot
                if (FlxG.overlap(e, s))
                {
                    if (FlxG.pixelPerfectOverlap(e, s,1))
                    {
                        shotEnemyCollision(e, s);
                    }
                }
            }
                
            // Check for collision player<->enemy
            if (FlxG.overlap(e, _player))
            {
                if (FlxG.pixelPerfectOverlap(e, _player, 1))
                {
                    _player.getHit(e);
                    
                    if (_player.alive  == false)
                    {
                        if (_ending == false)
                        {
                            _gameOverScoreText.text += _score;
                        }
                        
                        _ending = true;
                    }
                }
            }
        }
    }

    public function shotEnemyCollision (e:Enemy, s:Shot):Void
    {
        //addExplosion(new Explosion(s.sprite.x - 4, s.sprite.y - 6, true));
        if (!s.isDamageShot)
        {
            s.deleteObject();
        }
        else
        {
            s.disable();
        }
        
        var push = s.push();
        e.velocity.x += push.x;
        e.velocity.y += push.y;
        
        e.takeDamage(s.getDamage());
        
        
        //_goreLayer.pixels.lock();
        
       
        
        
        for (i in 0 ... GameProperties.GoreAmount)
        {
            var posX : Int = FlxRandom.intRanged(Math.round(e.x) - 20, Math.round(e.x) + 20);
            var posY : Int = FlxRandom.intRanged(Math.round(e.y) - 20, Math.round(e.y) + 20);
            var r :Int = 81 + FlxRandom.intRanged( -5, 25);
            var g :Int = 35 + FlxRandom.intRanged( -5, 10);
            var b :Int = 20 + FlxRandom.intRanged( -5, 5);
           
            var spr : FlxSprite = new FlxSprite();
            spr.makeGraphic(2 + FlxRandom.intRanged(0,2), 2 + FlxRandom.intRanged(0,2),  FlxColorUtil.makeFromARGB(1.0,r,g,b));
            trace (posX + " " + posY);
            var rect : Rectangle = new Rectangle(posX , posX, 2, 2);
            //_goreLayer.pixels.fillRect( rect, FlxColorUtil.getColor24(255,0,0)); 
            _goreLayer.stamp(spr, posX, posY);
        }

   
        
        if (!e.alive)
        {
            _score++;
        }

    }
    
    public function spawnShot(s:Shot) : Void
    {
        _shotList.add(s);
    }

    public function spawnEnemy(e:Enemy) : Void
    {
        _enemyList.add(e);
    }

    public function spawnPickup(p:Pickup) :Void
    {
        _pickupList.add(p);
    }
    
    public function getPlayerPosition () : FlxPoint
    {
        var p :FlxPoint = new FlxPoint(_player.x, _player.y);
        return p;
    }
    
    public function getNumberOfEnemies () : Int 
    {
        return _enemyList.length;
    }
    public function getPlayerHasWeapon():Bool
    {
        return _player.getHasWeapon();
    }
    private function createVignetteSprite():Void
    {
        _vignetteSprite = new FlxSprite();
        var sizeX : Int = 128;
        var sizeY : Int = 72;
        
        _vignetteSprite.makeGraphic(sizeX, sizeY, FlxColor.BLACK);
        
        var centerPositionX : Float = sizeX / 2.0;
        var centerPositionY : Float = sizeY / 2.0;
        
        var distanceToCenterMax : Float = Math.sqrt(centerPositionX * centerPositionX + centerPositionY * centerPositionY);
        //_vignetteSprite.pixels.lock();
        for (i in 0...sizeX)
        {
            for (j in 0...sizeY)
            {
                var distanceToCenterX : Float = centerPositionX - i;
                var distanceToCenterY : Float = centerPositionY - j;
                var newAlpha :Float = 255 * Math.sqrt(distanceToCenterX * distanceToCenterX + distanceToCenterY * distanceToCenterY) / distanceToCenterMax;
                newAlpha = 255 * i / sizeX;
                var alphaInt :Int = Math.round(newAlpha);
               
                //var c : Int = FlxColorUtil.getColor32(alphaInt, 255, 255, 255);
                
                var c : UInt = alphaInt << 24 | 0 << 16 | 0 << 8 | 0;
                _vignetteSprite.pixels.setPixel32(i, j, c);
                if (alphaInt == 0)
                {
                    trace (i + " " + j);
                }
            }
            
        }
        //_vignetteSprite.pixels.unlock();

        
    }
}



