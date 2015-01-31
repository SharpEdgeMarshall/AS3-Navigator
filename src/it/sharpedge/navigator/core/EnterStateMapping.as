package it.sharpedge.navigator.core
{
	import flash.utils.Dictionary;
	
	import it.sharpedge.navigator.dsl.IEnterStateFromMapping;
	import it.sharpedge.navigator.dsl.IEnterStateMapping;

	public class EnterStateMapping extends StateMapping implements IEnterStateMapping, IEnterStateFromMapping
	{
		private var _redirectTo : String = null;
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
		public function from( state:String ):IEnterStateFromMapping{
			_fromDic ||= new Dictionary();
			
			return _fromDic[ state ] ||= new EnterStateMapping();
		}
		
		/**
		 * @inheritDoc
		 */
		public function redirectTo( state:String = null ):void {
			_redirectTo = state;
		}
	}
}