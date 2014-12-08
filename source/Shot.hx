package ;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.input.gamepad.LogitechButtonID;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import flash.filters.GlowFilter;

/**
 * ...
 * @author ...
 */
class Shot extends FlxSprite
{

    private var damage : Float;
    
    private var lifetime:Float;
    
    private var type : ShotType;
    
    private var soundShot :FlxSound;
    
    public var isDamageShot:Bool;
    
    public var disabled : Bool;
    
    private var spriteFilter : FlxSpriteFilter;
    private var filter : GlowFilter;
	public function new(X:Float=0, Y:Float=0, target : FlxPoint, w:Weapon, damageShot:Bool) 
	{
		super(X, Y);
                
        isDamageShot = damageShot;
        disabled = false;
        
        
        damage = w.getDamage();
        
        var direction : FlxVector = new FlxVector(target.x - x, target.y - y);
        direction.normalize();
        velocity.x = direction.x * w.ShotSpeed;
		velocity.y = direction.y * w.ShotSpeed;
        
        angle = direction.degrees;
        
        type = w.type;
        lifetime = 10;
        
        soundShot = new FlxSound();
        var panPosition : Float = (x- 640.0) / 640.0 * GameProperties.SoundPanScale;
        soundShot.pan = panPosition;
        
        if (type == ShotType.Bullet)
        {
            //makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1.0, 250, 250, 250));	
            loadGraphic(AssetPaths.shot_bullet__png, false, 24, 6);
            var rnd :Int  = FlxRandom.intRanged(0, 2);
            var bulletVolume :Float = 0.5;
            if (rnd == 0)
            {
                soundShot = FlxG.sound.load(AssetPaths.shoot1__wav, bulletVolume, false, true, false );
            }
            else if (rnd == 1)
            {
                soundShot = FlxG.sound.load(AssetPaths.shoot2__wav, bulletVolume, false, true, false );
            }
            else if (rnd == 2)
            {
                soundShot = FlxG.sound.load(AssetPaths.shoot3__wav, bulletVolume, false, true, false );
            }
            soundShot.play(false);
            filter = new GlowFilter(FlxColorUtil.makeFromARGB(1.0,242,249,244), 1, 12.5, 12.5, 1.5, 1);
            spriteFilter = new FlxSpriteFilter(this, 50, 50);
            spriteFilter.addFilter(filter);
        }
		else if (type == ShotType.Microwave)
        {
            lifetime = 4;
            loadGraphic(AssetPaths.shot_microwave__png, false, 3, 8);
            FlxTween.tween(this.scale, { x:1.5, y:3.5 }, 2);
            FlxTween.tween(this, { alpha:0 }, 2, { complete:deleteFromTween } );
            soundShot = FlxG.sound.load(AssetPaths.shoot_microwave__wav, 0.25, false, true, false);
            soundShot.play();
        }
        else
        {
            throw "Cannot determine shot type";
        }
        
        
        
        
	}
    
    public function push():FlxPoint
    {
        var v : FlxVector = new FlxVector (velocity.x, velocity.y);
        v.normalize();
        v.x *= getPushFactor();
        v.y *= getPushFactor();
        var retval :FlxPoint = new FlxPoint (v.x, v.y);
        return retval;
        
    }
    
    private function getPushFactor():Float
    {
        var retval : Float = 2.0;
        
        if (type == ShotType.Bullet)
        {
            retval = 35.0;
        }
        else if (type == ShotType.Flames)
        {
            retval = 0;
        }
        else if (type == ShotType.Laser)
        {
            retval = 50.0;
        }
        else if (type == ShotType.Microwave)
        {
            retval = 150.0;
        }
        else if (type == ShotType.Railgun)
        {
            retval = 5.0;
        }
        else if (type == ShotType.Rocket)
        {
            retval = 5.0;
        }
        return retval;
    }
	
	public override function update(): Void
	{
		super.update();
        lifetime -= FlxG.elapsed;
        if (lifetime < 0)
        {
            alive = false;
        }
        

	}
	
	public override function draw():Void
	{
		super.draw();
	}
    
    public function deleteFromTween(t:FlxTween):Void
    {
        deleteObject();
    }
    
	public function deleteObject():Void
    {
        alive = false;
        exists = false;
    }
    
    public function getDamage ():Float 
    {
        return damage;
    }
    
    public function disable():Void
    {
        disabled = true;
        var t: FlxTimer = new FlxTimer(0.1, function (t:FlxTimer) { disabled = false; } );
    }
}