package ;

/**
 * ...
 * @author ...  
 */
class GameProperties
{
	public static var PlayerMovementVelocityAdd : Float = 15;
	public static var PlayerMovementVelocityDrag : Float = 0.9;
	public static var PlayerHealthDefault : Float = 15;
    
	public static var EnemyMovementVelocityAdd : Float = 1.8;
	public static var EnemyMovementVelocityDrag : Float = 0.96;
    public static var EnemyHealthDefault : Float  = 10;
    
    public static var EnemyShootDamage : Float = 4;
    public static var EnemyShootTimerMax : Float = 1.0;
    
    public static var EnemySpawnerExponent : Float = 2.5;
    public static var EnemySpawnerMaxTime : Float = 2.5;
    public static var EnemySpawnerTimeTilIncrease : Float = 2.5;
    public static var EnemySpawnerLevelExponent : Float = 1.5;
    
    public static var SpawnerOutScreenOffset : Float = 100;
    
    public static var PickupDropProbability : Float = 0.4;  
    public static var PickupLifeTime : Float = 2.5;
    
    public static var PickUpFireRateTime : Float = 5; // how long the increase lasts
    public static var PickupShieldTime : Float = 5; // how long the shield lasts    
    
    public static var PickupSlowMotionTimeFactor : Float = 0.35;
    public static var PickupSlowMotionTime : Float = 3.0; // how long (in scaled time units) the slowmotion will take
    
    public static var SoundPanScale : Float = 0.6;
	
}