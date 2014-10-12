/**
 * Author: rastyslaw
 * Date: 08.10.2014
 * Time: 10:32
 */
package src.mvcs.view.components
{
	import feathers.controls.Callout;

	import org.osflash.signals.Signal;

	import sfxml.components.ExtCallout;

	import src.mvcs.view.base.StarlingViewBase;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;

	public class Medal extends StarlingViewBase
	{
		private var _image:Image;
		private var _id:int;
		private var _texture:Texture;
		private var _tooltip:Sprite;
		private var _tooltipSignal:Signal;

		public function Medal(id: int) {
			_tooltipSignal = new Signal(Object);
			_id = id;
		}

		override protected function onSetup():void
		{
			addEventListener(TouchEvent.TOUCH, touchHandler);
		}

		private function touchHandler(event : TouchEvent) : void
		{
			var touch:Touch = event.getTouch(this);
			if (touch == null)
			{
				_tooltipSignal.dispatch(null);
			}
			else if (touch.phase == TouchPhase.HOVER && ExtCallout.currentCallout == null)
			{
				_tooltip = new Sprite();
				addChild(_tooltip);
				_tooltipSignal.dispatch({target: _tooltip, direction: Callout.DIRECTION_DOWN});
			}
		}

		private function clearImage():void
		{
			if(_image != null){
				_image.removeFromParent(true);
			}
		}

		public function get id():int
		{
			return _id;
		}

		public function set texture(value:Texture):void
		{
			_texture = value;
			clearImage();
			_image = new Image(_texture);
			addChild(_image);
		}

		public function get tooltipSignal():Signal
		{
			return _tooltipSignal;
		}

		override public function dispose():void
		{
			clearImage();
			removeEventListener(TouchEvent.TOUCH, touchHandler);
			super.dispose();
		}

	}
}
