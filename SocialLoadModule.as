package src.mvcs.model.loader
{
	import com.x10.social.Profile;
	import com.x10.social.VKAPI;
	import com.x10.social.VKApiExternal;

	import src.mvcs.events.SocialEvent;
	import src.mvcs.model.DataModel;
	import src.mvcs.model.LocaleModel;
	import src.mvcs.model.vo.SocialVO;
	import src.mvcs.nameStorage.Names;
	import src.mvcs.signals.InfoLoaderUpdateSignal;

	import starling.events.EventDispatcher;

	public class SocialLoadModule extends AbstractLoaderAction
	{
		[Inject]
		public var data:DataModel;

		[Inject]
		public var locale:LocaleModel;

		[Inject]
		public var infoLoaderUpdateSignal:InfoLoaderUpdateSignal;

		[Inject]
		public var dispatcher:EventDispatcher;

		[Inject]
		public var socialModel:SocialModule;

		private var appFriendsArray:Array;
		private var friendsArray:Array;
		private var socialVO:SocialVO;

		public function SocialLoadModule():void {}

		override public function start():void
		{
			infoLoaderUpdateSignal.dispatch(locale.getString("ID_LOADING_FRIENDS"));

			socialModel.createListeners();

			dispatcher.addEventListener(SocialEvent.INCORRECT_SIGNATURE, onIncorrectSignature);

			var flashVars:Object = data.getValue(Names.FLASHVARS_REQUEST);

			if (data.getValue(Names.LOCALRUN))
			{
				dispatcher.dispatchEventWith(SocialEvent.INIT, false, {apiClass: VKAPI, vars: flashVars});
				onSendProfile(true);
			}
			else
			{
				dispatcher.addEventListener(SocialEvent.INIT_SUCCESS, onSendProfile);
				dispatcher.dispatchEventWith(SocialEvent.INIT, false, {apiClass: VKApiExternal, vars:  flashVars});
			}
		}

		private function onIncorrectSignature():void
		{
			dispatcher.removeEventListener(SocialEvent.INCORRECT_SIGNATURE, onIncorrectSignature);

			data.setValue(Names.PROFILE, {});
			data.setValue(Names.APP_FRIENDS_IDS, []);
			data.setValue(Names.APP_FRIENDS, []);

			finish();
		}

		private function onSendProfile(responce:Boolean):void
		{
			dispatcher.removeEventListener(SocialEvent.INIT_SUCCESS, onSendProfile);
			if (responce)
			{
				socialVO = new SocialVO();
				socialVO.callback = onGetProfile;
				dispatcher.dispatchEvent(new SocialEvent(SocialEvent.GET_PROFILE, socialVO));
			}
		}

		private function onGetProfile(p:Profile):void
		{
			data.setValue(Names.PROFILE, p);
			socialVO = new SocialVO();
			socialVO.callback = onGetAppFriends;
			dispatcher.dispatchEvent(new SocialEvent(SocialEvent.GET_APP_FRIENDS, socialVO));
		}

		private function onGetAppFriends(profileIds:Array):void
		{
			data.setValue(Names.APP_FRIENDS_IDS, profileIds);

			if (profileIds.length > 0)
			{
				socialVO = new SocialVO();
				socialVO.ids = profileIds;
				socialVO.callback = onGetAppFriendsProfiles;
				dispatcher.dispatchEvent(new SocialEvent(SocialEvent.GET_PROFILES, socialVO));
			}
			else
			{
				onGetAppFriendsProfiles([]);
			}
		}

		private function onGetAppFriendsProfiles(profiles:Array):void
		{
			appFriendsArray = profiles;

			data.setValue(Names.APP_FRIENDS, appFriendsArray.concat());

			socialVO = new SocialVO();
			socialVO.callback = onGetFriends;
			dispatcher.dispatchEvent(new SocialEvent(SocialEvent.GET_FRIENDS, socialVO));
		}

		private function onGetFriends(profileIds:Array):void
		{
			friendsArray = profileIds;

			data.setValue(Names.FRIENDS, friendsArray.concat());

			finish();
		}

	}
}
