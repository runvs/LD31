package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author ...
 */
class EnemySpawner extends FlxObject
{
	
	private var state : PlayState;
	private var spawnTimerCurrent : Float; // counting up
		
	public function new(playstate:PlayState) 
	{
		super();
		state = playstate;
		
		spawnEnemy();
        
        spawnTimerCurrent = 0;
		
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
        // TODO Implement CombatDirector!
        return 2.5;
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
	
	
	
}