/**
 * Author: rastyslaw
 * Date: 08.10.2014
 * Time: 10:32
 */
package src.mvcs.view.components
{
	import feathers.controls.Button;
	import feathers.controls.List;
	import feathers.controls.renderers.IListItemRenderer;
	import feathers.data.ListCollection;
	import feathers.events.FeathersEventType;

	import org.osflash.signals.Signal;

	import sfxml.components.Container;
	import sfxml.core.SFXMLFactory;

	import src.mvcs.view.base.StarlingViewBase;
	import src.mvcs.view.renderers.PagingRenderer;
	import src.mvcs.view.renderers.RendererEvent;

	import starling.display.DisplayObject;
	import starling.events.Event;

	public class Paging extends StarlingViewBase
	{
		public static const CHANGE:String = "change";

		public static const MAX_PAGES:int = 7;

		private var container:DisplayObject;
		private var _xmlFactory:SFXMLFactory;
		private var pageList:List;
		private var _pageCollection:ListCollection;
		private var paging:Container;

		private var _rightBtn:Button;
		private var _leftBtn:Button;

		private var _lastPage:int;

		private var _updatePagesSignal:Signal;

		private var _pagingComplete:Boolean;

		public function Paging() {
			_updatePagesSignal = new Signal(int);
		}

		override protected function onSetup():void
		{
			container = _xmlFactory.createControlFromTemplate("windows", "paging");
			addChild(container);
			paging = Container(container);

			pageList = paging.getElementByName("list") as List;
			pageList.addEventListener( FeathersEventType.RENDERER_ADD, list_rendererAddHandler );
			pageList.addEventListener( FeathersEventType.RENDERER_REMOVE, list_rendererRemoveHandler );

			_rightBtn = paging.getElementByName("scroll_right") as Button;
			_rightBtn.addEventListener(Event.TRIGGERED, nextPage);

			_leftBtn = _xmlFactory.createControlFromTemplate("screens", "scrollButtonInvert") as Button;
			addChild(_leftBtn);
			_leftBtn.y = paging.y;
			_leftBtn.addEventListener(Event.TRIGGERED, prevPage);
			_leftBtn.addEventListener(Event.ADDED, onAdded);
		}

		public function updateBtnState():void
		{
			_leftBtn.isEnabled = pageList.selectedIndex != 0;
			dispatchEventWith(CHANGE, false, {value: _lastPage-1});
			_updatePagesSignal.dispatch(_lastPage);
		}

		private function nextPage(event: Event):void
		{
			_lastPage = pageList.selectedItem.count + 1;
			pageList.selectedIndex = pageList.selectedIndex+1;
			updateBtnState();
		}

		private function list_rendererRemoveHandler( event:Event, itemRenderer:IListItemRenderer ):void
		{
			itemRenderer.removeEventListener( RendererEvent.ITEM_CLICK, listChangeHandler );
		}

		private function listChangeHandler(event: Event):void
		{
			if(event.data.count == _lastPage){
				return;
			}else if(event.data.count < _lastPage){
				pagingComplete = false;
			}
			_lastPage = event.data.count;
			updateBtnState();
		}

		private function list_rendererAddHandler( event:Event, itemRenderer:IListItemRenderer ):void
		{
			itemRenderer.addEventListener( RendererEvent.ITEM_CLICK, listChangeHandler );
		}

		private function prevPage(event: Event):void
		{
			pagingComplete = false;
			pageList.selectedIndex = pageList.selectedIndex-1;
			_lastPage = pageList.selectedItem.count;
			updateBtnState();
		}

		private function onAdded(event: Event):void
		{
			var target:Button = event.currentTarget as Button;
			target.removeEventListener(Event.ADDED, onAdded);
			updateLeftArrow();
		}

		private function updateLeftArrow():void
		{
			_leftBtn.x = paging.width - pageList.width - _leftBtn.width;
		}

		public function set xmlFactory(value:SFXMLFactory):void
		{
			_xmlFactory = value;
		}

		override public function dispose():void
		{
			_rightBtn.removeEventListener(Event.TRIGGERED, nextPage);
			_leftBtn.removeEventListener(Event.TRIGGERED, prevPage);
			if(_leftBtn.hasEventListener(Event.ADDED)){
				_leftBtn.removeEventListener(Event.ADDED, onAdded);
			}
			super.dispose();
		}

		public function set pageCollection(value:ListCollection):void
		{
			_pageCollection = value;
			pageList.dataProvider = _pageCollection;
			pageList.selectedIndex = _pageCollection.length-1;
			_lastPage = pageList.selectedItem.count;
			if(pageList.selectedIndex == 0){
				_leftBtn.isEnabled = false;
			}
			pageList.width = PagingRenderer.BASE_WIDTH * _pageCollection.length;
			updateLeftArrow();
		}

		public function get updatePagesSignal():Signal
		{
			return _updatePagesSignal;
		}

		public function set pagingComplete(value:Boolean):void
		{
			_pagingComplete = value;
			_rightBtn.isEnabled = !_pagingComplete;
		}
	}
}
