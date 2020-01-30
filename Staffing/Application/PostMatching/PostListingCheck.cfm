

<!--- check if post exists --->

<cfquery name="Check" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT * 
   FROM   Position
   WHERE  PositionNo = '#URL.PositionNo#'
</cfquery>

<cfoutput>

<cfif check.recordcount eq "1">
   <img src="#SESSION.root#/Images/join.gif" alt="Associate a position to this external post" border="0">						
<cfelse>
   <img src="#SESSION.root#/Images/delete5.gif" alt="Deleted" border="0">						

</cfif>

</cfoutput>