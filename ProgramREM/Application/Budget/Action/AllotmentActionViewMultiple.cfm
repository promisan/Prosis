
<!--- allotment view multiple --->


<table width="100%" align="center" style="padding:15px">

<tr>
	
	<td valign="top" style="padding-left:4px;width:170;border-right:1px solid silver" height="100%">
	
	   <table cellspacing="0" cellpadding="0" class="formpadding">
	   
	   <cfset row = 0>
	   
	   <cfloop index="action" list="#url.actions#" delimiters=":">
	   
	   	<cfset row = row+1>
	   
	   <cfquery name="getAction"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM       ProgramAllotmentAction 
			WHERE      ActionId = '#action#'
		</cfquery>	
		
		<cfoutput query="getAction">
		<tr>
			<td>#row#.</td>
			<td style="padding-left:4px" class="labelit">
			<a href="javascript:ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#action#','submain')">
			<font color="0080C0">#Reference#</font>
			</a>
			</td>
		</tr>
		</cfoutput>
	      
	   </cfloop>
	   
	   </table>
		
	</td>
	
	<td style="width:80%" id="submain" valign="top">
		<cfdiv bind="url:#session.root#/ProgramREM/Application/Budget/Action/AllotmentActionViewContent.cfm?ID=#url.id#">
	</td>

</tr>

</table>