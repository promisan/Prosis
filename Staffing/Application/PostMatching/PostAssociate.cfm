
<cfset status = "Go">

<!--- verify if postnumber was assigned --->

<cfquery name="Mandate" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT Mission, MandateNo
   FROM Position
   WHERE PositionNo = '#URL.PositionNo#'  
</cfquery>

<cfquery name="Verify0" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT PositionNo
   FROM Position
   WHERE SourcePostNumber = '#URL.RecordId#'
   AND   Source = '#URL.DocumentNo#'
   AND   Mission     = '#Mandate.Mission#'
   AND   MandateNo   = '#Mandate.MandateNo#' 
</cfquery>

<cfif Verify0.recordCount eq 0>

  <cfset status = "Go">

<cfelse>

<!--- check period that was covered already --->

<cfquery name="Verify2" 
datasource="AppsEmployee" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
   FROM Position
   WHERE SourcePostNumber = '#URL.RecordId#'
   AND   Source           = '#URL.DocumentNo#'
   AND   Mission     = '#Mandate.Mission#'
   AND   MandateNo   = '#Mandate.MandateNo#'
</cfquery>

<cfloop query = "Verify2">

<cfquery name="Verify3" 
datasource="AppsEmployee" 
maxrows=1 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT PositionNo
   FROM  Position
   WHERE PositionNo = '#URL.PositionNo#'
   AND DateEffective > '#DateFormat(Verify2.DateExpiration,client.dateSQL)#' 
   OR DateExpiration < '#DateFormat(Verify2.DateEffective,client.dateSQL)#' 
</cfquery>

<cfif Verify0.recordCount eq 0>

  <cfset status = "Stop">
  
</cfif>

</cfloop>

</cfif>

<cfif status eq "Go">

   <cfquery name="Update" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   UPDATE Position
   SET   Source = '#URL.DocumentNo#', 
         SourcePostNumber = '#URL.RecordId#'
   WHERE PositionNo = '#URL.PositionNo#' 
  </cfquery>
  
  <script language="JavaScript">

   parent.window.close()
   opener.location.reload()

  </script>
  
<cfelse>  

  <script language="JavaScript">

   alert("Position can't be associated")
   history.back()

  </script>

</cfif>






