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
<table width="99%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <!---
    <tr>
		<td class="labelmedium">
			<b>Define one or more competencies required for this position.</b>
		</td>
	</tr>
	--->
		 
	 <cfquery name="GetCompetencies" 
		 datasource="AppsSelection" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">
			  
			SELECT CC.Description AS Category,C.*, FOC.PositionNo
		    FROM   Ref_Competence C
			INNER  JOIN Ref_CompetenceCategory CC
					ON   C.CompetenceCategory = CC.Code
			LEFT   JOIN  Employee.dbo.PositionCompetence FOC
					ON   FOC.CompetenceId = C.CompetenceId AND FOC.PositionNo = '#url.id1#'
			WHERE  C.Operational = 1
			ORDER  BY CC.Code, ListingOrder
			  
	</cfquery>
		
	<cfset columns= 3>
			
	<tr>
		<td>
		
			<form name="competenceform" id="competenceform">
			
			<table width="97%" cellspacing="0" cellpadding="0" align="center">
	
			<cfoutput query="GetCompetencies" group="Category">
			 
			 	<cfset cont   = 0>
			 
				 <tr>
				 	<td class="labelmedium" colspan="#columns#">
						<i>#Category#</i>
					</td>
				 </tr>
				 
				 <tr><td class="linedotted" colspan="#columns#"></td></tr>

				 <cfoutput>
				 	
					<cfif cont eq 0> <tr> </cfif>
					
					<cfif PositionNo neq "">
					   <cfset cl = "ffffcf">
					<cfelse>
					   <cfset cl = "ffffff">
					</cfif>
					
			 		<td style="background-color:###cl#;cursor:pointer;height:15px" onclick="document.getElementById('#CompetenceId#').click()" class="labelmedium">
						<input type="checkbox" class="radiol" name="#CompetenceId#" id="#CompetenceId#" <cfif wfstatus eq "closed">disabled</cfif>
						onclick="ColdFusion.navigate('PositionCompetenceSubmit.cfm?positionno=#url.id1#&competenceid=#CompetenceId#&action='+this.checked,'submitid','','','POST','competenceform')" <cfif PositionNo neq "">checked</cfif>>
						</td>
						<td  style="background-color:###cl#;height:16px;padding-left;4px" class="labelmedium">#Description#</td>
						<cfset cont = cont + 1>
					</td>
					<cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
					
		 		  </cfoutput>
				  
				  <tr><td colspan="#columns#" height="2px"></td></tr>
			
			</cfoutput>
			
			</table>
			
			</form>

		</td>
	</tr>	
	
	<tr><td id="submitid" align="center"></td></tr>

</table>	
				

