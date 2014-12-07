package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;

/**
 * ...
 * @author ...
 */
class Enemy extends FlxSprite
{
	
	// this is the position, where the player is currently at.
	private var targetPosition : FlxPoint;
	
	private var _healthCurrent:Float;
	private var _healthMax:Float;
	
	public var shootTimerCurrent : Float;
	private var _shootTimerMax : Float = GameProperties.EnemyShootTimerMax;
	
	private var state : PlayState;
    
    private var soundHit : FlxSound;
    private var soundDie : FlxSound;
	
	public function new(X:Float=0, Y:Float=0, playstate:PlayState) 
	{
		super(X, Y);
		
		state = playstate;
        
        shootTimerCurrent = _shootTimerMax;
		
		//makeGraphic(24, 24, FlxColorUtil.makeFromARGB(1.0, 255, 125, 125));
        loadGraphic(AssetPaths.snowman__png, false, 32, 32);
		targetPosition = new FlxPoint();
        
        _healthCurrent = _healthMax = GameProperties.EnemyHealthDefault;
        
        soundHit = new FlxSound();
        soundHit = FlxG.sound.load(AssetPaths.hit__wav, 1.0, false, false, false);
		
        soundDie = new FlxSound();
        soundDie = FlxG.sound.load(AssetPaths.die__wav, 1.0, false, false, false);
        
	}
	
	override public function update():Void 
	{
        if (alive)
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
    
    public function takeDamage (damage:Float)
    {
        _healthCurrent -= damage;
        checkDead();
        soundHit.play(false);
    }
    
    public function resetShootTimer() : Void
    {
        shootTimerCurrent += _shootTimerMax;
    }
    
    public function checkDead() : Void
    {
        if (_healthCurrent <= 0)
        {
            alive = false;
            soundDie.play(false);
            spawnPickup();
        }
    }
    
    private function spawnPickup() :Void
    {
        if (FlxRandom.chanceRoll(GameProperties.PickupDropProbability*100.0))   // whysoever they want it in percent and not between 0.0 and 1.0
        {
            var p : Pickup = new Pickup(x, y, Pickup.getRandomPickupType());
            state.spawnPickup(p);
        }
    }
	
}