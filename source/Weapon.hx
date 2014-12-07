package ;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.system.FlxSound;
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
    public var shootTimerFactor :Float;
    
    public var AmmunitionCurrent : Int;
    public var AmminutionMax : Int;
    
    public var DamageBase : Float;
    public var DamageFactor : Float;
    
    public var ReloadTime : Float;// Reload Time in Seconds
    public var ReloadTimeFactor : Float ;   // smaller values improve reload time
    
    public var ShotsFired : Int;    // shotgun eg 5
    public var Spread : Float;  // in degree
    
    public var ShotSpeed : Float;
    public var type : ShotType;
    public var name: String;
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
        reloadTimer = new FlxTimer(0.05);
        
        ShotsFired = 1;
        Spread = 0.5;
        
        ShotSpeed = 400;
        shootTimerFactor = 1.0;
        
        reloadSign = new FlxSprite();
        reloadSign.loadGraphic(AssetPaths.reloading__png, true, 20, 20);
        reloadSign.animation.add("base", [0, 1, 2, 3], 8);
        reloadSign.animation.play("base");
        
        outOfAmmoSign = new FlxSprite();
        outOfAmmoSign.loadGraphic(AssetPaths.outOfAmmo__png, true, 20, 20);
        outOfAmmoSign.animation.add("base", [0, 1], 4);
        outOfAmmoSign.animation.play("base");
        
        name = "pistol";
    }
       
    
    override public function update():Void 
    {
        super.update();
        if (shootTimerCurrent >= 0)
        {
            shootTimerCurrent -= FlxG.elapsed;
        }
        
        reloadSign.update();
        outOfAmmoSign.update();
    }
    
    override public function draw():Void
    {
        var p :FlxPoint =  FlxG.mouse.getWorldPosition(FlxG.camera);
        if (AmmunitionCurrent <= 0)
        {
            if (!reloadTimer.finished)
            {
                reloadSign.x = p.x + 10;
                reloadSign.y = p.y;
                reloadSign.draw();
            }
            else
            {
                outOfAmmoSign.x = p.x + 10;
                outOfAmmoSign.y = p.y;
                outOfAmmoSign.draw();
            }
        }
        
        if (!reloadTimer.finished)
        {
            reloadSign.x = p.x + 10;
            reloadSign.y = p.y;
            reloadSign.draw();
        }
    }
    
    public function shoot(multipleShot:Bool = false) : Float
    {
        if (!multipleShot)
        {
            AmmunitionCurrent -= 1;
            shootTimerCurrent = shootTimerMax * shootTimerFactor;
        }
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
    
    public function doFireRatePickup () :Void 
    {
         AmmunitionCurrent = AmminutionMax;
         shootTimerFactor = 0.5;
         ReloadTimeFactor = 0.25;
         reloadTimer.reset(0.01);
         
         var t : FlxTimer = new FlxTimer(GameProperties.PickUpFireRateTime, resetFireRate);
    }
    
    public function resetFireRate(t:FlxTimer):Void
    {
        shootTimerFactor = 1.0;
        ReloadTimeFactor = 1.0;
    }
    
}