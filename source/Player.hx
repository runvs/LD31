package ;

import flixel.effects.FlxSpriteFilter;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxTimer;
import flixel.util.FlxVector;
import openfl._v2.filters.DropShadowFilter;
import openfl._v2.filters.GlowFilter;

using flixel.util.FlxSpriteUtil;


/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
    // this is the position, the mouse is currently at.
    private var targetPosition : FlxPoint;
    
    public var healthCurrent : Float;
    private var _healthMax : Float;
    
    private var state:PlayState;
    
    private var weapon : Weapon;
    
    private var weaponManager : WeaponManager;
    
    // yeah, this should be in the weapon class, but here it is more useful.
    private var soundDeadMansClick : FlxSound;
    private var soundPickup : FlxSound;
    private var soundWalking : FlxSound;
    private var soundHit : FlxSound;
    private var soundShieldHit : FlxSound;
    
    private var _shieldSprite:FlxSprite;
    
    private var _shieldTimerRemaining:Float;
    private var _slowMotionTimer :FlxTimer;
    
    #if !web
    private var spriteFilter : FlxSpriteFilter;
    private var filter : DropShadowFilter;
    private var filterShield : GlowFilter;
    #end
    private var healthBar : FlxSprite;


    public function new(X:Float=0, Y:Float=0, playState:PlayState) 
    {
        super(X, Y);
        
        state = playState;
        
        loadGraphic(AssetPaths.player__png, true, 16, 16);
        animation.add("normal", [0], 30, true);
        animation.add("die", [1, 2, 3, 4, 5, 6, 7, 8, 9], 30, false);
        animation.play("normal");
        
        healthCurrent = _healthMax = GameProperties.PlayerHealthDefault;
        
        _shieldSprite = new FlxSprite();
        _shieldSprite.loadGraphic(AssetPaths.shield__png, true, 16, 16);
        _shieldSprite.animation.add("normal", [0, 1, 2, 3], 12, true);
        _shieldSprite.animation.play("normal");
        
        
        soundDeadMansClick = new FlxSound();
        soundDeadMansClick = FlxG.sound.load(AssetPaths.deadmansclick2__wav, 1.0, false, false, false);
        
        soundPickup = new FlxSound();
        soundPickup = FlxG.sound.load(AssetPaths.pickup__wav, 1.0, false, false, false);
        
        soundHit  = new FlxSound();
        soundHit = FlxG.sound.load(AssetPaths.playerhit__wav, 1.0, false, false, false);
        
        soundShieldHit = new FlxSound();
        soundShieldHit = FlxG.sound.load(AssetPaths.playerhit_shield__wav, 1.0, false, false, false);
        
        soundWalking = new FlxSound();
        #if flash
        soundWalking = FlxG.sound.load(AssetPaths.walking__mp3, 0.25 ,true , false ,true);
        #else
        soundWalking = FlxG.sound.load(AssetPaths.walking__ogg, 0.25 ,true , false ,true);
        #end
        
        
        
        weaponManager = new WeaponManager();
        weapon = weaponManager.pistol;
        
        _shieldTimerRemaining = -1.0;
        _slowMotionTimer = null;
        #if !web
        filter = new DropShadowFilter(2, 45, 0, .5, 10, 10, 1, 1);
        spriteFilter = new FlxSpriteFilter(this, 0, 0);
		spriteFilter.addFilter(filter);
        
        filterShield = new GlowFilter(FlxColorUtil.makeFromARGB(1.0, 178, 206, 161), 1.0, 12.5, 12.5, 1.5, 1);  // will be added in pickup
        #end
        
        healthBar = new FlxSprite();
        healthBar.makeGraphic(32, 720, FlxColorUtil.makeFromARGB(1.0, 96, 33, 31));
        healthBar.origin = new FlxPoint(0, 720);
        healthBar.x = 0;
        healthBar.y = 0;
        healthBar.scrollFactor.x = 0;
        healthBar.scrollFactor.y = 0;
        
    }
	
	override public function update():Void 
	{
		super.update();
        _shieldSprite.x = x;
        _shieldSprite.y = y;
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
        _shieldSprite.update();
        
        if (_shieldTimerRemaining > 0)
        {
            _shieldTimerRemaining -= FlxG.elapsed;
        }
        
        var panPosition : Float = (x- 640.0) / 640.0 * GameProperties.SoundPanScale;
        soundWalking.pan = panPosition;
        soundDeadMansClick.pan = panPosition;
        soundPickup.pan = panPosition;
        
        
	}

	public override function draw() :Void
	{
		super.draw();
        if (_shieldTimerRemaining >= 0)
        {
            _shieldSprite.draw();
        }
        healthBar.draw();
	}
    
    public function drawHUD():Void
    {
        weapon.draw();
        
        drawHealthBar();
        
    }
	
    private function drawHealthBar() : Void
    {
        
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
            
            if (_shieldTimerRemaining < 0)
            {
                healthCurrent -= GameProperties.EnemyShootDamage;
                
                FlxTween.tween(healthBar.scale, { y : healthCurrent / _healthMax }, 0.75,  { ease: FlxEase.cubeInOut} );
                
                FlxG.camera.shake(0.0075, 0.2);
                FlxG.camera.flash(FlxColorUtil.makeFromARGB(0.4, 96, 33, 31), 0.2);
                soundHit.play();
            }
            else
            {
                soundShieldHit.play();
            }
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
        else if (type == PickupType.PickupShield)
        {
            _shieldTimerRemaining = GameProperties.PickupShieldTime;
            #if !web
            var t : FlxTimer = new FlxTimer(GameProperties.PickupShieldTime, function (t:FlxTimer) { spriteFilter.removeFilter(filterShield); } );
            spriteFilter.addFilter(filterShield);
            #end
        }
        else if (type == PickupType.PickupSlowMotion)
        {
            FlxTween.tween(FlxG, { timeScale:GameProperties.PickupSlowMotionTimeFactor }, 0.125);
            
            if (_slowMotionTimer == null )
            {
                _slowMotionTimer = new FlxTimer(GameProperties.PickupSlowMotionTime, resetSlowMotion);
            }
            else 
            {
                _slowMotionTimer.reset();
            }
        }
    }
    
    private function healfull():Void
    {
        FlxG.camera.flash(FlxColorUtil.makeFromARGB(0.25, 189, 221, 184), 0.5);
        healthCurrent = _healthMax;
         FlxTween.tween(healthBar.scale, { y : healthCurrent / _healthMax }, 0.75,  { ease: FlxEase.cubeInOut} );
    }
	
    public function resetSlowMotion (t:FlxTimer) : Void
    {
        FlxTween.tween(FlxG, { timeScale:1.0 }, 0.35);
    }
    
    public function getHasWeapon() :Bool
    {
        if (weapon.name == "pistol")
        {
            return false;
        }
        return true;
    }
    
    public function stopSound ():Void
    {
        soundWalking.volume = 0;
    }
   
}