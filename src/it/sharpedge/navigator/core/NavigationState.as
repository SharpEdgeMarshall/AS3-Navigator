package it.sharpedge.navigator.core
{
	

	public class NavigationState
	{
		/*============================================================================*/
		/* Static                                                                     */
		/*============================================================================*/
		
		public static const WILDCARD : String = "*";
		public static const DOUBLE_WILDCARD : String = WILDCARD + WILDCARD;
		public static const DELIMITER : String = "/";
		
		public static function make(stateOrPath:*, clone:Boolean=true) : NavigationState {
			return stateOrPath is NavigationState ? (clone ? NavigationState(stateOrPath).clone(): stateOrPath) : NavigationStatePool.getNavigationState(stateOrPath);
		}
		
		/*============================================================================*/
		/* Getter/Setters                                                             */
		/*============================================================================*/
		
		private var _path : String;
		/**
		 * A path will always start and end with a slash /
		 * All double slashes // will be removed and white spaces are 
		 * replaced by dashes -.
		 */
		public function set path( path:String ):void {
			// Calculate path
			_path = DELIMITER + path.toLowerCase() + DELIMITER;
			_path = _path.replace(new RegExp("\/+", "g"), "/");
			_path = _path.replace(/\s+/g, "-");
			
			// Calculate segments
			_segments = _path.split(DELIMITER);			
			// pop emtpy string off the back.
			if (!_segments[_segments.length - 1])
				_segments.pop();			
			// shift empty string off the start.
			if (!_segments[0])
				_segments.shift();
		}
		
		public function get path():String {
			return _path;
		}
		
		private var _segments:Array;
		
		/**
		 * Set the path as a list of segments (or path components).
		 * Example: ["a", "b", "c"] will result in a path /a/b/c/
		 */
		public function set segments( segments:Array ):void {
			path = segments.join(DELIMITER);
		}
		
		/**
		 * Returns the path cut up in segments (or path components).
		 */
		public function get segments():Array {
			return _segments.concat();
		}
		
		public function get length():int {
			return _segments.length;
		}
		
		public function set length( length:int ):void {
			if (length > _segments.length) throw new Error("Can't extend the segment length by number, use segments = [...]");
			
			segments = _segments.slice(0, length);
		}
		
		/**
		 * @param ...inSegements: Pass the desired path segments as a list of arguments, or pass it all at once, as a ready-made path.
		 * 
		 * Examples:
		 * 
		 * 		new NavigationState("beginning/end");
		 * 		new NavigationState("beginning", "end");
		 */
		public function NavigationState( ...segments:Array ) {
			path = segments.join(DELIMITER);
		}
		
		/**
		 * @return whether the path of the foreign state is contained by this state's path, wildcards may be used.
		 * @example
		 * 
		 * 	a = new State("/bubble/gum/");
		 * 	b = new State("/bubble/");
		 * 	
		 * 	a.contains(b) will return true.
		 * 	b.contains(a) will return false.
		 * 	
		 */
		public function contains( foreignState:NavigationState ):Boolean {
			var foreignSegments : Array = foreignState.segments;
			
			if (foreignSegments.length > _segments.length) {
				// foreign segment length too big
				return false;
			}
			
			// check to see if the overlapping segments match.
			var leni : int = foreignSegments.length;
			for (var i : int = 0;i < leni;i++) {
				var foreignSegment : String = foreignSegments[i];
				var nativeSegment : String = _segments[i];
				
				if( foreignSegment != nativeSegment && foreignSegment != WILDCARD && nativeSegment != WILDCARD ) 
					return false;				
			}
			
			return true;
		}
		
		/**
		 * Will test for equality between states. This comparison is wildcard safe!
		 * @example
		 * 		a/b/c equals a/b/*
		 */
		public function equals( state:NavigationState ):Boolean {
			var foreignSegments : Array = state.segments;
			
			if ( foreignSegments.length != _segments.length ) return false;
			
			if( foreignSegments.path == state.path ) return true;
			
			// check to see if the overlapping segments match.
			for (var i : int = foreignSegments.length - 1;i >= 0;i--) {
				var foreignSegment : String = foreignSegments[i];
				var nativeSegment : String = _segments[i];
				
				if( foreignSegment != nativeSegment && foreignSegment != WILDCARD && nativeSegment != WILDCARD ) 
					return false;				
			}
			
			return true;
		}
		
		/**
		 * Subtracts the path of the operand from the current state and returns it as a new NavigationState instance.
		 * Subtraction uses containment as the main method of comparison, therefore wildcard safe!
		 * @example
		 * 		/portfolio/editorial/84/3 - /portfolio/ = /editorial/84/3
		 * 		/portfolio/editorial/84/3 - * = /editorial/84/3
		 */
		public function subtract( operand:NavigationState ):NavigationState {
			if (!contains(operand))
				return null;
			
			var ns : NavigationState = NavigationStatePool.getNavigationState();
			var subtract : Array = segments;
			subtract.splice(subtract.indexOf( operand.segments[0] ), operand.segments.length);
			ns.segments = subtract;
			return ns;
		}
		
		/**
		 * Return a new NavigationState made from appending <code>trailingStateOrPath</code> to this state
		 * @example
		 * 		/portfolio/editorial/ + /84/3/ = /portfolio/editorial/84/3/
		 * 		/portfolio/editorial/84/3 + * = /editorial/84/3/*
		 */		
		public function append( trailingStateOrPath:* ):NavigationState {
			return NavigationStatePool.getNavigationState(_path, make(trailingStateOrPath,false).path);
		}
		
		/**
		 * Return a new NavigationState made from prefixing <code>trailingStateOrPath</code> to this state
		 * @example
		 * 		/portfolio/editorial/ + /84/3/ = /84/3/portfolio/editorial/
		 * 		/portfolio/editorial/84/3 + main = /main/editorial/84/3/
		 */	
		public function prefix( leadingStateOrPath:* ):NavigationState {
			return NavigationStatePool.getNavigationState( make(leadingStateOrPath,false).path, _path);
		}
		
		public function hasWildcard():Boolean {
			return _path.indexOf(WILDCARD) != -1;
		}
		
		/**
		 * Return a new NavigationState made from masking wildcards with values from <code>source</code>.
		 */
		public function mask( source:NavigationState ):NavigationState {
			if (!source)
				return clone();
			
			var unmaskedSegments : Array = segments;
			var sourceSegments : Array = source.segments;
			var leni : int = Math.min(sourceSegments.length, unmaskedSegments.length);
			for (var i : int = 0;i < leni ;i++) {
				if ( unmaskedSegments[i] == NavigationState.WILDCARD && sourceSegments[i] != NavigationState.WILDCARD ) {
					unmaskedSegments[i] = sourceSegments[i];
				}
			}

			return NavigationStatePool.getNavigationState.apply( null, unmaskedSegments );
		}
		
		public function dispose():void {			
			path = "/";
			NavigationStatePool.disposeNavigationState( this );
		}
		
		public function clone():NavigationState {
			return NavigationStatePool.getNavigationState( _path );
		}
		
		public function toString() : String {
			return _path;
		}
	}
}