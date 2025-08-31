<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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






