package ;

import flixel.FlxObject;
import flixel.util.FlxPoint;

/**
 * ...
 * @author ...
 */
class EnemySpawner extends FlxObject
{
	
	private var state : PlayState;
	
	
	
	
		
	public function new(playstate:PlayState) 
	{
		super();
		state = playstate;
		
		spawnEnemy();
		
	}
	
	override public function update () :Void 
	{
		super.update();
		
		
	}
	
	private function getRandomSpawnPosition ():FlxPoint
	{
		var p :FlxPoint = new FlxPoint();
		// TODO add randomized function
		return p;
	}
	
	
	private function spawnEnemy () : Void 
	{
		var pos : FlxPoint = getRandomSpawnPosition();
		var e :Enemy = new Enemy(pos.x, pos.y, state);
		
		state.spawnEnemy(e);
	}
	
	
	
}