package it.sharpedge.navigator
{
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.debug.CountLogger;
	import it.sharpedge.navigator.events.NavigatorStateEvent;
	import it.sharpedge.navigator.guards.TestAsyncGuard;
	import it.sharpedge.navigator.guards.TestSyncGuard;
	import it.sharpedge.navigator.hooks.TestAsyncHook;
	import it.sharpedge.navigator.hooks.TestSyncHook;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	
	use namespace navigator;

	public class NavigationTest
	{
		private var navigator:Navigator;
		private var a : NavigationState;			
		private var b : NavigationState;
		private var c : NavigationState;
		private var d : NavigationState;
		private var e : NavigationState;
		
		[Before]
		public function initNavigator() : void {
			navigator = new Navigator("/");
			Navigator.logger = new CountLogger();
			
			a = NavigationState.make("/");			
			b = NavigationState.make("/anyState/");
			c = NavigationState.make("/anyOtherState/");
			d = NavigationState.make("/*/anySubState/");
		}
		
		[After]
		public function disposeNavigator():void
		{
			navigator.clearMappings();
			navigator = null;
			
			a.dispose();
			b.dispose();
			c.dispose();
			d.dispose();
		}
		
		[Test]
		public function simpleRequest() : void {
			
			navigator.request(b);			
			assertThat("The currentState changed to request state", navigator.currentState.path, equalTo(b.path));
			
			navigator.request(null);
			assertThat("null request fails", (Navigator.logger as CountLogger)._error, equalTo(1));
		}
		
		[Test]
		public function maskRequest() : void {
			
			navigator.request(d);			
			assertThat("State doesn't change because masking fails", navigator.currentState.path, equalTo(a.path));
			
			navigator.request(b);
			navigator.request(d);			
			assertThat("State change because masking success", navigator.currentState.path, equalTo(d.mask(b).path));
		}
		
		[Test]
		public function sameRequest() : void {
			
			navigator.request(a);
			
			// TODO Capture the stop on TestTask
			assertThat("State doesn't change", navigator.currentState.path, equalTo(a.path));
		}
		
		[Test]
		public function wildcardMapping() : void {
			
			var tsh:TestSyncHook = new TestSyncHook();
			navigator.onExitFrom(a).to(d).addHooks(tsh);
			navigator.onEnterTo(d).from(a).addHooks(tsh);
			
			navigator.request(d.mask(b));

			assertThat("Wildcard match", tsh.called, equalTo(2));
		}

		
		[Test]
		public function redirect() : void {
			
			navigator.onExitFrom(a).to(b).redirectTo(c);
			navigator.onEnterTo(a).from(c).redirectTo(b);
			
			navigator.request(b);

			assertThat(navigator.currentState.path, equalTo(c.path));
			
			navigator.request(a);
			
			assertThat(navigator.currentState.path, equalTo(b.path));
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