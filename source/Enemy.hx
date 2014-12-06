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
class Enemy extends FlxSprite
{
	
	// this is the position, where the player is currently at.
	private var targetPosition : FlxPoint;
	
	private var healthCurrent:Float;
	private var healtMax:Float;
	
	private var shootTimerCurrent :Float;
	private var shootTimerMax :Float;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		makeGraphic(24, 24, FlxColorUtil.makeFromARGB(1.0, 255, 125, 125));
		
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
		
	}
	private function doMovement() :Void
	{
		velocity.x *= GameProperties.PlayerMovementVelocityDrag;
        velocity.y *= GameProperties.PlayerMovementVelocityDrag;
		
		// turning stuff
		
		var dir : FlxVector = new FlxVector( targetPosition.x - x, targetPosition.y - y );
		angle = dir.degrees;
	}
	
}