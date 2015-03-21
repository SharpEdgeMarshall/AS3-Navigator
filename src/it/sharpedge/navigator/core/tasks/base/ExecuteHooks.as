package it.sharpedge.navigator.core.tasks.base
{
	import flash.events.Event;
	
	import it.sharpedge.navigator.api.IHookAsync;
	import it.sharpedge.navigator.api.IHookSync;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.StateMapping;
	import it.sharpedge.navigator.core.async.HooksAsyncDelegate;
	import it.sharpedge.navigator.core.async.HooksAsyncHandler;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace routing;
	use namespace navigator;
	
	public class ExecuteHooks
	{	
		private var hooksAsyncHandler:HooksAsyncHandler;
		private var router:RoutingQueue;
		
		public function ExecuteHooks() {
			
		}
		
		protected function executeHooks( router:RoutingQueue, mapping:StateMapping ):void {			
			this.router = router;
			
			for each( var hook:Object in mapping.hooks ){					
				if (hook is Function)
				{
					(hook as Function)();
					continue;
				} 
				else if (hook is Class)
				{
					hook = new (hook as Class);
				}
				
				if( hook is IHookSync ) {
					( hook as IHookSync ).hook();
				}else if(hook is IHookAsync){
					hooksAsyncHandler = hooksAsyncHandler || new HooksAsyncHandler( );
					(hook as IHookAsync).hook( new HooksAsyncDelegate( (hook as IHookAsync), hooksAsyncHandler ).call );
				} 

			}			
			
			if( !hooksAsyncHandler ) router.next(); // If there isn't async hook continue	
			else if( !hooksAsyncHandler.busy ) onCompleteCallback(); // If async handler has already complete call completeCallBack
			else hooksAsyncHandler.addEventListener( Event.COMPLETE, onCompleteCallback ); // If it's running wait
		}
		
		private function onCompleteCallback(ev:Event=null):void{
			
			hooksAsyncHandler.removeEventListener( Event.COMPLETE, onCompleteCallback );
			
			hooksAsyncHandler = null;
			router.next();
		}
	}
}