package it.sharpedge.navigator
{
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.events.NavigatorStateEvent;
	import it.sharpedge.navigator.guards.TestAsyncGuard;
	import it.sharpedge.navigator.guards.TestSyncGuard;
	import it.sharpedge.navigator.hooks.TestAsyncHook;
	import it.sharpedge.navigator.hooks.TestSyncHook;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class NavigationTest
	{
		private var navigator:Navigator;
		private var a : NavigationState;			
		private var b : NavigationState;
		private var c : NavigationState;
		
		[Before]
		public function initNavigator() : void {
			navigator = new Navigator();
			
			a = NavigationState.make("/");			
			b = NavigationState.make("/anyState/");
			c = NavigationState.make("/anyOtherState/");
		}
		
		[After]
		public function disposeNavigator():void
		{
			navigator.clearMappings();
			navigator = null;
		}
		
		[Test]
		public function simpleRequest() : void {
			
			navigator.request(b);
			
			assertThat("The currentState changed to request state", navigator.currentState.path, equalTo(b.path));
		}
		
		[Test]
		public function sameRequest() : void {
			
			navigator.request(a);
			
			// TODO Capture the stop on TestTask
			assertThat(navigator.currentState.path, equalTo(a.path));
		}
		
		[Test]
		public function redirect() : void {
			
			navigator.onExitFrom(a).to(b).redirectTo(c);
			
			navigator.request(b);

			assertThat(navigator.currentState.path, equalTo(c.path));
		}
		
		[Test]
		public function syncHook() : void {
			
			var hook:TestSyncHook = new TestSyncHook();
			
			navigator.onExitFrom(a).to(b).addHooks(hook);
			
			navigator.request(b);
			
			assertThat("Hook has been called", hook.called, equalTo(1));
		}
		
		[Test(async)]
		public function asyncHook() : void {
			
			var hook:TestAsyncHook = new TestAsyncHook();
			
			navigator.onExitFrom(a).to(b).addHooks(hook);
			
			navigator.addEventListener( NavigatorStateEvent.COMPLETED, 
				Async.asyncHandler(
					this,
					function( ev:NavigatorStateEvent, hook:TestAsyncHook ):void{
						assertThat("Async Hook has been called", hook.called, equalTo(1));
					}, 
					500, 
					hook, 
					function():void{
						Assert.fail( "Async Hook timeout" );
					}),
				false,
				0,
				true
			);			
			
			navigator.request(b);			
		}
		
		[Test]
		public function syncGuard() : void {			
			
			var guardPass:TestSyncGuard = new TestSyncGuard(true);
			var guardFail:TestSyncGuard = new TestSyncGuard(false);
			
			navigator.onExitFrom(a).to(b).addGuards(guardPass);
			navigator.onExitFrom(b).to(a).addGuards(guardFail);
			
			navigator.request(b);
			assertThat("Guard has been called", guardPass.called, equalTo(1));
			assertThat("Guard has approved the request", navigator.currentState.path, equalTo(b.path));
			
			navigator.request(a);
			assertThat("Guard has been called", guardFail.called, equalTo(1));
			assertThat("Guard has blocked the request", navigator.currentState.path, equalTo(b.path));
		}
		
		[Test(async)]
		public function asyncPassGuard() : void {
			
			var guardPass:TestAsyncGuard = new TestAsyncGuard(true);
			
			navigator.onExitFrom(a).to(b).addGuards(guardPass);
			
			navigator.addEventListener( NavigatorStateEvent.COMPLETED, 
				Async.asyncHandler(
					this,
					function( ev:NavigatorStateEvent, guardPass:TestAsyncGuard ):void{
						assertThat("Async Guard has been called", guardPass.called, equalTo(1));
						assertThat("Guard has approved the request", navigator.currentState.path, equalTo(b.path));
					}, 
					500, 
					guardPass, 
					function():void{
						Assert.fail( "Async Guard timeout" );
					}),
				false,
				0,
				true
			);			
			
			navigator.request(b);			
		}
		
		[Test(async)]
		public function asyncFailGuard() : void {
			
			var guardPass:TestAsyncGuard = new TestAsyncGuard(false);
			
			navigator.onExitFrom(a).to(b).addGuards(guardPass);
			
			navigator.addEventListener( NavigatorStateEvent.COMPLETED, 
				Async.asyncHandler(
					this,
					function( ev:NavigatorStateEvent, guardPass:TestAsyncGuard ):void{
						assertThat("Async Guard has been called", guardPass.called, equalTo(1));
						assertThat("Guard has blocked the request", navigator.currentState.path, equalTo(a.path));
					}, 
					500, 
					guardPass, 
					function():void{
						Assert.fail( "Async Guard timeout" );
					}),
				false,
				0,
				true
			);			
			
			navigator.request(b);			
		}
	}
}