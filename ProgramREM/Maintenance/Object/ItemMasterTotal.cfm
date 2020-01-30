
<cfquery name="Check"
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT count(*) as Total
   FROM   ItemMasterObject 
   WHERE  objectCode = '#url.code#'		   
</cfquery>

<cfoutput>
<a href="javascript:item('#url.code#')"><font color="4FA7FF">#Check.total#</font></a>
</cfoutput>