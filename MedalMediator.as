package src.mvcs.view.components
{
	import flash.text.TextFormatAlign;

	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;

	import sfxml.components.ExtLabel;

	import src.mvcs.model.DataModel;

	import src.mvcs.model.LocaleModel;
	import src.mvcs.model.data.MedalResourceId;
	import src.mvcs.nameStorage.Names;
	import src.mvcs.signals.TooltipSignal;
	import src.utils.FightUtils;

	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.utils.AssetManager;

	public class MedalMediator extends StarlingMediator
	{
		[Inject]
		public var view:Medal;

		[Inject]
		public var assets:AssetManager;

		[Inject]
		public var tooltipSignal:TooltipSignal;

		[Inject]
		public var localeModel:LocaleModel;

		[Inject]
		public var fightUtils:FightUtils;

		[Inject]
		public var dataModel:DataModel;

		private var places:Array;

		override public function initialize():void
		{
			view.readySignal.add(onReadyView);
			view.tooltipSignal.add(onTooltipCreate);
		}

		private function onTooltipCreate(data: Object):void
		{
			if(data != null){
				createTooltip(data.target);
			}
			tooltipSignal.dispatch(data);
		}

		private function createTooltip(container: Sprite):void
		{
			var GAPY:int = 10;
			var cumulativeY:Number = 0;
			var gameXML:XML = dataModel.getValue(Names.GAME_XML);
			var medal:XMLList = gameXML.medals.medal.(@id == view.id);

			var title:ExtLabel = new ExtLabel();
			title.setBitmapRenderer("ticker", 14);
			container.addChild(title);
			title.text = localeModel.getString("ID_" + String(medal.@name).toUpperCase()) + " " + localeModel.getString("ID_MEDAL");
			title.y = cumulativeY;
			title.validate();
			cumulativeY += title.height + GAPY;

			var description:ExtLabel = new ExtLabel();
			description.setBitmapRenderer("archangelsk", 13, 0xffffff, TextFormatAlign.LEFT);
			description.textRendererProperties.wordWrap = true;
			container.addChild(description);
			description.width = 220;
			description.text = FightUtils.replaceStringValues(localeModel.getString("ID_MEDAL_DESCRIPTION"), medal.@bonus);
			description.y = cumulativeY;
			description.validate();
			cumulativeY += description.height + 2*GAPY;

			var range:String = getPos(view.id-2, true) + "-" + getPos(view.id-1);

			var info:ExtLabel = new ExtLabel();
			info.setBitmapRenderer("archangelsk", 13, 0xffffff, TextFormatAlign.LEFT);
			info.textRendererProperties.wordWrap = true;
			container.addChild(info);
			info.width = 220;
			info.text = FightUtils.replaceStringValues(localeModel.getString("ID_MEDAL_INFO"), range);
			info.y = cumulativeY;
			info.validate();
			cumulativeY += info.height;

			title.x = (container.width - title.width) >> 1;
		}

		private function getPos(id: int, first: Boolean = false):String
		{
			var result:String = "";
			if(id < 0 || id >= places.length){
				result = "0";
			} else {
				result = places[id];
			}
			if(first){
				result = String(int(places[id]) + 1);
			}
			return result;
		}

		private function onReadyView():void
		{
			places = dataModel.getValue(Names.PLACES);
			view.texture = fightUtils.getMedalTexture(view.id);
		}

		override public function destroy():void
		{
			view.readySignal.remove(onReadyView);
			view.tooltipSignal.remove(onTooltipCreate);
			super.destroy();
		}
	}
}
