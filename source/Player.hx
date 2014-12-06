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
	
	private var shootTimerCurrent : Float;
	private var shootTimerMax : Float;
	
	private var healthCurrent : Float;
	private var healtMax : Float;

	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		makeGraphic(24, 24, FlxColorUtil.makeFromARGB(1.0, 125, 255, 125));
		
		shootTimerCurrent = shootTimerMax = GameProperties.PlayerShootDefaultTimer;
		
	}
	
	override public function update():Void 
	{
		super.update();
		getInput();
		doMovement();
			

		if (shootTimerCurrent >= 0)
		{
			shootTimerCurrent -= FlxG.elapsed;
		}
	}

	public override function draw() :Void
	{
		super.draw();
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
			if (shootTimerCurrent < 0)
			{
				shootTimerCurrent = shootTimerMax;
				trace ("shoot");
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
	
}