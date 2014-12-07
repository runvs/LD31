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
        pistol.AmminutionMax = pistol.AmmunitionCurrent  = 12;
        pistol.DamageBase = 4;
        pistol.ReloadTime = 1.5;// Reload Time in Seconds
        pistol.ShotsFired = 1;
        pistol.Spread = 2.0;
        pistol.ShotSpeed = 400;
        pistol.type = ShotType.Bullet;
        pistol.name = "pistol";
        
        
        machinegun = new Weapon();
        machinegun.shootTimerMax  = 0.1;
        machinegun.AmminutionMax  = machinegun.AmmunitionCurrent = 30;
        machinegun.DamageBase = 2;
        machinegun.ReloadTime = 3.5;// Reload Time in Seconds
        machinegun.ShotsFired = 1;
        machinegun.Spread = 3.0;
        machinegun.ShotSpeed = 600;
        machinegun.type = ShotType.Bullet;
        machinegun.name = "machinegun";
        
        shotgun = new Weapon();
        shotgun.shootTimerMax  = 0.8;
        shotgun.AmminutionMax   = shotgun.AmmunitionCurrent = 5;
        shotgun.DamageBase = 3;
        shotgun.ReloadTime = 3.5;// Reload Time in Seconds
        shotgun.ShotsFired = 5;
        shotgun.Spread = 12.0;
        shotgun.ShotSpeed = 500;
        shotgun.type = ShotType.Bullet;
        shotgun.name = "shotgun";
        
        microwavegun = new Weapon();
        microwavegun.shootTimerMax  = 0.2;
        microwavegun.AmminutionMax   = microwavegun.AmmunitionCurrent = 20;
        microwavegun.DamageBase = 1.5;
        microwavegun.ReloadTime = 0.25 ;// Reload Time in Seconds
        microwavegun.ShotsFired = 1;
        microwavegun.Spread = 2.0;
        microwavegun.ShotSpeed = 350;
        microwavegun.type = ShotType.Microwave;
        microwavegun.name = "microwave";
    }
    
    public var pistol : Weapon;
    public var machinegun : Weapon;
    public var shotgun : Weapon;
    public var microwavegun : Weapon;
    
}