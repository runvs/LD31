package ;

import flixel.FlxSprite;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class Shot extends FlxSprite
{

	public function new(X:Float=0, Y:Float=0, target : FlxPoint) 
	{
		super(X, Y);
		makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1.0f, 250, 250, 250));
		
		var direction : FlxVector = new FlxVector(target.x - x, target.y - y);
		direction.normalize();
		velocity.x = direction.x * GameProperties.ShotMovementSpeed;
		velocity.x = direction.y * GameProperties.ShotMovementSpeed;
	}
	
	public override function update(): Void
	{
		super.update
	}
	
	public override function draw():Void
	{
		super.draw();
	}
	
}