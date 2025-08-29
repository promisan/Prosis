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

	<tr><td height="5px"></td></tr>

    <tr>
		<td class="labelmedium">
			Set one or more competencies required for this bucket.
		</td>
	</tr>
	
	<tr><td height="10px"></td></tr>
	 
	 <cfquery name="GetCompetencies" 
		 datasource="AppsSelection" 
		 username="#SESSION.Login#" 
		 password="#SESSION.dbpw#">
			  
		SELECT CC.Description AS Category,C.*, FOC.FunctionId
	    FROM   Ref_Competence C
		INNER  JOIN Ref_CompetenceCategory CC
				ON   C.CompetenceCategory = CC.Code
		LEFT   JOIN  FunctionOrganizationCompetence FOC
				ON   FOC.CompetenceId = C.CompetenceId AND FOC.FunctionId = '#url.idfunction#'
		WHERE  C.Operational = 1
		ORDER  BY CC.Code, ListingOrder			  
	</cfquery>
		
	<cfset columns= 3>
	
	<tr>
		<td>
			
			<table width="99%" align="center">
	
			<cfoutput query="GetCompetencies" group="Category">
			 
			 	<cfset cont   = 0>
			 
				 <tr class="line">
				 	<td class="labellarge" colspan="#columns*2#">#Category#</td>
				 </tr>
				
				 <cfoutput>
				 	
					<cfif cont eq 0> <tr> </cfif>
					
					<cfif FunctionId neq "">
					   <cfset cl = "ffffcf">
					<cfelse>
					   <cfset cl = "ffffff">
					</cfif>
					
			 		<td style="background-color:###cl#" 
					    style="cursor:pointer;width:30px" align="center" class="labelmedium">
						<input type="checkbox" class="radiol" name="#CompetenceId#" id="#CompetenceId#" 
						  onclick="submitCompetence(this,'#url.idfunction#','#CompetenceId#')" <cfif FunctionId neq "">checked</cfif>>
						</td>
						<td class="labelmedium" style="width:30%;padding-left:4px">#Description#</td>
						<cfset cont = cont + 1>
					</td>
					<cfif cont eq columns> </tr> <cfset cont = 0> </cfif>
					
		 		  </cfoutput>
				  
				  <tr><td colspan="#columns*2#" height="15px"></td></tr>
			
			</cfoutput>
			
			</table>

		</td>
	</tr>	
	
	<tr>
		<td id="submitid" align="center"></td>
	</tr>

</table>	
				

