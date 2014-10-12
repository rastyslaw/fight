/**
 * Author: rastyslaw
 * Date: 17.07.2014
 * Time: 17:23
 */
package src.mvcs.view.objects
{
	import src.mvcs.model.data.ScreenId;

	import starling.display.Image;
	import starling.events.TouchEvent;
	import starling.extensions.krecha.PixelHitArea;
	import starling.extensions.krecha.PixelImageTouch;

	public class Stadium extends ObjectWithAlpha
	{
		public function Stadium(readOnlyFlag:Boolean = false)
		{
			objectName = "stadium";
			readOnly = readOnlyFlag;
			super();
		}

		override protected function click(event:TouchEvent):void
		{
			clickedSignal.dispatch(ScreenId.SELECT_ENEMY, {});
		}

		override protected function onLayout():void
		{
			super.onLayout();
			x = (stageWidth - width) / 2 - 180;
			y = (stageHeight - height) / 2 + 20;
		}
	}
}
