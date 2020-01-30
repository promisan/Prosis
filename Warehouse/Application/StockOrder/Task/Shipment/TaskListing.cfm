
<table width="100%" height="100%">

<tr>
	<td height="2">
	
	<cfquery name="Get" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT     *
			FROM      Ref_TaskType
			WHERE     Code = '#url.tasktype#'
	</cfquery>
	
	<cfquery name="GetHeader" 
		  datasource="AppsMaterials" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT  *
			FROM    Status
			WHERE   Class = 'Taskorder' 
			AND     Status = '#URL.STA#'
	</cfquery>
	
		<font face="Verdana" size="1">TaskOrder:</font> 
		<font face="Verdana" size="3"> <cfoutput>#get.Description# / #getHeader.Description#</cfoutput></font>
	
	</td>
</tr>

<tr><td height="5"></td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td height="3"></td></tr>

<tr><td height="100%">		

<cfinclude template="TaskListingContent.cfm">		  
	
</td></tr>
</table>		
