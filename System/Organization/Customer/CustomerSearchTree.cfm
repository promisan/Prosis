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
<cfoutput>

<cfquery name="Param" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT  *
      FROM    Ref_ParameterMission
   	  WHERE   Mission = '#URL.Mission#' 	 
</cfquery>

<cfquery name="Mandate" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT    *
      FROM     Ref_Mandate
   	  WHERE    Mission = '#Param.TreeCustomer#' 
	  ORDER BY DateEffective DESC
</cfquery>

<cf_divscroll>
<table width="100%" height="100%" class="formpadding"> 			
	<tr><td colspan="2" id="findme" valign="top"> 			
		<cf_UItree name="tree#Mandate.Mandateno#" required="No">		
		     <cf_UItreeitem 
			  bind="cfc:service.Tree.OrganizationTree.getNodesV2({cftreeitempath},{cftreeitemvalue},'#Param.TreeCustomer#','#Mandate.Mandateno#','CustomerList.cfm','CUS','#Param.TreeCustomer#','#Param.TreeCustomer#','#Mandate.Mandateno#','#url.dsn#','','0','systemfunctionid!#url.systemfunctionid#')">  		 			  
	    </cf_UItree>		
	</td></tr>
</table>
</cf_divscroll>

</cfoutput>

<script>
 document.getElementById('boxlistcustomer').className = "regular"
</script>
