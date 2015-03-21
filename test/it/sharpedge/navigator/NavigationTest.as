package it.sharpedge.navigator
{
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.events.NavigatorStateEvent;
	import it.sharpedge.navigator.hooks.TestAsyncHook;
	import it.sharpedge.navigator.hooks.TestSyncHook;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
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
		
		[Test(async)]
		public function asyncHook() : void {
			
			var a : NavigationState = NavigationState.make("/");			
			var b : NavigationState = NavigationState.make("/anyState/");
			
			var hook:TestAsyncHook = new TestAsyncHook();
			
			navigator.onExitFrom(a).to(b).addHooks(hook);
			
			navigator.addEventListener( NavigatorStateEvent.COMPLETED, 
				Async.asyncHandler(
					this,
					function( ev:NavigatorStateEvent, hook:TestAsyncHook ):void{
						assertThat("Async hook has been called", hook.called, equalTo(1));
					}, 
					500, 
					hook, 
					function():void{
						Assert.fail( "Async hook timeout" );
					})
			);			
			
			navigator.request(b);			
		}
	}
}