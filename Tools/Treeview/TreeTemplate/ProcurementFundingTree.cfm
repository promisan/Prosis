 
<cfoutput>

<cfif #Attributes.status# eq "1">

['Fund',null, 

<cfquery name="Fund" 
    datasource="AppsPurchase" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT DISTINCT P.Fund 
    FROM  UserQuery.dbo.#SESSION.acc#PurchaseSet P
</cfquery>

<cfloop query="Fund">

['#Fund.Fund#',null, 
       	 		
		<cfquery name="PO" 
		 datasource="AppsPurchase" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 SELECT DISTINCT PurchaseNo
         FROM  UserQuery.dbo.#SESSION.acc#PurchaseSet
	     WHERE Fund = '#Fund#'
		 </cfquery>
		 			
		  <cfloop query="PO">
		  	    ['#PurchaseNo#','#Attributes.destination#?ID=#Attributes.status#&ID1=#PurchaseNo#'],
		  </cfloop> 
				  
],			  
				   		 
 </cfloop> 	
 
]

<cfelse>

	['Purchase No',null, 
	
	       	 		
			<cfquery name="PO" 
			 datasource="AppsPurchase" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT DISTINCT PurchaseNo
	         FROM  UserQuery.dbo.#SESSION.acc#PurchaseSet
		     </cfquery>
			 			
			  <cfloop query="PO">
			  	    ['#PurchaseNo#','#Attributes.destination#?ID=#Attributes.status#&ID1=#PurchaseNo#'],
			  </cfloop> 
					  
	]			  
	 
</cfif>

</cfoutput>


