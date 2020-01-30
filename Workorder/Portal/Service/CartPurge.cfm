
<cfparam name="URL.ID" default="All">

<cfif URL.ID neq "All">

  <cfquery name="Update" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
       DELETE Cart
  	   WHERE  CartId = '#URL.ID#'
	   AND    OfficerUserid = '#CLIENT.acc#'
   </cfquery>
   
<cfelse>

   <cfquery name="Update" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
    DELETE Cart
	WHERE  OfficerUserId = '#CLIENT.acc#'
   </cfquery>
   
</cfif>

<cfinclude template="Cart.cfm">

