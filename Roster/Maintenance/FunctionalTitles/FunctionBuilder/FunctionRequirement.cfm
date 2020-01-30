	
<cfquery name="Area"
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *, Parent as ParentCode
	FROM     Ref_ExperienceParent
	WHERE    Parent NOT IN ('Skills','Miscellaneous','History','Application')
	ORDER BY Area,SearchOrder
</cfquery>

<table width="99%"       
	   cellspacing="0"
       cellpadding="0"	  
       align="center"       
       id="structured">
		
	<cfset id  = RequirementId>
	<cfset row = CurrentRow>
	
	<cfoutput query="Area" group="Area">
	   
		<tr><td colspan="3" style="height:30px;padding-top:10px" class="labelmedium">
		<cfset ar = area>
		#area.area#</td></tr>
		
		<cfoutput>
		 			
			<cfquery name="Req"
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    FunctionRequirementLine
			WHERE   RequirementId = '#id#'
			AND     Parent = '#parentCode#'
			</cfquery>
			
			<!---
			<cfif req.recordcount neq "0">
			--->
			
			<tr style="height:15px;border-bottom:1px solid d4d4d4" class="labelit">
			  <td width="80" valign="top" style="padding-top:5px;padding-left:20px">#Description#</td>
			  <td width="70%" id="b#parentcode#_#currentRow#">
			  
				   <cfset box   = "hide">
				   <cfset boxid = "h#parentcode#_#currentRow#">
				   <cfset url.requirementId   = "#id#">
				   <cfinclude template="FunctionRequirementLine.cfm">
				   
			  </td>
	    	</tr>
			
			<!---
			</cfif>
			--->
			
		</cfoutput>
		
	</cfoutput>	
	
</table>
