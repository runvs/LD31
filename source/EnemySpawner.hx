package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxTimer;

/**
 * ...
 * @author ...
 */
class EnemySpawner extends FlxObject
{
	
	private var state : PlayState;
	private var spawnTimerCurrent : Float; // counting up
    private var currentMaxEnemies : Int;
		
	public function new(playstate:PlayState) 
	{
		super();
		state = playstate;
		
		spawnEnemy();
        
        spawnTimerCurrent = 0;
        currentMaxEnemies = 2;
        var t :FlxTimer  = new FlxTimer(5, increaseMaxEnemyNumber, 0);
		
	}
	
	override public function update () :Void 
	{
		super.update();
		
        spawnTimerCurrent += FlxG.elapsed;
        if (spawnTimerCurrent >= getSpawnTime())
        {
            spawnEnemy();
            spawnTimerCurrent = 0;
        }
		
	}
    
    private function getSpawnTime():Float
    {
        
        var currentEnemies : Float = state.getNumberOfEnemies();
        var exponent : Float = GameProperties.EnemySpawnerExponent;
        var retval : Float = (Math.pow(currentEnemies / currentMaxEnemies, exponent)) * GameProperties.EnemySpawnerMaxTime;
        return retval;

    }
    
	
	private function getRandomSpawnPosition ():FlxPoint
	{
		var p :FlxPoint = new FlxPoint();
		// TODO add randomized function
        var side :Int = FlxRandom.intRanged(0, 3);
        
        if (side == 0)
        {
            // top
            var pos :Float = FlxRandom.floatRanged( -10, 1290);
            p = new FlxPoint(pos, -GameProperties.SpawnerOutScreenOffset);
        }
        else if (side == 1)
        {
            // bottom
            var pos :Float = FlxRandom.floatRanged( -10, 1290);
            p = new FlxPoint(pos,  720 + GameProperties.SpawnerOutScreenOffset);
        }
        else if (side == 2)
        {
            // left
            var pos :Float = FlxRandom.floatRanged( -10, 730);
            p = new FlxPoint(-GameProperties.SpawnerOutScreenOffset, pos);
        }
        else if (side == 3)
        {
            // right
            var pos :Float = FlxRandom.floatRanged( -10, 730);
            p = new FlxPoint(1280 + GameProperties.SpawnerOutScreenOffset, pos);
        }
		return p;
	}
	
	
	private function spawnEnemy () : Void 
	{
		var pos : FlxPoint = getRandomSpawnPosition();
		var e :Enemy = new Enemy(pos.x, pos.y, state);
		
		state.spawnEnemy(e);
	}
    
    public function increaseMaxEnemyNumber (t:FlxTimer) :Void
    {
        currentMaxEnemies += 1;
        trace ("increase enemies");
    }
	
	
}