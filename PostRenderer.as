/**
 * Author: rastyslaw
 * Date: 28.07.2014
 * Time: 19:01
 */
package src.mvcs.view.renderers
{
	import feathers.controls.ImageLoader;
	import feathers.controls.Label;
	import feathers.display.Scale9Image;
	import feathers.textures.Scale9Textures;

	import flash.geom.Rectangle;

	import sfxml.components.ContainerItemRenderer;

	import starling.display.Image;
	import starling.events.Event;

	public class PostRenderer extends ContainerItemRenderer
	{
		private var _image: Image;
		private var _slot: Image;
		private var _ava: Image;
		private var _messageLabel: Label;
		private var imageLoader: ImageLoader;
		private var scaleImage:Scale9Image;

		public function PostRenderer() {}

		override protected function initialize():void
		{
			_messageLabel = getElementByName("name") as Label;
			_slot = getElementByName("slot") as Image;
			_ava = getElementByName("ava") as Image;
		}

		override protected function commitData():void
		{
			if(_data && _owner)
			{
				if(scaleImage == null){
					scaleImage = new Scale9Image(new Scale9Textures(_data.bg, new Rectangle(4,4,4,4)));
					scaleImage.width = width;
					scaleImage.height = height;
					addChildAt(scaleImage, 0);
				}

				_messageLabel.text = _data.profile.firstName + " " + _data.profile.lastName;
				if(_data.ask){
					_messageLabel.text += " " + getString("ID_POST_RENDERER_ASK");
				} else {
					_messageLabel.text += " " + getString("ID_POST_RENDERER_GET");
				}

				if(imageLoader == null){
					imageLoader = new ImageLoader();
					imageLoader.touchable = false;
					imageLoader.addEventListener( Event.COMPLETE, loaderCompleteHandler );
					imageLoader.source = _data.profile.photoUrl;
					addChild(imageLoader);
				}

				if(_image == null){
					_image = new Image(_data.item);
					addChild(_image);
				}
			}
		}

		private function loaderCompleteHandler(event: Event):void
		{
			imageLoader.removeEventListener( Event.COMPLETE, loaderCompleteHandler );
			imageLoader.width = imageLoader.height = 38;
			addChild(_ava);
		}

		override protected function draw():void
		{
			super.draw();

			if(imageLoader.isLoaded){
				imageLoader.x = _ava.x + (_ava.width - imageLoader.width)/2;
				imageLoader.y = _ava.y + (_ava.height - imageLoader.height)/2;
			}
			_image.x = _slot.x + (_slot.width - _image.width)/2;
			_image.y = _slot.y + (_slot.height - _image.height)/2;
		}

		override public function dispose():void
		{
			imageLoader.removeEventListener( Event.COMPLETE, loaderCompleteHandler );
			super.dispose();
		}
	}
}