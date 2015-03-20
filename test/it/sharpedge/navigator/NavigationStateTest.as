package it.sharpedge.navigator
{
	import it.sharpedge.navigator.api.NavigationState;
	
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.sameInstance;

	
	/**
	 * @author epologee
	 */
	public class NavigationStateTest {
		
		[Test]
		public function pathStringEquality() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/");
			assertThat(a.path, equalTo(b.path));
			
			a.segments = ["a", "b", "c"];
			b = new NavigationState("a", "b", "c");
			assertThat(a.path, equalTo(b.path));	
			
			a.segments = [];
			b = new NavigationState("/");
			assertThat(a.path, equalTo(b.path));
		}
		
		[Test]
		public function advancedEquality() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/");
			assertThat("the equals method works on single segmented paths", a.equals(b), equalTo(true));
			
			a = new NavigationState("a", "b", "c");
			b = new NavigationState("a/b/c");
			assertThat("the equals method works on multi segmented paths", a.equals(b), equalTo(true));
			
			a = new NavigationState("a", "b", "c");
			b = new NavigationState("a/*/c");
			assertThat("the equals method works on multi segmented paths with wildcards", a.equals(b), equalTo(true));
			
			a = new NavigationState("a", "*", "c");
			b = new NavigationState("a/b/c");
			assertThat("the equals method works on multi segmented paths with wildcards (inverted)", a.equals(b), equalTo(true));
		}
		
		[Test]
		public function containment() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/subState");
			assertThat("a contains b", a.contains(b), equalTo(false));
			assertThat("b does not contain a", b.contains(a), equalTo(true));
		}
		
		[Test]
		public function subtraction() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("/anyState/subState");
			var c : NavigationState = new NavigationState("subState");
			assertThat("b subtract a == c", b.subtract(a).path, equalTo(c.path));
			assertThat("a subtract b == null", a.subtract(b), equalTo(null));
		}
		
		[Test]
		public function append() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("subState");
			var c : NavigationState = new NavigationState("/anyState/subState");			
			assertThat("a append b == c", a.append(b).path, equalTo(c.path));
		}
		
		[Test]
		public function prefix() : void {
			var a : NavigationState = new NavigationState("anyState");
			var b : NavigationState = new NavigationState("subState");
			var c : NavigationState = new NavigationState("/anyState/subState");			
			assertThat("b prefix a = c", b.prefix(a).path, equalTo(c.path));
		}
		
		[Test]
		public function hasWildcard() : void {
			var a : NavigationState = new NavigationState("anyState/*/subState");			
			assertThat("a has wildcard", a.hasWildcard());
		}
		
		[Test]
		public function masking() : void {
			var a : NavigationState = new NavigationState("anyState/*/subState/*/");
			var b : NavigationState = new NavigationState("anyOtherState/replaceState/subOtherState/replaceSubState/");	
			assertThat("mask a with b", a.mask(b).path, equalTo(new NavigationState("anyState/replaceState/subState/replaceSubState/").path));
		}
		
		[Test]
		public function clone() : void {
			var a : NavigationState = new NavigationState("anyState/subState");	
			assertThat("b is clone of a", a.clone().path, equalTo(a.path));
		}
		
		[Test]
		public function disposeAndPool() : void {
			var a : NavigationState = NavigationState.make("anyState");
			a.dispose();			
			assertThat("dispose a path reset", a.path, equalTo(new NavigationState("/")));
			
			var b : NavigationState = NavigationState.make("anyNewState");		
			assertThat("b === a because is taken from NavigationStatePool", a, sameInstance(b));
		}
	}
}


