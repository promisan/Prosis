
<cfquery name="Remove" 
 datasource="AppsMaterials" 
 username=#SESSION.login# 
 password=#SESSION.dbpw#>
    DELETE Request
   WHERE RequestId = '#URL.ID#'
</cfquery>


<cfinclude template="HistoryList.cfm">

