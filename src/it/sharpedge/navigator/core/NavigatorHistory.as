package it.sharpedge.navigator.core
{
	import it.sharpedge.navigator.api.INavigator;
	import it.sharpedge.navigator.api.INavigatorHistory;
	import it.sharpedge.navigator.events.NavigatorStateEvent;

	public class NavigatorHistory implements INavigatorHistory {
		// Default max history length
		public static const MAX_HISTORY_LENGTH : int = 100;
		// Navigation direction types
		public static const DIRECTION_BACK : int = -1;
		public static const DIRECTION_NORMAL : int = 0;
		public static const DIRECTION_FORWARD : int = 1;
		//
		// The navigator it is controlling
		private var _navigator : INavigator;
		// The history, last state is at start of Array
		private var _history : Vector.<NavigationState>;
		// The current position in history
		private var _historyPosition : int = 0;
		// The navigator doesn't know anything about going forward or back.
		// Therefore, we need to keep track of the direction.
		// This is changed when the forward or back methods are called.
		private var _navigationDirection : int = DIRECTION_NORMAL;
		// The max number of history states
		private var _maxLength : int = MAX_HISTORY_LENGTH;
		
		/**
		 * Create the history manager. When navigating back and forword, the history is maintained. 
		 * It is truncated when navigating to a state naturally
		 * 
		 * @param navigator Navigator reference
		 */
		public function NavigatorHistory(navigator : INavigator) {
			_navigator = navigator;
			_navigator.addEventListener(NavigatorStateEvent.CHANGED, handleStateChange);
			_history = new Vector.<NavigationState>();
		}
		
		/**
		 * @inheritDoc
		 */
		public function dispose():void {
			_navigator.removeEventListener(NavigatorStateEvent.CHANGED, handleStateChange);
			_history = null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set maxLength(value : int) : void {
			_maxLength = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get maxLength() : int {
			return _maxLength;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get history() : Vector.<NavigationState> {
			return _history;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPreviousState(steps : int = 1) : NavigationState {
			if (_historyPosition == _history.length - 1 || _history.length == 0) {
				return null;
			}
			
			var pos : int = Math.min(_history.length - 1, _historyPosition + steps);
			return _history[pos];
		}

		/**
		 * @inheritDoc
		 */
		public function getNextState(steps : int = 1) : NavigationState {
			if (_historyPosition == 0) {
				return null;
			}
			
			var pos : int = Math.max(0, _historyPosition - steps);
			return _history[pos];
		}
		
		/**
		 * @inheritDoc
		 */
		public function clearHistory() : void {
			_history = new Vector.<NavigationState>();
			_historyPosition = 1;
		}

		/**
		 * @inheritDoc
		 */
		public function back(steps : int = 1) : Boolean {
			if (_historyPosition == _history.length - 1) {
				return false;
			}
			_historyPosition = Math.min(_history.length - 1, _historyPosition + steps);
			_navigationDirection = NavigatorHistory.DIRECTION_BACK;
			navigateToCurrentHistoryPosition();
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function forward(steps : int = 1) : Boolean {
			if (_historyPosition == 0) {
				return false;
			}
			_historyPosition = Math.max(0, _historyPosition - steps);
			_navigationDirection = NavigatorHistory.DIRECTION_FORWARD;
			navigateToCurrentHistoryPosition();
			return true;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getStateByPosition(position : int) : NavigationState {
			if (position < 0 || position > _history.length - 1) {
				return null;
			}
			return _history[position] as NavigationState;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getPositionByState(state : NavigationState) : int {
			return _history.indexOf(state);
		}
		
		/**
		 * Tell the navigator to go the current historyPosition
		 */
		private function navigateToCurrentHistoryPosition() : void {
			var newState : NavigationState = _history[_historyPosition];
			_navigator.request(newState);
		}
		
		/**
		 * Check what to do with the new state
		 */
		private function handleStateChange(event : NavigatorStateEvent) : void {
			var state : NavigationState = event.newState;
			
			switch (_navigationDirection) {
				case NavigatorHistory.DIRECTION_BACK:
					_navigationDirection = NavigatorHistory.DIRECTION_NORMAL;
					break;
				case NavigatorHistory.DIRECTION_NORMAL:
					// Strip every history state before current
					_history.splice(0, _historyPosition);
					// Add the state at the beginning of the history array
					_history.unshift(state);
					_historyPosition = 0;
					// Truncate the history to the max allowed items
					_history.length = Math.min(_history.length, _maxLength);
					break;
				case NavigatorHistory.DIRECTION_FORWARD:
					_navigationDirection = NavigatorHistory.DIRECTION_NORMAL;
					break;
			}
		}
	}
}