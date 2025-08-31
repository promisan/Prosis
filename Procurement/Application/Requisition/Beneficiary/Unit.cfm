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

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	
		<tr><td height="2"></td></tr>
					
		<cfif access eq "edit">	
		
			<cfset link = "#SESSION.root#/procurement/application/requisition/beneficiary/UnitList.cfm?access=#access#||box=bunit||requisitionno=#url.RequisitionNo#">
			
			<tr><td height="20" colspan="6" align="left" class="labelit" style="padding-left:3px">
			
			   <cf_tl id="Record a Beneficiary" var="1">
			
			   <cf_selectlookup
			    class         = "Tree"
			    box           = "bunit"
				title         = "#lt_text#"
				button        = "Yes"
				Icon          = "Contract.gif"
				link          = "#link#"			
				dbtable       = "Purchase.dbo.RequisitionLineOrgUnit"
				des1          = "OrgUnit"
				filter1       = "Mission"
				filter1value  = "#Line.Mission#"
				filter2       = "MandateNo"
				filter2value  = "#Mandate.MandateNo#">
						
			</td>
			</tr> 
			
		</cfif>			
		
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2">		
			<cfdiv bind="url:#SESSION.root#/procurement/application/requisition/beneficiary/UnitList.cfm?box=bunit&requisitionno=#url.RequisitionNo#&access=#access#" 
			  id="bunit"/>		
		</td>
		</tr>  
			
	
    </table>
      
</cfoutput>