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
	
	private var shotList : FlxTypedGroup<Shot>;
    
    private var pickupList :FlxTypedGroup<Pickup>;
	
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
		player = new Player(125, 125, this);

		enemyList = new FlxTypedGroup<Enemy>();
		
		spawner = new EnemySpawner(this);
		add(spawner);
        
		shotList = new FlxTypedGroup<Shot>();
        
        pickupList = new FlxTypedGroup<Pickup>();
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
        
        cleanUp();
        
        
        
        player.update();
        
        for (j in 0 ... shotList.length)
		{
            var s:Shot = shotList.members[j];
            s.update();
        }
        
        for (j in 0 ... enemyList.length)
        {
            var e:Enemy = enemyList.members[j];
            e.update();
        }
        for (j in 0 ... pickupList.length)
        {
            var p:Pickup = pickupList.members[j];
            p.update();
            
            if (FlxG.overlap(p, player))
            {
                player.pickUp(p.type);
                p.alive = p.exists = false;
            }
        }
        
        doCollisions();
        
	}	
    
    override public function draw():Void
    {
        super.draw();
        
        player.draw();
        
        for (j in 0 ... enemyList.length)
        {
            var e:Enemy = enemyList.members[j];
            e.draw();
        }
        
        for (j in 0... pickupList.length)
		{
            var p:Pickup= pickupList.members[j];
            p.draw();
        }
        
        for (j in 0... shotList.length)
		{
            var s:Shot = shotList.members[j];
            s.draw();
        }
        
        
        
        player.drawHUD();
    }
    
    private function cleanUp():Void
    {
        {
			var newShotList:FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
			shotList.forEach(function(s:Shot) { if (s.alive) newShotList.add(s); else s.destroy(); } );
            shotList = newShotList;
		}
        
        {
            var newEnemyList:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
            enemyList.forEach(function(e:Enemy) { if (e.alive) { newEnemyList.add(e); }} );
            enemyList = newEnemyList;
        }
        
         {
            var newPickupList:FlxTypedGroup<Pickup> = new FlxTypedGroup<Pickup>();
            pickupList.forEach(function(p:Pickup) { if (p.alive) { newPickupList.add(p); }} );
            pickupList = newPickupList;
        }
    }
    
    private function doCollisions ():Void
    {
        for (j in 0... shotList.length)
		{
            var s:Shot = shotList.members[j];
			if (s.alive && s.exists )
			{
                for (i in 0...enemyList.length)
                {
                    var e:Enemy = enemyList.members[i];
                    if (!(e.alive && e.exists))
                    {
                        continue;
                    }
                    if (FlxG.overlap(e, s))
                    {
                        if (FlxG.pixelPerfectOverlap(e, s,1))
                        {
                            shotEnemyCollision(e, s);
                        }
                    }
                }
            }
        }
    }
    
    public function shotEnemyCollision (e:Enemy, s:Shot):Void
	{
        
        var push = s.push();
		e.velocity.x += push.x;
        e.velocity.y += push.y;
        
        e.takeDamage(s.getDamage());
        s.deleteObject();
	}

    
    public function spawnShot(s:Shot) : Void
    {
        shotList.add(s);
    }
	
	public function spawnEnemy(e:Enemy) : Void
	{
		enemyList.add(e);
	}
        
    public function spawnPickup (p:Pickup) : Void
    {
        pickupList.add(p);
    }
	
	public function getPlayerPosition () : FlxPoint
	{
		var p :FlxPoint = new FlxPoint(player.x, player.y);
		return p;
	}

    
}