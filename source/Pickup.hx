package ;

import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Laguna
 */
class Pickup extends FlxSprite
{
    
    private static _recursionDepth:Int; // for constraining picking up random pickup up picker. Hope you picked that 
    public static function getRandomPickupType (state:PlayState, first:Bool = true): PickupType
    {
        if (first)
        {
            _recursionDepth = 0;
        }
        else 
        {
            _recursionDepth += 1;
        }
        var maxNumber = PickupType.getConstructors().length -1;  // ugly but at least dynamic        
        
        var retval: PickupType = PickupType.createByIndex(FlxRandom.intRanged(0, maxNumber));
        if (state.getPlayerHasWeapon())
        {
            if (retval == PickupType.PickupWeaponPistol || retval == PickupType.PickupWeaponMachinegun || retval == PickupType.PickupWeaponShotgun || || retval == PickupType.PickupWeaponMicrowavegun)
            {
                if ( _recursionDepth < 3)
                {
                    retval = getRandomPickupType(state, false);
                }
            }
        }
        return retval;
    }
    
    
    public var type :PickupType;
    
    private var numberOfRemainingFlashLoops :Int;
    
       
    public function new(X:Float=0, Y:Float=0, pickupType:PickupType) 
    {
        super(X, Y);
		
        type = pickupType;
        
        if (type == PickupType.PickupWeaponPistol)
        {
            loadGraphic(AssetPaths.pickup_pistol__png, false, 32, 32);
        }
        else if (type == PickupType.PickupWeaponMachinegun)
        {
            loadGraphic(AssetPaths.pickup_machinegun__png, false, 32, 32);
        }
        else if (type == PickupType.PickupWeaponShotgun)
        {
            loadGraphic(AssetPaths.pickup_shotgun__png, false, 32, 32);
        }
        else if (type == PickupType.PickupWeaponMicrowavegun)
        {
            loadGraphic(AssetPaths.pickup_microwavegun__png, false, 32, 32);
        }
        else if  (type == PickupType.PickupHeal)
        {
            loadGraphic(AssetPaths.pickup_heal__png, false, 32, 32);
        }
        else if  (type == PickupType.PickupFirerate)
        {
            loadGraphic(AssetPaths.pickup_firerate__png, false, 32, 32);
        }
        else if  (type == PickupType.PickupShield)
        {
            loadGraphic(AssetPaths.pickup_shield__png, false, 32, 32);
        }
        else if  (type == PickupType.PickupSlowMotion)
        {
            loadGraphic(AssetPaths.pickup_slowmotion__png, false, 32, 32);
        }
        else
        {
            throw "could not determine pickup type. BAM!";
        }
        
        var t : FlxTimer  = new FlxTimer(GameProperties.PickupLifeTime, switchToFade);
        numberOfRemainingFlashLoops = 4;
    }
    
    public function switchToFade (t:FlxTimer):Void
    {
        FlxTween.tween(this, { alpha:0.5 }, 0.5, { complete:fadeUp } );
    }
    
    public function fadeUp(t:FlxTween):Void
    {
        FlxTween.tween(this, { alpha:1 }, 0.5, { complete:fadeDown } );
    }
    public function fadeDown(t:FlxTween):Void
    {
        numberOfRemainingFlashLoops -= 1;
        if (numberOfRemainingFlashLoops > 0)
        {
            FlxTween.tween(this, { alpha:(0.5 - ((4 - numberOfRemainingFlashLoops) * 0.1))}, 0.5, { complete:fadeUp } );
        } 
        else
        {
            FlxTween.tween(this, { alpha:0.0 }, 0.5, { complete:deleteObject } );
        }
    }
    public function deleteObject (t:FlxTween):Void
    {
        alive = false;
        exists = false;
    }
    
}