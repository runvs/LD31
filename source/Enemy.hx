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
	
	private var state : PlayState;
	
	public function new(X:Float=0, Y:Float=0, playstate:PlayState) 
	{
		super(X, Y);
		
		state = playstate;
		
		makeGraphic(24, 24, FlxColorUtil.makeFromARGB(1.0, 255, 125, 125));
		targetPosition = new FlxPoint();
		
	}
	
	override public function update():Void 
	{
		super.update();
		getInput();
		doMovement();
		
		targetPosition = state.getPlayerPosition();
			
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
		velocity.x *= GameProperties.EnemyMovementVelocityDrag;
        velocity.y *= GameProperties.EnemyMovementVelocityDrag;
		
		// turning stuff
		
		var dir : FlxVector = new FlxVector( targetPosition.x - x, targetPosition.y - y );
		angle = dir.degrees;
		
		dir.normalize();
		
		velocity.x += dir.x * GameProperties.EnemyMovementVelocityAdd;
		velocity.y += dir.y * GameProperties.EnemyMovementVelocityAdd;
		
	}
	
}