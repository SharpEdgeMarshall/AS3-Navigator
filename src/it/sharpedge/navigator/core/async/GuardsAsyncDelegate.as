package it.sharpedge.navigator.core.async
{
	import it.sharpedge.navigator.api.IGuardAsync;

	public class GuardsAsyncDelegate
	{
		private var _guard:IGuardAsync;
		private var _guardsHandler:GuardsAsyncHandler;		
		
		public function get guard():IGuardAsync
		{
			return _guard;
		}
		
		public function GuardsAsyncDelegate( guardAsync:IGuardAsync, guardsHandler:GuardsAsyncHandler )
		{
			_guard = guardAsync;
			_guardsHandler = guardsHandler;
			
			guardsHandler.addDelegate(this);
		}

		public function call( valid:Boolean ):void {
			_guardsHandler.notifyValidation( this, valid );
		}
	}
}