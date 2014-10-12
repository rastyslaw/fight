package src.mvcs.view.skills
{
	import robotlegs.extensions.starlingViewMap.impl.StarlingMediator;

	import src.mvcs.model.DataModel;
	import src.mvcs.model.loader.GraphicsModule;
	import src.mvcs.nameStorage.Names;

	public class ActiveSkillMediator extends StarlingMediator
	{
		[Inject]
		public var view:ActiveSkill;

		[Inject]
		public var observers:ISubject;

		[Inject]
		public var dataModel:DataModel;

		[Inject]
		public var graphicsModule:GraphicsModule; 

		override public function initialize():void
		{
			view.disabledChangeSignal.add(onDisabledChanged);
			view.useSkillSignal.add(onUseSignal);
			if(view.anim)
			{
				view.movie = graphicsModule.getEffect(view.name);
			}
		}

		private function onUseSignal():void
		{
			var skills:Object = dataModel.getValue(Names.SKILLS);
			skills[view.id].level = view.level;
			dataModel.setValue(Names.SKILLS, skills);
		}

		private function onDisabledChanged(disabled: Boolean):void
		{
			if(disabled){
				observers.subscribeObserver(IObserver(view));
			} else {
				observers.unsubscribeObserver(IObserver(view));
			}
		}

		override public function destroy():void
		{
			view.disabledChangeSignal.remove(onDisabledChanged);
			super.destroy();
		}
	}
}
