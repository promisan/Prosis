
<cfquery name="Check" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_TransactionClass
	WHERE   Code = '#Attributes.TransactionClass#'
</cfquery>

<cfif Check.recordcount eq "0">

	<cfquery name="Insert" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		INSERT INTO Ref_TransactionClass
		      		 (Code,Description,ListingOrder,QuantityNegative) 
		VALUES ('#Attributes.TransactionClass#',
	    	    '#Attributes.TransactionClass#',
				'#Attributes.Listingorder#',
				'#Attributes.QuantityNegative#')
	</cfquery>
				
</cfif>

