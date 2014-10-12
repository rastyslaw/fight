/**
 * Author: rastyslaw
 * Date: 17.07.2014
 * Time: 17:23
 */
package src.mvcs.view.objects
{
	import feathers.controls.Callout;

	import flash.errors.IllegalOperationError;

	import org.osflash.signals.Signal;

	import sfxml.components.ExtCallout;
	import sfxml.components.ExtLabel;

	import src.mvcs.view.base.StarlingViewBase;

	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.filters.BlurFilter;
	import starling.utils.AssetManager;

	public class AbstractObject extends StarlingViewBase
	{
		private var _assets:AssetManager;
		protected var _container:Sprite;
		private var _clickedSignal:Signal;
		private var _tooltipSignal:Signal;

		protected var stageWidth:Number;
		protected var stageHeight:Number;

		private var glowFilter:BlurFilter;
		private var _readOnly:Boolean;

		private var tooltip:ExtLabel;
		private var _objectName:String;

		public function AbstractObject()
		{
			_clickedSignal = new Signal(String);
			_tooltipSignal = new Signal(Object);
			addChild(_container = new Sprite());
			glowFilter = BlurFilter.createGlow(0xffffff);
			if(!readOnly){
				createListeners();
			}
		}

		protected function createListeners():void
		{
			_container.addEventListener(TouchEvent.TOUCH, onTouchObject);
		}

		protected function removeListeners():void
		{
			_container.filter = null;
			_container.removeEventListener(TouchEvent.TOUCH, onTouchObject);
		}

		protected function onTouchObject(event:TouchEvent):void
		{
			var touch:Touch = event.getTouch(_container);
			if (touch == null)
			{
				_container.filter = null;
				_tooltipSignal.dispatch(null);
			}
			else if (touch.phase == TouchPhase.HOVER && ExtCallout.currentCallout == null)
			{
				_container.filter = glowFilter;
				tooltip = new ExtLabel();
				tooltip.setBitmapRenderer("archangelsk", 14);
				tooltip.text = _objectName;
				_tooltipSignal.dispatch({target: tooltip, direction: Callout.DIRECTION_UP});
			}
			else if (touch.phase == TouchPhase.ENDED)
			{
				click(event);
			}
		}

		protected function click(event:TouchEvent):void
		{
			throw IllegalOperationError("Abstract method must be overridden in a subclass");
		}

		override public function dispose():void
		{
			removeListeners();
			_container = null;

			super.dispose();
		}

		override protected function onLayout():void
		{
			super.onLayout();
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
		}

		public function get assets():AssetManager
		{
			return _assets;
		}

		public function set assets(value:AssetManager):void
		{
			_assets = value;
		}

		public function get clickedSignal():Signal
		{
			return _clickedSignal;
		}

		public function get readOnly():Boolean
		{
			return _readOnly;
		}

		public function set readOnly(value:Boolean):void
		{
			_readOnly = value;
		}

		public function get objectName():String
		{
			return _objectName;
		}

		public function set objectName(value:String):void
		{
			_objectName = value;
		}

		public function get tooltipSignal():Signal
		{
			return _tooltipSignal;
		}
	}
}
