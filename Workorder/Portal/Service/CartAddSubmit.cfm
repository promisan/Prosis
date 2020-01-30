
<cfquery name="AddCart" 
datasource= "AppsWorkOrder" 
username  = "#SESSION.login#" 
password  = "#SESSION.dbpw#">
    UPDATE Cart
	SET ActionStatus = '1'
	WHERE OfficerUserId = '#client.acc#'
</cfquery>
  
<!--- show cart --->
<cfinclude template="../../../../WorkOrder/Portal/Service/Cart.cfm">  
	

