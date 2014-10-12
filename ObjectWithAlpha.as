/**
 * Author: rastyslaw
 * Date: 17.07.2014
 * Time: 17:23
 */
package src.mvcs.view.objects
{
	import starling.extensions.krecha.PixelImageTouch;

	public class ObjectWithAlpha extends AbstractObject
	{
		private var _image:PixelImageTouch;

		public function ObjectWithAlpha(readOnlyFlag:Boolean = false)
		{
			super();
		}

		public function set image(value:PixelImageTouch):void
		{
			clearImage();
			_image = value;
			_container.addChild(_image);
			onLayout();
		}

		private function clearImage():void
		{
			if(_image != null){
				_container.removeChild(_image);
				_image.hitArea.dispose();
				_image.dispose();
				_image = null;
			}
		}

		public function get image():PixelImageTouch
		{
			return _image;
		}

		override public function dispose():void
		{
			clearImage();
			super.dispose();
		}
	}
}
