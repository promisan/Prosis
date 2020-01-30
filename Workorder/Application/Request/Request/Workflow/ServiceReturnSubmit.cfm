
<!--- assign the request header fields to a user and a service id --->


<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset exp = dateValue>
<cfelse>
    <cfset exp = 'NULL'>
</cfif>	

<cfquery name="setstatus"
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE  Request
   SET     DateExpiration  = #exp#
   WHERE   RequestId       = '#Object.ObjectKeyValue4#'	
</cfquery>		
