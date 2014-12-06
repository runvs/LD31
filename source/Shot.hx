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

    private var damage : Float;
	public function new(X:Float=0, Y:Float=0, target : FlxPoint, d:Float) 
	{
		super(X, Y);
        
        damage = d;
        
		makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1.0, 250, 250, 250));
		
		var direction : FlxVector = new FlxVector(target.x - x, target.y - y);
		direction.normalize();
		velocity.x = direction.x * GameProperties.ShotMovementVelocity;
		velocity.y = direction.y * GameProperties.ShotMovementVelocity;
        alive = true;
	}
	
	public override function update(): Void
	{
		super.update();
	}
	
	public override function draw():Void
	{
		super.draw();
	}
	public function deleteObject():Void
    {
        alive = false;
        exists = false;
    }
    
    public function getDamage ():Float 
    {
        return damage;
    }
}