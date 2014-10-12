/**
 * Author: rastyslaw
 * Date: 11.07.2014
 * Time: 14:25
 */
package src
{
	import com.vnz.patterns.command.SerialCommand;

	import commands.InitConfigsCommand;

	import commands.InitFlashConsoleCommand;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.ui.ContextMenu;

	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.extensions.starlingViewMap.StarlingViewMapExtension;

	import src.mvcs.FightContext;
	import src.mvcs.bundles.SignalCommandMapBundle;
	import src.mvcs.view.FightingView;

	import starling.core.Starling;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	[SWF(backgroundColor="0xc4c4c4", frameRate="60", width="760", height="760")]
	[Frame(factoryClass="src.Preloader")]
	public class Main extends Sprite
	{
		protected var _context:IContext;
		protected var _starling:Starling;

		public function Main()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			var _actions:SerialCommand;
			_actions = new SerialCommand();
			_actions.addCommand(new InitFlashConsoleCommand(), stage);
			_actions.addCommand(new InitConfigsCommand());

			_actions.execute(initResActionsCompleteHandler);
		}

		private function initResActionsCompleteHandler():void
		{
			// Init stage.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			// No flash.display mouse interactivity.
			mouseEnabled = mouseChildren = false;

			// Init Starling.
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			Starling.multitouchEnabled = true;
			_starling = new Starling(FightingView, stage);
			_starling.enableErrorChecking = false;
			_starling.showStatsAt(HAlign.LEFT, VAlign.BOTTOM);
			_starling.antiAliasing = 0;
			_starling.start();

			// Init Robotlegs.
			_context = new Context();
			_context.install(MVCSBundle, StarlingViewMapExtension, SignalCommandMapBundle);
			_context.configure(FightContext, this, _starling);
			_context.configure(new ContextView(this));
//			_context = new Context()
//				.install(StarlingBundle, ViewProcessorMapExtension, MVCSBundle)
//				.install(MVCSBundle)
//				.configure( FightContext, new ContextView( _starling ) );

			var cm:ContextMenu = new ContextMenu();
			cm.hideBuiltInItems();
			contextMenu = cm;

			FightConsole.printInChannel("info", "version", {date: "@{buildDate}", revision: "@{gitRevision}", branch: "@{branch}"});

			// Update Starling view port on stage resizes.
			stage.addEventListener(Event.RESIZE, onStageResize, false, int.MAX_VALUE, true);
			stage.addEventListener(Event.DEACTIVATE, onStageDeactivate, false, 0, true);
		}

		private function onStageResize(event:Event):void
		{
			//if( stage.stageWidth < 256 || stage.stageHeight < 256 ) return;
			_starling.stage.stageWidth = stage.stageWidth;
			_starling.stage.stageHeight = stage.stageHeight;
			const viewPort:Rectangle = _starling.viewPort;
			viewPort.width = stage.stageWidth;
			viewPort.height = stage.stageHeight;
			try
			{
				_starling.viewPort = viewPort;
			}
			catch (error:Error)
			{
			}
		}

		private function onStageDeactivate(event:Event):void
		{
			_starling.stop();
			stage.addEventListener(Event.ACTIVATE, onStageActivate, false, 0, true);
		}

		private function onStageActivate(event:Event):void
		{
			stage.removeEventListener(Event.ACTIVATE, onStageActivate);
			_starling.start();
		}
	}
}
