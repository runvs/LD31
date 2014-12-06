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
    
    public static function getRandomPickupType (): PickupType
    {
        var maxNumber = PickupType.getConstructors().length -1;  // ugly but at least dynamic        
        return PickupType.createByIndex(FlxRandom.intRanged(0, maxNumber));
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