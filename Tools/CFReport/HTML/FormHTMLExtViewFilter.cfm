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
 <form name="filter" id="filter">
 
 <cfquery name="PK" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT * 
  FROM  Ref_ReportControlCriteria
  WHERE ControlId = '#URL.ControlId#'
  AND   CriteriaName = '#URL.CriteriaName#'
 </cfquery>
  
<cfquery name="Init" 
   datasource="AppsSystem">
   SELECT     * 
   FROM       Parameter
</cfquery>	

<cfif findnocase("@parent","#PK.CriteriaValues#")>
  <cf_message message="Problem, your condition for field #URL.CriteriaName# contains a subquery condition. This is currently not supported">
  <cfabort>  
</cfif>

 <table width="100%">
  
 <cfquery name="Fields" 
  datasource="AppsSystem" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Ref_ReportControlCriteriaField 
	  WHERE  ControlId    = '#URL.ControlId#'
	  AND    CriteriaName = '#URL.CriteriaName#'
	  AND    Operational  = '1' 
	  ORDER BY FieldOrder
 </cfquery>
  
  <tr><td colspan="2">
  
    <table border="0" border="0" cellspacing="0" cellpadding="0">
		
	<tr>	
	
	<cfset bnd = "">
	
	<cfoutput query="Fields">
	
	<td height="100" style="padding-left:3px">		
					 
		<cfif currentrow eq "1">
		
			<cfdiv name="field_#fieldname#">
				<cfset url.fieldname = fieldname>
				<cfset url.fldno = "1">
				
				<cfinclude template="FormHTMLExtViewFilterSelect.cfm">
				
			</cfdiv>
			
			 <cfif bnd eq "">
			 	<cfset bnd = "#fieldname#={#fieldname#}">
			 <cfelse>
			    <cfset bnd = "#bnd#&#fieldname#={#fieldname#}">
			 </cfif>
		
		<cfelse>
		
			<cfdiv bind="url:FormHTMLExtViewFilterSelect.cfm?fldno=#currentrow#&controlid=#controlid#&criterianame=#url.criterianame#&fieldname=#fieldname#&#bnd#" 
			bindonload="No"			
			name="field_#fieldname#">
			 			 			 
		</cfif>	 
				
	</td>
	</cfoutput>
	
    </tr>
			
    </table>
	
	</td></tr>
	
	<tr><td class="line"></td></tr>
	<tr>
      <td height="28" colspan="2" align="center">
	  <cfoutput>
	    <input
			type="button" 
			class="button10g" 
			name="search" 
			id="search"
			value="Select"
			onclick="ColdFusion.navigate('FormHTMLExtViewResult.cfm?row=#URL.row#&ControlId=#URL.ControlId#&ReportID=#URL.ReportId#&CriteriaName=#URL.CriteriaName#','result','','','POST','filter')">
	  </cfoutput>	
	  </td>
    </tr>
			
	</table>
	  
  </form>
  