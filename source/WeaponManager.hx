package ;

/**
 * ...
 * @author ...
 */
class WeaponManager
{

    
    public function new() 
    {
        pistol = new Weapon();
        pistol.shootTimerMax  = 0.6;
        pistol.AmminutionMax  = 6;
        pistol.DamageBase = 4;
        pistol.ReloadTime = 1.5;// Reload Time in Seconds
        pistol.ShotsFired = 1;
        pistol.Spread = 2.0;
        pistol.ShotSpeed = 400;
        pistol.reload();
        
        machinegun = new Weapon();
        machinegun.shootTimerMax  = 0.1;
        machinegun.AmminutionMax  = 30;
        machinegun.DamageBase = 2;
        machinegun.ReloadTime = 3.5;// Reload Time in Seconds
        machinegun.ShotsFired = 1;
        machinegun.Spread = 3.0;
        machinegun.ShotSpeed = 600;
        machinegun.reload();
    }
    
    public var pistol : Weapon;
    public var machinegun : Weapon;
    
}