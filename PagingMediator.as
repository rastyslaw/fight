package src.mvcs.view.components
{
	import feathers.data.ListCollection;

	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;

	import sfxml.core.SFXMLFactory;

	import src.mvcs.model.DataModel;

	public class PagingMediator extends StarlingMediator
	{
		[Inject]
		public var view:Paging;

		[Inject]
		public var xmlFactory:SFXMLFactory;

		[Inject]
		public var dataModel:DataModel;

		override public function initialize():void
		{
			view.xmlFactory = xmlFactory;
			view.updatePagesSignal.add(onPageUpdate);
			view.readySignal.add(onReadyView);
		}

		private function onReadyView():void
		{
			view.pageCollection = createPageCollection();
		}

		private function onPageUpdate(page: int):void
		{
			view.pageCollection = createPageCollection( page );
		}

		private function createPageCollection(lastPage: int = 1):ListCollection
		{
			var pagesCollection:ListCollection = new ListCollection();
			var numPages:int;
			var addPosition:int;

			if(lastPage > Paging.MAX_PAGES){
				pagesCollection.push( {count: 1} );
				pagesCollection.push( {} );
				numPages = Paging.MAX_PAGES - 2;
				addPosition = 2;
			} else {
				numPages = lastPage;
			}

			while(numPages > 0){
				pagesCollection.addItemAt( {count: lastPage}, addPosition );
				lastPage--;
				numPages--;
			}

			return pagesCollection;
		}

		override public function destroy():void
		{
			view.readySignal.remove(onReadyView);
			view.updatePagesSignal.remove(onPageUpdate);
			super.destroy();
		}
	}
}
