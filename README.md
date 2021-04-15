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
