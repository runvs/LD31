package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
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
            lifetime = 4;
            makeGraphic(4, 8, FlxColorUtil.makeFromARGB(1.0, 250, 25, 250));
            FlxTween.tween(this.scale, { x:1.5, y:3.5 }, 2);
            FlxTween.tween(this, {alpha:0}, 2, {complete:deleteFromTween});
        }
        else
        {
            throw "Cannot determine shot type";
        }
	}
    
    public function push():FlxPoint
    {
        var v : FlxVector = new FlxVector (velocity.x, velocity.y);
        v.normalize();
        v.x *= getPushFactor();
        v.y *= getPushFactor();
        var retval :FlxPoint = new FlxPoint (v.x, v.y);
        return retval;
        
    }
    
    private function getPushFactor():Float
    {
        var retval : Float = 2.0;
        
        if (type == ShotType.Bullet)
        {
            retval = 55.0;
        }
        else if (type == ShotType.Flames)
        {
            retval = 0;
        }
        else if (type == ShotType.Laser)
        {
            retval = 50.0;
        }
        else if (type == ShotType.Microwave)
        {
            retval = 150.0;
        }
        else if (type == ShotType.Railgun)
        {
            retval = 5.0;
        }
        else if (type == ShotType.Rocket)
        {
            retval = 5.0;
        }
        return retval;
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
    
    public function deleteFromTween(t:FlxTween):Void
    {
        deleteObject();
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