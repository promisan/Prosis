
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
		<cfinclude template="../Topics/#Searchresult.FunctionPath#/TopicEdit.cfm">
		   		
	    <cfcatch>
		
		   <table width="100%" height="100" cellspacing="0" cellpadding="0">
		   <tr>
			   <td align="center">
				   <font size="2" color="FF0000">Topic Editor could be located. Please contact your administrator.</b></font>
			   </td>
		   </tr>
		   </table>
		  
		</cfcatch>
	
	</cftry>
	
</cfoutput>	
	
