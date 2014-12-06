package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class Weapon extends FlxObject
{
    
    
    ///////////////////////////////////////////////////////////
	public var shootTimerCurrent : Float;
	public var shootTimerMax : Float;
    
    public var AmmunitionCurrent : Int;
    public var AmminutionMax : Int;
    
    public var DamageBase : Float;
    public var DamageFactor : Float;
    
    public var ReloadTime : Float;// Reload Time in Seconds
    public var ReloadTimeFactor : Float ;   // smaller values improve reload time
    
    public var ShotsFired : Int;    // shotgun eg 5
    public var Spread : Float;  // in degree
    
    public var ShotSpeed : Float;
    ///////////////////////////////////////////////////////////
    
    
    
    
    private var reloadTimer :FlxTimer;
    
    private var reloadSign : FlxSprite;
    private var outOfAmmoSign : FlxSprite;
    
    public function new() 
    {
        super();
        AmmunitionCurrent = AmminutionMax = 6;
        
        DamageBase = 5.0;
        DamageFactor = 1.0;
        
        shootTimerMax = shootTimerCurrent = 0.5;
        
        ReloadTime = 1.5;
        ReloadTimeFactor = 1.0;
        reloadTimer = new FlxTimer(0.1);
        
        ShotsFired = 1;
        Spread = 0.5;
        
        ShotSpeed = 400;
        
        reloadSign = new FlxSprite();
        reloadSign.makeGraphic(20, 20, FlxColorUtil.makeFromARGB(1.0, 125, 125, 255));
        outOfAmmoSign = new FlxSprite();
        outOfAmmoSign.makeGraphic(20,20, FlxColorUtil.makeFromARGB(1.0, 255, 100, 100));
    }
       
    
    override public function update():Void 
    {
        super.update();
        if (shootTimerCurrent >= 0)
		{
			shootTimerCurrent -= FlxG.elapsed;
		}
    }
    override public function draw():Void
    {
        if (AmmunitionCurrent <= 0)
        {
            var p :FlxPoint =  FlxG.mouse.getWorldPosition(FlxG.camera);
            if (!reloadTimer.finished)
            {
                
                reloadSign.x = p.x;
                reloadSign.y = p.y;
                reloadSign.draw();
            }
            else
            {
                outOfAmmoSign.x = p.x;
                outOfAmmoSign.y = p.y;
                outOfAmmoSign.draw();
            }
        }
        
        
    }
    
    public function shoot() : Float
    {
        AmmunitionCurrent -= 1;
        shootTimerCurrent = shootTimerMax;
        return getDamage();
    }
        
    public function canShoot():Bool
    {
        return ((shootTimerCurrent < 0) && (AmmunitionCurrent > 0) && (reloadTimer.finished));
    }
    
    public function getDamage () :Float 
    {
        return DamageBase * DamageFactor;
    }
    
    public function getReloadTime () :Float 
    {
        return ReloadTime * ReloadTimeFactor;
    }
    
    public function reload () : Void 
    {
        reloadTimer = new FlxTimer(getReloadTime(), doReload);
        
    }
    
    public function doReload(t:FlxTimer) : Void
    {
        AmmunitionCurrent = AmminutionMax;
    }
    
    public function calculateWeaponSpread (startX: Float, startY: Float , target:FlxPoint):FlxPoint
    {
        var retval :FlxPoint = new FlxPoint();
        var v : FlxVector = new FlxVector(target.x - startX, target.y - startY);
        var deflection = FlxRandom.floatRanged( -Spread, Spread);
        v = v.rotateByDegrees(deflection);
        
        retval.x = v.x + startX;
        retval.y = v.y + startY;
        return retval;
    }
    
}