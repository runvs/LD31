package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class Player extends FlxSprite
{
	// this is the position, the mouse is currently at.
	private var targetPosition : FlxPoint;
	

	
	private var healthCurrent : Float;
	private var healtMax : Float;
    
    private var state:PlayState;
    
    private var weapon : Weapon;
    
    private var weaponManager : WeaponManager;

	
	public function new(X:Float=0, Y:Float=0, playState:PlayState) 
	{
		super(X, Y);
        
        state = playState;
        
		//makeGraphic(24, 24, FlxColorUtil.makeFromARGB(1.0, 125, 255, 125));
        loadGraphic(AssetPaths.player__png, true, 16, 16);
        animation.add("normal", [0], 30, true);
        animation.add("die", [1, 2, 3, 4, 5, 6, 7, 8, 9], 30, false);
        animation.play("normal");
        
        healthCurrent = healtMax = GameProperties.PlayerHealthDefault;
		
        weaponManager = new WeaponManager();
        weapon = weaponManager.microwavegun;       
        
	}
	
	override public function update():Void 
	{
		super.update();
		getInput();
		doMovement();
        
        weapon.update();
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
		}
        trace(weapon.shootTimerCurrent);
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
    
	
	private function doMovement() : Void
	{
		velocity.x *= GameProperties.PlayerMovementVelocityDrag;
        velocity.y *= GameProperties.PlayerMovementVelocityDrag;
		
		// turning stuff
		var dir :FlxVector = new FlxVector( targetPosition.x - x, targetPosition.y - y );
        
		angle = dir.degrees;
	}
	
}