package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxSound;
import flixel.util.FlxColorUtil;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxVector;
import flixel.effects.FlxSpriteFilter;
import openfl._v2.filters.DropShadowFilter;

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
    
    private var _level : Float;
    private var _seed : Float;
    
    private var _personalVelocityAdd : Float;
    
    private var spriteFilter : FlxSpriteFilter;
    private var filter : DropShadowFilter;
	
	public function new(X:Float=0, Y:Float=0, playstate:PlayState, level:Float, seed:Float) 
	{
		super(X, Y);
		
		state = playstate;
        
        shootTimerCurrent = _shootTimerMax;
		
        _level = level;
        _seed = seed;
		
		//makeGraphic(24, 24, FlxColorUtil.makeFromARGB(1.0, 255, 125, 125));
        loadGraphic(AssetPaths.snowman__png, false, 32, 32);
		targetPosition = new FlxPoint();
        
        _healthCurrent = _healthMax = GameProperties.EnemyHealthDefault;
        
        soundHit = new FlxSound();
        soundHit = FlxG.sound.load(AssetPaths.hit__wav, 1.0, false, false, false);
		
        soundDie = new FlxSound();
        soundDie = FlxG.sound.load(AssetPaths.die__wav, 1.0, false, false, false);
        
        _personalVelocityAdd = GameProperties.EnemyMovementVelocityAdd * Math.pow(_level*0.5, 0.125) * (1.0 + _seed);
        
        
        filter = new DropShadowFilter(2, 45, 0, .5, 10, 10, 1, 1);
        spriteFilter = new FlxSpriteFilter(this, 0, 0);
		spriteFilter.addFilter(filter);
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
            
            // -1 complete right, +1 left
            var panPosition : Float = (x- 640.0) / 640.0 * GameProperties.SoundPanScale;
            soundHit.pan = panPosition;
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
		
		velocity.x += dir.x * _personalVelocityAdd;
		velocity.y += dir.y * _personalVelocityAdd;
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
            var p : Pickup = new Pickup(x, y, Pickup.getRandomPickupType(state));
            state.spawnPickup(p);
        }
    }
	
}