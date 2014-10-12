/**
 * Author: rastyslaw
 * Date: 19.08.2014
 * Time: 11:25
 */
package src.mvcs.view.objects
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import starling.display.DisplayObject;

	import starling.display.Image;
	import starling.textures.SubTexture;
	import starling.textures.Texture;

	public class ImagePixelHit extends Image
	{
		private var bitmapDataHit:BitmapData;
		private var threshold:uint;

		public function ImagePixelHit ( texture:Texture, bitmapDataHit:BitmapData = null, threshold:uint = 0 )
		{
			super ( texture );
			this.bitmapDataHit = bitmapDataHit;
			this.threshold = threshold;
		}

		override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
		{
			if (getBounds(this).containsPoint(localPoint) && bitmapDataHit )
			{
				var c:Rectangle = SubTexture (texture).clipping;
				var X:int = localPoint.x + bitmapDataHit.width * c.x;
				var Y:int = localPoint.y + bitmapDataHit.height * c.y;
				return bitmapDataHit.hitTest ( new Point (0, 0), threshold, new Point (X, Y) ) ? this : null;
			} else {
				return super.hitTest ( localPoint, forTouch );
			}
			return null;
		}
	}

}