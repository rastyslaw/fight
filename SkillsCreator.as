/**
 * Author: rastyslaw
 * Date: 17.07.2014
 * Time: 17:23
 */
package src.mvcs.view.skills {

	public class SkillsCreator extends AbstractCreator {
		
		public static const FIREBALL:uint 	     = 1;
		public static const HEAL:uint 	         = 2;
		public static const FURY:uint 	         = 3;
		public static const ICE_ARMOR:uint 	     = 4;
		public static const CAMOUFLAGE:uint      = 5;
		public static const SNOWBALL:uint        = 6;
		public static const ICE_BLOCK:uint       = 7;
		public static const ICICLES:uint         = 8;
		public static const KICK_HORNS:uint      = 9;

		override public function creating(id: uint):IIcon {
			switch(id) {
				case FIREBALL:
					return new Petard();
				break;
				case HEAL:
					return new Heal();
				break;
				case FURY:
					return new Fury();
				break;
				case ICE_ARMOR:
					return new IceArmor();
				break;
				case CAMOUFLAGE:
					return new Camouflage();
				break;
				case SNOWBALL:
					return new SnowBall();
				break;
				case ICE_BLOCK:
					return new IceBlock();
				break;
				case ICICLES:
					return new Icicles();
				break;
				case KICK_HORNS:
					return new KickHorns();
				break;
			default:
				throw new Error("Invalid id");
			}
		} 
		
	}
}