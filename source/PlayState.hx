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

    private var _player: Player;

    private var _enemyList : FlxTypedGroup<Enemy>;
    private var _spawner : EnemySpawner;

    private var _shotList : FlxTypedGroup<Shot>;

    private var _backgroundSprite : FlxSprite;

    /**
     * Function that is called up when to state is created to set it up. 
     */
    override public function create():Void
    {
        super.create();
        _player = new Player(125, 125, this);
        
        _backgroundSprite = new FlxSprite();
        _backgroundSprite.loadGraphic(AssetPaths.background__png);

        _enemyList = new FlxTypedGroup<Enemy>();
        
        _spawner = new EnemySpawner(this);
        add(_spawner);
        
        _shotList = new FlxTypedGroup<Shot>();
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
        
        _player.update();
        
        for (j in 0 ... _shotList.length)
        {
            var s:Shot = _shotList.members[j];
            s.update();
        }
        
        for (j in 0 ... _enemyList.length)
        {
            var e:Enemy = _enemyList.members[j];
            e.update();
        }
        
        doCollisions();
    }

    override public function draw():Void
    {
        super.draw();
        
        // Draw background sprites
        var i = 0.0;
        while (i <= 1280)
        {
            var j = 0.0;
            while (j <= 720)
            {
                _backgroundSprite.x = i;
                _backgroundSprite.y = j;
                _backgroundSprite.draw();
                
                j += _backgroundSprite.height;
            }
            
            i += _backgroundSprite.width;
        }
        
        _player.draw();
        
        for (j in 0 ... _enemyList.length)
        {
            var e:Enemy = _enemyList.members[j];
            e.draw();
        }
        
        for (j in 0... _shotList.length)
        {
            var s:Shot = _shotList.members[j];
            s.draw();
        }
        
        _player.drawHUD();
    }

    private function cleanUp():Void
    {
        var newShotList:FlxTypedGroup<Shot> = new FlxTypedGroup<Shot>();
        _shotList.forEach(function(s:Shot) s.alive ? newShotList.add(s) : s.destroy() );
        _shotList = newShotList;
        
        var newEnemyList:FlxTypedGroup<Enemy> = new FlxTypedGroup<Enemy>();
        _enemyList.forEach(function(e:Enemy) { if (e.alive) { newEnemyList.add(e); }} );
        _enemyList = newEnemyList;
    }

    private function doCollisions ():Void
    {
        for (j in 0... _shotList.length)
        {
            var s:Shot = _shotList.members[j];
            if (s.alive && s.exists )
            {
                for (i in 0..._enemyList.length)
                {
                    var e:Enemy = _enemyList.members[i];
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
        //addExplosion(new Explosion(s.sprite.x - 4, s.sprite.y - 6, true));
        s.deleteObject();
        
        var push = s.push();
        e.velocity.x += push.x;
        e.velocity.y += push.y;
        
        e.takeDamage(s.getDamage());
    }


    public function spawnShot(s:Shot) : Void
    {
        _shotList.add(s);
    }

    public function spawnEnemy(e:Enemy) : Void
    {
        _enemyList.add(e);
    }

    public function getPlayerPosition () : FlxPoint
    {
        var p :FlxPoint = new FlxPoint(_player.x, _player.y);
        return p;
    }
}