package it.sharpedge.navigator
{
	import it.sharpedge.navigator.core.NavigationState;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.NavigatorHistory;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.IsNullMatcher;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.nullValue;

	public class HistoryTest
	{
		private var navigator:Navigator;
		private var navHistory:NavigatorHistory;
		
		private var a:NavigationState;
		private var b:NavigationState;
		private var c:NavigationState;
		
		public function HistoryTest() {
			a = new NavigationState("/baseState/");
			b = new NavigationState("/baseState/subState");
			c = new NavigationState("/anotherState/");
		}
		
		[Before]
		public function prepareNavigator():void {
			navigator = new Navigator("/");
			navHistory = new NavigatorHistory( navigator );
		}
		
		[After]
		public function disposeNavigator():void
		{
			navigator.clearMappings();
			navigator = null;
			
			navHistory.dispose();
			
			a.dispose();
			b.dispose();
			c.dispose();
		}
		
		[Test]
		public function storeStates():void {
			navigator.request(a);
			navigator.request(b);
			
			assertThat("History is populated", navHistory.history.length, equalTo(2));
			assertThat("History has correct states", navHistory.history[0].path, equalTo(b.path));
			assertThat("History has correct states", navHistory.history[1].path, equalTo(a.path)); 
		}
		
		[Test]
		public function setMaxLength():void {
			navigator.request(a);
			navigator.request(b);
			
			navHistory.maxLength = 1;
			assertThat("MaxLength changed", navHistory.maxLength, equalTo(1));
			
			navigator.request(c);
			
			assertThat("History has correct length", navHistory.history.length, equalTo(1));
			assertThat("History has correct state", navHistory.history[0].path, equalTo(c.path)); 
		}
		
		[Test]
		public function previousState():void {
			
			assertThat("Get previous state null", navHistory.getPreviousState(), nullValue());
			
			navigator.request(a);
			navigator.request(b);
			
			assertThat("Get previous state = a", navHistory.getPreviousState().path, equalTo(a.path));
			
			navHistory.back();
			
			assertThat("Current State is a", navigator.currentState.path, equalTo(a.path));
		}
		
		[Test]
		public function nextState():void {
			assertThat("Get next state null", navHistory.getNextState(), nullValue());
			
			navigator.request(a);
			navigator.request(b);
			
			navHistory.back();
			
			assertThat("Get next state = b", navHistory.getNextState().path, equalTo(b.path));
			
			navHistory.forward();
			
			assertThat("Current State is b", navigator.currentState.path, equalTo(b.path));
		}
		
		[Test]
		public function recoverState():void {			
			navigator.request(a);
			navigator.request(b);
			
			var res:NavigationState = navHistory.getStateByPosition(1);
			
			assertThat("Get State with Position", res.path, equalTo(a.path));
			
			assertThat("Get Position with State", navHistory.getPositionByState(res), equalTo(1));
		}
		
		[Test]
		public function clear():void {
			navigator.request(a);
			navigator.request(b);

			assertThat("Before is 2", navHistory.history.length, equalTo(2));
			
			navHistory.clearHistory();
			
			assertThat("After is 0", navHistory.history.length, equalTo(0));
		}
		
		
	}
}