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
class Shot extends FlxSprite
{

    private var damage : Float;
    
    private var lifetime:Float;
    
    private var type : ShotType;
    
	public function new(X:Float=0, Y:Float=0, target : FlxPoint, w:Weapon) 
	{
		super(X, Y);
                
        
        
        damage = w.getDamage();
        
        var direction : FlxVector = new FlxVector(target.x - x, target.y - y);
        direction.normalize();
        velocity.x = direction.x * w.ShotSpeed;
		velocity.y = direction.y * w.ShotSpeed;
        
        angle = direction.degrees;
        
        type = w.type;
         lifetime = 10;
        
        if (type == ShotType.Bullet)
        {
            makeGraphic(4, 4, FlxColorUtil.makeFromARGB(1.0, 250, 250, 250));	
        }
		else if (type == ShotType.Microwave)
        {
            makeGraphic(4, 8, FlxColorUtil.makeFromARGB(1.0, 250, 25, 250));	
        }


        
        
	}
	
	public override function update(): Void
	{
		super.update();
        lifetime -= FlxG.elapsed;
        if (lifetime < 0)
        {
            alive = false;
        }
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