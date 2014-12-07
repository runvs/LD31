package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

using flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
    // this is the position, the mouse is currently at.
    private var targetPosition : FlxPoint;
    
    private var _healthCurrent : Float;
    private var _healthMax : Float;
    
    private var state:PlayState;
    
    private var weapon : Weapon;
    
    private var weaponManager : WeaponManager;
    
    // yeah, this should be in the weapon class, but here it is more useful.
    private var soundDeadMansClick : FlxSound;
    private var soundPickup : FlxSound;
    private var soundWalking : FlxSound;


    public function new(X:Float=0, Y:Float=0, playState:PlayState) 
    {
        super(X, Y);
        
        state = playState;
        
        loadGraphic(AssetPaths.player__png, true, 16, 16);
        animation.add("normal", [0], 30, true);
        animation.add("die", [1, 2, 3, 4, 5, 6, 7, 8, 9], 30, false);
        animation.play("normal");
        
        _healthCurrent = _healthMax = GameProperties.PlayerHealthDefault;
        
        soundDeadMansClick = new FlxSound();
        soundDeadMansClick = FlxG.sound.load(AssetPaths.deadmansclick2__wav, 1.0, false, false, false);
        
        soundPickup = new FlxSound();
        soundPickup = FlxG.sound.load(AssetPaths.pickup__wav, 1.0, false, false, false);
        
        soundWalking = new FlxSound();
        soundWalking = FlxG.sound.load(AssetPaths.walking__ogg, 0.25 ,true , false ,true);
        
        weaponManager = new WeaponManager();
        weapon = weaponManager.microwavegun;
    }
	
	override public function update():Void 
	{
		super.update();
		getInput();
		doMovement();
        
        weapon.update();
        var velo : FlxVector = new FlxVector(velocity.x, velocity.y);
        if (velo.length > 50)
        {
            soundWalking.volume = 0.25;
        }
        else
        {
            soundWalking.volume = 0.0;
        }
	}

	public override function draw() :Void
	{
		super.draw();
        
	}
    
    public function drawHUD():Void
    {
        weapon.draw();
    }
	
	private function getInput() :Void
	{
		var up:Bool = FlxG.keys.anyPressed(["W", "UP"]);
        var down:Bool = FlxG.keys.anyPressed(["S", "DOWN"]);
        var left:Bool = FlxG.keys.anyPressed(["A", "LEFT"]);
        var right:Bool = FlxG.keys.anyPressed(["D", "RIGHT"]);
		var shot:Bool = FlxG.mouse.pressed;
        var shoodDMC:Bool = FlxG.mouse.justPressed;
		var reload:Bool = FlxG.mouse.justPressedRight;
		
		targetPosition = FlxG.mouse.getWorldPosition(FlxG.camera);
		
		if (!(left && right))
        {
            if (left)
            {
				
                velocity.x -= GameProperties.PlayerMovementVelocityAdd;
            }
            else if (right)
            {
                velocity.x += GameProperties.PlayerMovementVelocityAdd;
            }
        }
        
        if (!(up && down))
        {
            if (up)
            {
                velocity.y -= GameProperties.PlayerMovementVelocityAdd;
            }
            else if (down)
            {
                velocity.y += GameProperties.PlayerMovementVelocityAdd;
            }
        }
		
		if (shot)
		{
			if (weapon.canShoot())
			{
                shoot();
			}		
            else
            {
              
            }
		}
        
        if (shoodDMC)
        {
            if (!weapon.canShoot())
            {
                if (weapon.AmmunitionCurrent <= 0)
                {
                    soundDeadMansClick.play();
                }
            }
        }
        
        //trace(weapon.shootTimerCurrent);
        if (reload)
        {
            weapon.reload();
        }

	}
    
    private function shoot () : Void 
    {
        var startX : Float = x + width / 2;
        var startY :Float  = y + height / 2;
        
        var s: Shot  = new Shot(startX, startY, 
                                weapon.calculateWeaponSpread(startX, startY, targetPosition), 
                                weapon);
        weapon.shoot();
        state.spawnShot(s);
        for (i in 1 ... weapon.ShotsFired)
        {
            s = new Shot(startX, startY, 
                        weapon.calculateWeaponSpread(startX, startY, targetPosition), 
                        weapon);
            state.spawnShot(s);
            weapon.shoot(true);
        }
    }
    
    public function getHit(e:Enemy)
    {
        // Check if enemy can hit the player
        if (e.shootTimerCurrent <= 0.0)
        {
            e.resetShootTimer();
            
            _healthCurrent -= GameProperties.EnemyShootDamage;
        }
    }
    
	private function doMovement() : Void
	{
		velocity.x *= GameProperties.PlayerMovementVelocityDrag;
        velocity.y *= GameProperties.PlayerMovementVelocityDrag;
		
		// turning stuff
		var dir :FlxVector = new FlxVector( targetPosition.x - x, targetPosition.y - y );
        
		angle = dir.degrees;
	}
    
    public function pickUp (type :PickupType)
    {
        soundPickup.play();
        if (type == PickupType.PickupWeaponPistol)
        {
            weapon = weaponManager.pistol;
        }
        else if (type == PickupType.PickupWeaponMachinegun)
        {
            weapon = weaponManager.machinegun;
        }
        else if (type == PickupType.PickupWeaponShotgun)
        {
            weapon = weaponManager.shotgun;
        }
        else if (type == PickupType.PickupWeaponMicrowavegun)
        {
            weapon = weaponManager.microwavegun;
        }
        else if (type == PickupType.PickupHeal)
        {
            healfull();
        }
        else if (type == PickupType.PickupFirerate)
        {
            weapon.doFireRatePickup();
            
        }
    }
    
    private function healfull():Void
    {
        FlxG.camera.flash(FlxColorUtil.makeFromARGB(0.25, 189, 221, 184), 0.5);
        _healthCurrent = _healthMax;
    }
	
}