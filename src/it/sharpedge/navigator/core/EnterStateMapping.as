package it.sharpedge.navigator.core
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.api.NavigationState;
	import it.sharpedge.navigator.dsl.IEnterStateFromMapping;
	import it.sharpedge.navigator.dsl.IEnterStateMapping;

	public class EnterStateMapping extends StateMapping implements IEnterStateMapping, IEnterStateFromMapping
	{
		private var _redirectTo : NavigationState = null;
		private var _fromDic : Dictionary = null;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a Enter State Mapping
		 */
		public function EnterStateMapping()
		{
			super();
		}
		
		/**
		 * @inheritDoc
		 */
		public function from( stateOrPath:String ):IEnterStateFromMapping{
			_fromDic ||= new Dictionary();
			
			return _fromDic[ NavigationState.make( stateOrPath ).path ] ||= new EnterStateMapping();
		}
		
		/**
		 * @inheritDoc
		 */
		public function redirectTo( stateOrPath:String = null ):void {
			
			// Dispose
			if( _redirectTo ) _redirectTo.dispose();
			
			_redirectTo = NavigationState.make( stateOrPath ).clone();
		}
	}
}