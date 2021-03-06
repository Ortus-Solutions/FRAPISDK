component accessors=true singleton {

	property name='FREnabled' type='boolean' default='false';
	property name='FRAPI';

	/**
	* The constructor detects if FR is present and stores a flag that can short circuit all the methods in this service if FR isn't running
	*/
	function init() {
		
		try{
			FrapiClass = createObject("java","com.intergral.fusionreactor.api.FRAPI");
			// FR loads async, wait for it to be done.
			while( isNull( FrapiClass.getInstance() ) || !FrapiClass.getInstance().isInitialized() ) {
				sleep( 500 );
			}
			setFRAPI( FrapiClass.getInstance() );
			setFREnabled( true );
		} catch( any e ) {
			// If FR isn't present, this will hit the catch and this entire service will be "disabled"
			setFREnabled( false );
		}
		
    	return this;
	}
	
	/**
	* Start a named transaction in FR.  This transaction will stay "running" in FR until endTransaction() is called.
	* 
	* @name The short name of the transaction
	* @description Full details of this transaction
	*/
	function startTransaction( required string name, string description='', properties={} ) {
		if( !getFREnabled() ) {
			return {};
		}
		
		var FRTransaction = getFRAPI().createTrackedTransaction( name );
		var applicationName = 'Application';
		var applicationMetadata = getApplicationMetadata();
		if( !isNull( applicationMetadata.name ) ) {
			applicationName = applicationMetadata.name;
		}
		getFRAPI().setTransactionApplicationName( applicationName );
		FRTransaction.setDescription( description );
		for( var prop in properties ) {
			FRTransaction.setProperty( toString( prop ), properties[ prop ] );
		}
		return FRTransaction;
	}
	
	/**
	* Will close a transaction by reference 
	* 
	* @FRTransaction Instance of FR Transaction object, returned by previous call to startTransaction.
	*/
	function endTransaction( required FRTransaction ) {
		if( !getFREnabled() ) {
			return;
		}
		FRTransaction.close();
	}
	
	/**
	* Mark a transaction as having an error.  This will NOT end the transaction.  You must still do that. 
	* 
	* @FRTransaction Instance of FR Transaction object, returned by previous call to startTransaction.
	* @javaException Instance of Java exception object that represents the error
	*/
	function errorTransaction( required FRTransaction, required javaException ) {
		if( !getFREnabled() ) {
			return;
		}
		// Adobne's catch block is of type java.lang.Throwable, but Lucee's is not.
		if( javaException.getClass().getName() == 'lucee.runtime.exp.CatchBlockImpl' ) {
			javaException = javaException.getPageException();
		}
		FRTransaction.setTrappedThrowable( javaException );
	}
		
	/**
	* Override the name of the current transaction
	* 
	* @name The short name of the transaction
	*/
	function setCurrentTransactionName( required string name ) {
		if( !getFREnabled() ) {
			return;
		}
		getFRAPI().setTransactionName( arguments.name );
	}	
	
	/**
	* Override the name of the current transaction's application name
	* 
	* @name The name of the application
	*/
	function setCurrentTransactionApplicationName( required string name ) {
		if( !getFREnabled() ) {
			return;
		}
		getFRAPI().setTransactionApplicationName( arguments.name );
	}
	
	
}
