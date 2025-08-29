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
<cfquery name="Observation" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM   Observation
	  WHERE  ObservationId IN (SELECT ObjectKeyValue4 
	                           FROM   Organization.dbo.OrganizationObject
							   WHERE  ObjectId = '#URL.ObjectId#' 							  
							 )	 
	  OR    ObservationId = '#URL.ObjectId#'						 
</cfquery>

<cfif Observation.recordcount eq "0">
	
	<table width="100%" align="center" height="40" border="0" cellspacing="0" cellpadding="0">
		<tr><td class="labelit" style="padding-left:30px"><font color="FF0000">Template object not supported</font></td></tr>
	</table>

<cfelse>
	
	<cfoutput>
	
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		
			<tr><td height="2"></td></tr>
			
			<cfset url.box = "b#url.box#">
			
			<cfset link = "#SESSION.root#/tools/entityaction/details/template/TemplateFile.cfm?box=#url.box#||actioncode=#ActionCode#||observationid=#observation.observationid#">
					
			<tr><td height="20" colspan="6" align="left" class="labelmediumcl">
			
			   <cf_selectlookup
			    class    = "Template"
			    box      = "#url.box#"
				title    = "Record a Template subject of modification"
				link     = "#link#"		
				width="800"	
				dbtable  = "Control.dbo.ObservationTemplate"
				des1     = "PathName"
				des2     = "FileName">
						
			</td>
			</tr> 				
			
			<tr bgcolor="ffffff">
		    <td width="100%" colspan="2" class="labelit" id="#url.box#">				
				<cfdiv bind="url:#SESSION.root#/tools/entityaction/details/template/TemplateFile.cfm?box=#url.box#&Observationid=#observation.ObservationId#&ActionCode=#ActionCode#"/>		
			</td>
			</tr>  
			
			<tr><td colspan="6" bgcolor="DADADA"></td></tr> 		
		
	    </table>
	      
	</cfoutput>

</cfif>