package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var player: Player;
	
	private var enemyList : FlxTypedGroup<Enemy>;
	private var spawner : EnemySpawner;
	
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		player = new Player(125, 125);
		add(player);
		
		enemyList = new FlxTypedGroup<Enemy>();
		add(enemyList);
		
		spawner = new EnemySpawner(this);
		add(spawner);
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();
	}	
	
	public function spawnEnemy(e:Enemy) : Void
	{
		enemyList.add(e);
	}
	
	public function getPlayerPosition () : FlxPoint
	{
		var p :FlxPoint = new FlxPoint(player.x, player.y);
		return p;
	}
}