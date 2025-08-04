<!--
    Copyright © 2025 Promisan

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

<cfquery name="Period" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM   Ref_MissionPeriod
	  WHERE  Mission = '#URL.Mission#'
	  AND    Period  = '#URL.Period#' 
  </cfquery>
 
  <cfif Period.MandateNo eq "">
  	
    <cf_message message="Please define mandate" return="no">
	<cfabort>
  
  </cfif>

<cfquery name="Parameter" 
  datasource="AppsProgram" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Parameter
  </cfquery>
  
<cfparam name="CLIENT.ProgramMode" default="Maintain">  

<cfset Criteria = ''>
     
<table width="100%">
	
     <tr>
        <td style="padding-left:4px"> 
	
		<cfinvoke component="Service.AccessGlobal"  
		      method="global" 
			  role="AdminProgram" 
			  returnvariable="GlobalAccess">
			
		<cfinvoke component="Service.Access"
			   Method="Organization"
			   Mission="#URL.Mission#"
			   Role="ProgramOfficer', 'ProgramManager', 'ProgramAuditor"
			   ReturnVariable="MissionAccess">	
						   			
		<cfset CLIENT.ShowReports = "YES">
		
		<CFIF GlobalAccess neq "NONE" 
		     OR MissionAccess eq "READ" OR MissionAccess eq "EDIT" or MissionAccess eq "ALL">
			 
			 	<cf_UItree name="idtree" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#Period.MandateNo#','ProgramListing.cfm','PRA','Operational Structure','#url.mission#','#Period.MandateNo#','#url.period#','Full')">  		 
			    </cf_UITree>		
	
	    <cfelse>
		
				<cf_UItree name="idtree" bold="No" format="html" required="No">
				     <cf_UItreeitem
					  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#url.mission#','#Period.MandateNo#','ProgramListing.cfm','PRA','Operational Structure','#url.mission#','#Period.MandateNo#','#url.period#','role')">  		 
			   </cf_UITree>	
	     
		</cfif>
		
	 </td>
	 </tr>
      	  
</table>

