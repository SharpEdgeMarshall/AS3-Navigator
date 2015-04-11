# AS3-Navigator [![Build Status](https://travis-ci.org/SharpEdgeMarshall/AS3-Navigator.svg?branch=develop)](https://travis-ci.org/SharpEdgeMarshall/AS3-Navigator) [![Coverage Status](https://coveralls.io/repos/SharpEdgeMarshall/AS3-Navigator/badge.svg?branch=develop)](https://coveralls.io/r/SharpEdgeMarshall/AS3-Navigator?branch=develop)

AS3-Navigator is a FSM with views control in mind, it offers:
+ Fluent API
+ Guards
+ Hooks
+ Redirect

## Documentation & Support

TODO: write documentation.

# Quickstart

## Setup and Events
```as3
navigator = new Navigator("/");

navigator.addEventListener(NavigatorStateEvent.REQUESTED, onNewRequest);
navigator.addEventListener(NavigatorStateEvent.REDIRECTING, onRedirect);
navigator.addEventListener(NavigatorStateEvent.BLOCKED, onGuardBlock);
navigator.addEventListener(NavigatorStateEvent.CHANGING, onStateChanging);
navigator.addEventListener(NavigatorStateEvent.CHANGED, onStateChanged);
navigator.addEventListener(NavigatorStateEvent.COMPLETED, onRequestCompleted);
```

## Configuration
```as3
navigator.onExitFrom("/login/").addGuards(CheckLogin);

navigator.onEnterTo("/login/").addHooks(LoadUserCredentials);

navigator.onExitFrom("/usersList/").to("/usersList/user/*")
         .addGuards(checkUserExist)
         .addHooks(LoadUserData);

navigator.onEnterTo("/usersList/").addHooks(LoadUsers);

navigator.onExitFrom("/about/").redirectTo("/");
```

## Make Request
```as3
navigator.request("/main/");
```

## Guards

```as3
navigator.onEnterTo("/keepOut/").addGuards(new BlockingSyncGuard());
navigator.onEnterTo("/keepOut/").addGuards(BlockingSyncGuard);

navigator.onEnterTo("/welcome/").addGuards(new PassingAsyncGuard());
navigator.onEnterTo("/welcome/").addGuards(PassingAsyncGuard);

navigator.onEnterTo("/welcome/")
          .addGuards(
            function():Boolean
            {
              return true;
            }
          );
```

### Sync
```as3
public class BlockingSyncGuard implements IGuardSync
{
	public function BlockingGuard(){}

	public function approve():Boolean
	{
		return false;
	}
}
```

### Async
```as3
public class PassingAsyncGuard implements IGuardAsync
{
  private var _cb:Function;
  public function PassingAsyncGuard(){}

  public function approve(callback:Function):void
  {
    _cb = callback;
    //...call some async service
  }

  public function onServiceComplete(ev:Event):void
  {
    _cb(ev.result);
  }
}
```

## Hooks

```as3
navigator.onEnterTo("/iNeedData/").addHooks(new LoadDataSyncHook());
navigator.onEnterTo("/iNeedData/").addHooks(LoadDataSyncHook);

navigator.onEnterTo("/iNeedData/").addHooks(new LoadDataAsyncHook());
navigator.onEnterTo("/iNeedData/").addHooks(LoadDataAsyncHook);

navigator.onEnterTo("/iNeedData/")
          .addHooks(
            function():void
            {
              //...load data;
            }
          );
```

### Sync
```as3
public class LoadDataSyncHook implements IHookSync
{
  public function LoadDataSyncHook(){}

  public function execute():void
  {
    //...load data;
  }
}
```

### Async
```as3
public class LoadDataAsyncHook implements IHookAsync
{
  private var _cb:Function;
  public function LoadDataAsyncHook(){}

  public function execute(callback:Function):void
  {
    _cb = callback;
    //...call some async service
  }

  public function onServiceComplete(ev:Event):void
  {
    _cb();
  }
}
```



## Credits
Inspired by the [Navigator for ActionScript 3.0](https://github.com/epologee/navigator-as3).
