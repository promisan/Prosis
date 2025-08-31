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
<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT *
	   FROM   RequisitionLine 
	   WHERE  RequisitionNo = '#url.id#'
</cfquery>
		
<cfoutput>

	<table width="100%" align="center" style="padding:2px;border:0px dotted silver">
			
		<cfset link = "#SESSION.root#/Procurement/Application/Requisition/Position/PositionFunding.cfm?access=#url.access#&reqid=#url.id#">
		
		<!--- allow buyer to modify this information to select a different position --->
		
		<!---				
		<cfif url.access eq "Edit" or (Line.ActionStatus eq "2i" or Line.ActionStatus eq "2k") or getAdministrator(line.mission) eq "1">
		--->
		
		<cfif url.access eq "Edit" or Line.ActionStatus eq "2k" or getAdministrator(line.mission) eq "1">
			
			<tr><td height="1"></td></tr>	
			<tr>
				<td height="20" colspan="6" align="left" class="labelmedium" style="padding-left:2px">
				
				<cf_selectlookup
				    class        = "Position"
				    box          = "pos#url.id#"
					title        = "Select workforce position to be funded"
					link         = "#link#"			
					dbtable      = "Employee.dbo.PositionParentFunding"
					des1         = "PositionParentId"
					icon         = "Search.png"
					iconheight   = "22"
					iconwidth    = "22"
					close        = "Yes"
					filter1      = "requisitionno"
					filter1value = "#url.id#"
					filter2      = "orgunit"
					filter2value = "#line.orgunitimplement#">
						
				</td>
			</tr> 
			
			<tr><td height="1"></td></tr>
			<tr><td colspan="6" class="line"></td></tr>
			<tr><td height="1"></td></tr>
		
		</cfif>
					
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2" align="center" id="pos#url.id#">
			<cfset url.reqid = url.id>
			<cfinclude template="PositionFunding.cfm">				
		</td>
		</tr>  
					
    </table>
      
</cfoutput>
