package it.sharpedge.navigator.core
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.IExitStateMapping;
	import it.sharpedge.navigator.dsl.IStateMapping;
	

	public class ExitStateMapping extends StateMapping implements IExitStateMapping
	{
		private var _toDic : Dictionary = null;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Exit State Mapping
		 */
		public function ExitStateMapping()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function to( stateOrPath:String ):IStateMapping {
			_toDic ||= new Dictionary();
			
			return _toDic[ NavigationState.make( stateOrPath ).path ] ||= new StateMapping();
		}
	}
}