package it.sharpedge.navigator.core.tasks.base
{
	import flash.events.Event;
	
	import it.sharpedge.navigator.api.IGuardAsync;
	import it.sharpedge.navigator.api.IGuardSync;
	import it.sharpedge.navigator.core.Navigator;
	import it.sharpedge.navigator.core.RoutingQueue;
	import it.sharpedge.navigator.core.StateMapping;
	import it.sharpedge.navigator.core.async.GuardsAsyncDelegate;
	import it.sharpedge.navigator.core.async.GuardsAsyncHandler;
	import it.sharpedge.navigator.core.ns.navigator;
	import it.sharpedge.navigator.core.ns.routing;
	
	use namespace routing;
	use namespace navigator;
	
	public class ExecuteGuards
	{	
		private var guardsAsyncHandler:GuardsAsyncHandler;
		private var router:RoutingQueue;
		
		public function ExecuteGuards() {
			
		}
		
		protected function validateGuards( router:RoutingQueue, mapping:StateMapping ):void {			
			this.router = router;
			
			for each( var guard:Object in mapping.guards ){					
				if (guard is Function)
				{
					if ((guard as Function)( router.currentState, router.requestedState ))
						continue;
					
					invalidateRoute(router);
					return;
				} 
				else if (guard is Class)
				{
					guard = new (guard as Class);
				}
				
				if( guard is IGuardSync && !guard.approve( router.currentState, router.requestedState ) ) {
					invalidateRoute(router);
					return;
				}else if(guard is IGuardAsync){
					guardsAsyncHandler = guardsAsyncHandler || new GuardsAsyncHandler( );
					(guard as IGuardAsync).approve( router.currentState, router.requestedState, new GuardsAsyncDelegate( (guard as IGuardAsync), guardsAsyncHandler ).call );
				} 

			}			
			
			if( !guardsAsyncHandler ) router.next(); // If there isn't async guard continue	
			else if( !guardsAsyncHandler.busy ) onCompleteCallback(); // If async handler has completed already call completeCallBack
			else guardsAsyncHandler.addEventListener( Event.COMPLETE, onCompleteCallback ); // If it's running wait
		}
		
		private function onCompleteCallback(ev:Event=null):void{
			
			guardsAsyncHandler.removeEventListener( Event.COMPLETE, onCompleteCallback );
			
			if(guardsAsyncHandler.valid) {
				guardsAsyncHandler = null;
				router.next();
			} else 
				invalidateRoute(router);
		}
		
		private function invalidateRoute(router:RoutingQueue):void {
			guardsAsyncHandler = null;
			Navigator.logger.info("Stopped by Guard");
			router.stop();
		}
	}
}