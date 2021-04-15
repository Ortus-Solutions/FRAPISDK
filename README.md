# FRAPISDK

FusionReactor API SDK.  A simple CFML library for some common FRAPI functions.

## Requirements

* FusionReactor installed.  If it's not installed, this lib won't error, it just won't do anything
* ColdFusion 2018+ or Lucee Server

## Installation

```bash
install frapisdk
```
And then access it like this
```js
getInstance( 'FRTransService@frapisdk' ).setCurrentTransactionName( 'My custom name' );
```
This should work find in a non-ColdBox app.  Just manually create the CFC.  It is receommented to use this as a singleton.


```js
application.FRTransService = new modules.frapisdk.models.FRTransService();

application.FRTransService.setCurrentTransactionName( 'My custom name' );
```

# Usage

Override the name of the current transaction

```js
FRTransService.setCurrentTransactionName( 'My custom name' );
```


Override the name of the current transaction's application name

```js
FRTransService.setCurrentTransactionApplicationName( 'My custom app name' );
```

Track a custom transaction (will be autlmatically associated with the web request master transaction)

```js
var tran = FRTransService.startTransaction( 'name', 'description' );
try {
  // Do stuff here
} catch( any e ) {
  FRTransService.errorTransaction( tran, e );
  rethrow;
} finally {
  // you MUST call this or the transaction will never show as being finished in FR's interfacet
  FRTransService.endTransaction( tran )
}
```
