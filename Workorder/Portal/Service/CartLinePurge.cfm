
<cfquery name="Delete" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	  DELETE  FROM Cart
	  WHERE   Cartid = '#URL.ID2#'			 
</cfquery>
	
<cfset url.id2 = "new">
<cfinclude template="CartLine.cfm">
