
<cfquery name="UpdateUser" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE   UserDashBoard 
SET      Scrolling        = '<cfif #URL.scroll# eq "True">Yes<cfelse>No</cfif>'
WHERE Account = '#SESSION.acc#'
AND   DashboardFrame = '#URL.Frm#'
</cfquery>

<cflocation url="UserEditDashboard.cfm" addtoken="No">

