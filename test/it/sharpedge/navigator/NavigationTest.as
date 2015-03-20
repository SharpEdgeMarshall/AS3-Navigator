package it.sharpedge.navigator
{
	import it.sharpedge.navigator.api.IHookSync;
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.hooks.TestSyncHook;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NavigationTest
	{
		private var navigator:Navigator;
		
		[Before]
		public function before():void
		{
			navigator = new Navigator();
		}
		
		[Test]
		public function simpleRequest() : void {
			var a : NavigationState = NavigationState.make("/anystate/");
			
			navigator.request(a);
			
			assertThat("The currentState changed to request state", navigator.currentState, equalTo("/anystate/"));
		}
		
		[Test]
		public function sameRequest() : void {
			var a : NavigationState = NavigationState.make("/");
			
			navigator.request(a);
			
			// TODO Capture the stop on TestTask
			assertThat(navigator.currentState, equalTo("/"));
		}
		
		[Test]
		public function syncHook() : void {
			
			var a : NavigationState = NavigationState.make("/");			
			var b : NavigationState = NavigationState.make("/anyState/");
			
			var hook:TestSyncHook = new TestSyncHook();
			
			navigator.onExitFrom(a).to(b).addHooks(hook);
			
			navigator.request(b);
			
			assertThat("Hook has been called", hook.called, equalTo(1));
		}
	}
}