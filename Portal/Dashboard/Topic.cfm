
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfajaximport>

<cfoutput>
<script language="JavaScript1.2">
function drill(lnk) {
	    window.open("#SESSION.root#/" + lnk,"drill", "width=825, height=730, status=yes, scrollbars=yes, resizable=yes");
}
</script>
</cfoutput>

<cfoutput>

	<cfquery name="SearchResult" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   * 
			FROM     Ref_ModuleControl 
			WHERE    SystemFunctionId = '#url.Id#'
	</cfquery>
	
		
    <cftry>
	
	    <cfset url.mode = "dashboard">
		<cfset systemfunctionid = url.id>
		
		<cfinclude template="../Topics/#Searchresult.FunctionPath#/Topic.cfm">
		   		
	    <cfcatch>
		
		   <table width="100%" height="100" cellspacing="0" cellpadding="0">
		   <tr>
			   <td align="center">
			   
				   <font size="2" color="FF0000">Topic could not be located. Please contact your administrator.</b></font>
			   </td>
		   </tr>
		   </table>
		  
		</cfcatch>
	
	</cftry>
	
</cfoutput>	
	
