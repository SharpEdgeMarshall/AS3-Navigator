package it.sharpedge.navigator.core
{
	import it.sharpedge.navigator.dsl.IStateMapping;

	public class StateMapping implements IStateMapping
	{
		
		private var _guards:Array = [];
		
		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}
		
		private var _hooks:Array = [];
		
		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/
		
		/**
		 * Creates a State Mapping
		 */
		public function StateMapping()
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function addGuards( ... guards ):IStateMapping
		{
			_guards = _guards.concat.apply( null, guards );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function addHooks( ... hooks ):IStateMapping
		{
			_hooks = _hooks.concat.apply( null, hooks );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeGuard( guard : * ):IStateMapping
		{
			var index : int = _guards.indexOf( guard );
			
			if( index == -1 ) return this;
			
			_guards.splice( index, 1 );
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeHook( hook : * ):IStateMapping
		{
			var index : int = _hooks.indexOf( hook );
			
			if( index == -1 ) return this;
			
			_hooks.splice( index, 1 );
			return this;
		}
		
	}
}