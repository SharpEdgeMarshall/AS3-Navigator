package it.sharpedge.navigator.core
{
	import it.sharpedge.navigator.dsl.IEnterStateMapping;
	import it.sharpedge.navigator.dsl.IExitStateMapping;

	public class Navigator
	{
		
		
		/**
		 * Get an EnterStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onEnter( state:String ):IEnterStateMapping {
			
		}
		
		/**
		 * Get an ExitStateMapping for that state
		 * @param state The state that you want to map.
		 * @return the mapping object so that you can continue the mapping.
		 */
		public function onExit( state:String ):IExitStateMapping {
			
		}
		
	}
}