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
<cfquery name="ContractSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  PersonContract
		WHERE ContractId = '#url.contractid#'			
</cfquery>

<cfif url.actionCode eq "3004">  

		
	<cfif url.effective eq "">
	
		<cfset mode = "0">
		
	<cfelse>
	
		<cfset dateValue = "">	
		<CF_DateConvert Value="#url.effective#">
		<cfset DTE = dateValue>

		<cfquery name="StepList" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_PostGradeStep
		  WHERE  PostGrade = '#ContractSel.ContractLevel#'
		  AND    DateEffective IN (
					SELECT   MAX(DateEffective) 
					FROM     Ref_PostGradeStep
					WHERE    PostGrade      = '#ContractSel.ContractLevel#'
					AND      DateEffective <= #dte#
					 )		
		  ORDER BY Step			 
					
		</cfquery>
		
		<cfif steplist.recordcount eq "0">
			<cfset mode = "0">
		<cfelse>
			<cfset mode = "1">		
		</cfif>
		
	</cfif>
	
	<cfif mode eq "0">	
	
		<cfquery name="Grade" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_PostGrade
				WHERE  PostGrade = '#ContractSel.ContractLevel#'
		</cfquery>

		<cfoutput>
		<select id="contractstep"	name="contractstep" class="regularxl" style="padding-top:2px;font-size:14px;width:60;text-align:center;background-color:fffffff;border:0px;border-right:1px solid silver">
	
			<cfloop index="st" from="1" to="#grade.PostGradeSteps#">
			     <cfif len(st) eq "1">
				 	<cfset val = "0#st#">
				 <cfelse>
				 	<cfset val = "#st#">	
				 </cfif>
				<option value="#val#" <cfif contractsel.contractStep eq val>selected</cfif>>#val#</option>
			</cfloop>	
		
		</select>	
		</cfoutput>
		
	<cfelse>
	
		<cfquery name="Last" dbtype="query">
			  SELECT MAX(Step) as LastStep 
			  FROM   StepList
	    </cfquery>
	
		<cfoutput>	
		<select id="contractstep"	name="contractstep" class="regularxl" style="padding-top:2px;font-size:14px;width:60;text-align:center;background-color:fffffff;border:0px;border-right:1px solid silver">	
			<cfloop query="steplist">			     
				<option value="#step#" <cfif contractsel.contractStep eq step>selected</cfif>>#step# <cfif last.laststep eq step>[final]</cfif></option>
			</cfloop>			
		</select>	
		</cfoutput>	
		
	</cfif>	

<cfelse>

	<cfoutput>

	<input type="text" 		
		    id="contractstep"				
			name="contractstep" 
			class="regularxl"
			value="#ContractSel.ContractStep#" 
			style="width:30;text-align:center;background-color:fffffff;border:0px;border-right:1px solid silver" 
			maxlength="4" 
	readonly>
	
	</cfoutput>

</cfif>
