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

<cfparam name="children" default="">
<cfparam name="whslevel" default="0">

<cfoutput>

	<TR class="labelmedium2 navigation_row clsWarehouseRow line fixlengthlist" style="<cfif operational eq "0">color:f4f4f4</cfif>">
		<TD style="display:none;">#City#</td>
		<TD style="padding-left:10px"><cfif operational eq "0"><font color="808080"><i></cfif><cfloop index="itm" from="1" to="#whslevel#">*&nbsp;*&nbsp;&nbsp;</cfloop>#WarehouseName#</TD>	
		<TD class="navigation_action" onclick="edit('#warehouse#')" style="padding-left:10px;padding-right:6px">				    		
			<cf_img icon="open">		   
		</TD>	
		<TD class="ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#Warehouse#</TD>	
		<TD class="ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#classDescription#</TD>
		<TD align="right" style="padding-right:30px"><cfif operational eq "0"><font color="808080"><i></cfif>#locations#</td>
		<TD align="center" style="padding-right:20px">#children#</TD>										
		<TD class="ccontent"><cfif operational eq "0"><font color="808080"><i></cfif>#OrgUnitName#</TD>
		<TD><cfif operational eq "0"><font color="808080"><i></cfif>#DateFormat(Created, CLIENT.DateFormatShow)#</td>
	</tr>
	
	<cfset whs = warehouse>
				
	<cfif children gte "1">
		
		<cfset whslevel = whslevel + 1>	
	
		<cfquery name="ChildList#whslevel#" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *, 
			  (SELECT Description FROM Ref_WarehouseClass WHERE Code = W.WarehouseClass) as ClassDescription,
      		  (SELECT count(*) FROM WarehouseLocation WHERE Warehouse = W.Warehouse AND Operational = 1) as Locations,
			  (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND City = W.City) as Cities,
	          (SELECT   TOP 1 OrgUnitName
			   FROM     Organization.dbo.Organization
			   WHERE    MissionOrgUnitId = W.MissionOrgUnitId
			   ORDER BY OrgUnit DESC) as OrgUnitName,
		     (SELECT count(*) FROM Warehouse WHERE Mission = W.Mission AND SupplyWarehouse = W.Warehouse) as Children
	 			
			FROM   Warehouse W
			WHERE  SupplyWarehouse = '#Whs#' 
			AND    City = '#City#'		 
		</cfquery>
	
		 <cfloop query="ChildList#whslevel#">		
		   							
		   <cfinclude template="RecordListingDetailContent.cfm">			   			
	  	
		</cfloop> 	
		
		<cfset whslevel = whslevel - 1>	
		
	</cfif>
		
</cfoutput>
