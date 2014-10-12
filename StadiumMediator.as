package src.mvcs.view.objects
{
	import flash.display.Bitmap;

	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;

	import src.mvcs.model.data.LoadableResource;
	import src.mvcs.model.data.ScreenItem;
	import src.mvcs.model.loader.GraphicsModule;
	import src.mvcs.signals.ScreenChangedSignal;

	import starling.extensions.krecha.PixelHitArea;
	import starling.extensions.krecha.PixelImageTouch;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class StadiumMediator extends StarlingMediator
	{
		[Inject]
		public var view:Stadium;

		[Inject]
		public var assets:AssetManager;

		[Inject]
		public var graphics:GraphicsModule;

		[Inject]
		public var screenChangedSignal:ScreenChangedSignal;

		override public function initialize():void
		{
			view.assets = assets;
			view.clickedSignal.add(onViewClicked);
			loadingResource();
		}

		private function loadingResource():void
		{
			var loadableResource:LoadableResource = graphics.getLoadableResource("arena");
			if (loadableResource.error != null)
			{
				trace(loadableResource.error);
			}
			if (loadableResource.resource != null)
			{
				initObject(loadableResource);
			}
			else
			{
				loadableResource.onComplete = initObject;
			}
		}

		private function initObject(loadableResource:LoadableResource): void
		{
			var bmp:Bitmap = loadableResource.resource;
			var hitArea:PixelHitArea = new PixelHitArea ( bmp, .2);
			var img:PixelImageTouch = new PixelImageTouch ( Texture.fromBitmap (bmp), hitArea, 150 );
			view.image = img;
		}

		private function onViewClicked(screenID:String, params: Object):void
		{
			screenChangedSignal.dispatch(new ScreenItem(screenID, params));
		}

		override public function destroy():void
		{
			view.clickedSignal.remove(onViewClicked);
			super.destroy();
		}
	}
}
