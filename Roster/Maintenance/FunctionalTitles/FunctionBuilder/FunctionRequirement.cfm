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
