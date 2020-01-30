
<cfparam name="Form.ListingOrder"   default="1">
<cfparam name="Form.Description"    default="">
<cfparam name="Form.Amount"         default="">

<cfif not LSIsNumeric(Form.amount)>
   <script>
    alert("Invalid amount")
   </script>
</cfif>

<cfset amt      = replace("#form.Amount#",",","","ALL")>

<cfif URL.ID2 neq "">

	 <cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE PurchaseExecution
		  SET    ListingOrder        = '#Form.ListingOrder#', 
 		         Description         = '#Form.Description#',
				 Amount              = '#amt#'
		 WHERE ExecutionId = '#URL.id2#'
	</cfquery>
		
	<cfset url.id2 = "0">
				
<cfelse>
			
	<cfquery name="Insert" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PurchaseExecution
	         (PurchaseNo,
			 Description,
			 ListingOrder,
			 Amount,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
	      VALUES ('#URL.ID1#',
		      '#Form.Description#',
			  '#Form.ListingOrder#',
			  '#amt#',
			  '#SESSION.acc#',
			  '#SESSION.last#',
			  '#SESSION.first#') 
	</cfquery>
					
	<cfset url.id2 = "">
	
		   	
</cfif>

<cfoutput>
  <script>
    ColdFusion.navigate('POViewDistribution.cfm?id1=#URL.id1#&ID2=#url.id2#','boxdistribution')	
  </script>	
</cfoutput>
