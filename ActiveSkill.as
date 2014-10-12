/**
 * Author: rastyslaw
 * Date: 25.08.2014
 * Time: 14:14
 */
package src.mvcs.view.skills
{
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;

	import dragonBones.Bone;
	import dragonBones.events.AnimationEvent;
	import dragonBones.events.FrameEvent;

	import flash.errors.IllegalOperationError;

	import flump.display.Movie;

	import org.osflash.signals.Signal;

	import src.mvcs.nameStorage.ItemTypes;
	import src.mvcs.view.character.Character;
	import src.utils.ColorFilter;

	import starling.display.Image;
	import starling.display.Sprite;

	public class ActiveSkill extends Sprite implements ISkill, IObserver, IIcon
	{
		private var _levelUpSignal:Signal;
		private var _destroySignal:Signal;
		private var _damageSignal:Signal;
		private var _useSkillSignal:Signal;
		private var _disabledChangeSignal:Signal;
		private var _id:String;
		private var _level:int;
		private var _icon:Image;
		private var _iconContainer:Sprite;
		private var _description:String;
		private var _title:String;
		private var _damage:int;
		private var _infoDamage:String;
		private var _target:Character;
		private var _maxTurn:int;
		private var _waitTurn:int;
		private var _disabled:Boolean;
		private var _effect:uint;
		private var _anim:Boolean;
		private var _price:int;
		protected var _percent:Number = 0;
		protected var targets:Vector.<Character>;
		private var _colorFilter:ColorFilter;
		protected var _movie:Movie;
		protected var frameId:String;

		public function ActiveSkill()
		{
			_destroySignal = new Signal();
			_damageSignal = new Signal();
			_levelUpSignal = new Signal();
			_useSkillSignal = new Signal();
			_disabledChangeSignal = new Signal(Boolean);
			_colorFilter = new ColorFilter();
			frameId = Character.STATE_SPELL;
		}

		public function get waitTurn():int {
			return _waitTurn;
		}

		public function set waitTurn(value:int):void
		{
			_waitTurn = value;
			if(_waitTurn == 0){
				disabled = false;
				_waitTurn = _maxTurn;
			}
		}

		protected function throwAnimation(remove: Boolean = false):void
		{
			var mainBone:Bone = target.armature.getBone("throw_weapon");
			var weapon_bone:Bone = mainBone.childArmature.getBone(ItemTypes.WEAPON);

			if(weapon_bone.display != null){
				weapon_bone.display.dispose();
				weapon_bone.display = null;
			}

			if(!remove && _movie != null){
				weapon_bone.display = _movie;
				_movie.goTo(1);
				_movie.playOnce();
			}
		}

		protected function applyEffects(target: Character):void
		{
			if(effect == 0 || target.hp <= 0)
			{
				return;
			}
			if(Math.random() < percent/100){
				target.setEffect(effect, {remove: 0});
			}
		}

		public function cast(targets: Vector.<Character>):void {
			this.targets = targets;
			disabled = true;
			_useSkillSignal.dispatch();

			target.armature.addEventListener(FrameEvent.MOVEMENT_FRAME_EVENT, armMovementHandler);
			target.armature.addEventListener(AnimationEvent.COMPLETE, onCastComplete);
			target.armature.animation.gotoAndPlay(frameId);
		}

		protected function armMovementHandler(event: FrameEvent):void
		{
			if(event.frameLabel == "hit"){

				target.armature.removeEventListener(FrameEvent.MOVEMENT_FRAME_EVENT, armMovementHandler);

				for each(var character:Character in targets){
					addEffectAnimation(character);
					character.hit(damage, 0, true);
					applyEffects(character);
				}
				damageSignal.dispatch();
			}
		}

		public function notify():void {
			waitTurn--;
		}

		public function get damage():int {
			return _damage;
		}

		public function get percent():Number {
			return _percent;
		}

		public function get title():String {
			return _title;
		}

		public function set title(value:String):void
		{
			_title = value;
		}

		public function get description():String {
			return _description;
		}

		public function set description(value:String):void
		{
			_description = value;
		}

		public function get icon():Image {
			return _icon;
		}

		public function set icon(value:Image):void
		{
			if(contains(_icon)){
				_icon.removeFromParent();
			}
			_icon = value;

			_iconContainer = new Sprite();
			_iconContainer.addChild(icon);
			icon.x = -icon.width>>1;
			icon.y = -icon.height>>1;
			addChild(_iconContainer);
			_iconContainer.x = _iconContainer.width>>1;
			_iconContainer.y = _iconContainer.height>>1;
		}

		public function get level():int
		{
			return _level;
		}

		public function set level(value:int):void
		{
			_level = value;
		}

		public function get levelUpSignal():Signal
		{
			return _levelUpSignal;
		}

		public function get disabled():Boolean
		{
			return _disabled;
		}

		public function set disabled(value:Boolean):void
		{
			_disabled = value;
			_disabled ? createEEffectTween() : icon.filter = null;
			_disabledChangeSignal.dispatch(disabled);
		}

		public function setGray():void
		{
			_colorFilter.adjustSaturation(-1);
		}

		public function get infoDamage():String
		{
			throw new IllegalOperationError("Abstract method must be overridden in a subclass");
		}

		public function onCastComplete(event:* = null):void {
			if(target != null){
				target.armature.removeEventListener(AnimationEvent.COMPLETE, onCastComplete);
				target.stay();
			}
			throwAnimation(true);
			_destroySignal.dispatch();
		}

		public function clearAnimation():void {
			if(_movie != null){
				_movie.removeFromParent(true);
				_movie = null;
			}
		}

		public function destroy():void {
			if(icon != null){
				icon.removeFromParent(true);
			}
			clearAnimation();
			target = null;
		}

		public function get destroySignal():Signal
		{
			return _destroySignal;
		}

		public function get damageSignal():Signal
		{
			return _damageSignal;
		}

		public function get target():Character
		{
			return _target;
		}

		public function set target(value:Character):void
		{
			_target = value;
		}

		public function get useSkillSignal():Signal
		{
			return _useSkillSignal;
		}

		public function get disabledChangeSignal():Signal
		{
			return _disabledChangeSignal;
		}

		public function get effect():uint
		{
			return _effect;
		}

		public function set effect(value:uint):void
		{
			_effect = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

		public function set maxTurn(value:int):void
		{
			_maxTurn = waitTurn = value;
		}

		public function set movie(value:Movie):void
		{
			_movie = value;
		}

		protected function addEffectAnimation(target: Character):void
		{
			if(_movie != null && target.hp > 0)
			{
				target.container.addChild(_movie);
				_movie.goTo(1);
				_movie.playOnce();
			}
		}

		protected function createEEffectTween():void
		{
			if(icon == null){
				return;
			}
			icon.filter = _colorFilter;
			TweenMax.to(_iconContainer, 0.3, {scaleX: 1.05, scaleY: 1.05, repeat: 5, yoyo: true, ease: Linear.easeNone});
			TweenMax.to(icon.filter, 0.3, {brightness: 0.5, repeat: 5, yoyo: true, ease: Linear.easeNone, onComplete: setGray});
		}

		public function get anim():Boolean
		{
			return _anim;
		}

		public function set anim(value:Boolean):void
		{
			_anim = value;
		}

		public function get price():int
		{
			return _price;
		}

		public function set price(value:int):void
		{
			_price = value;
		}
	}
}
