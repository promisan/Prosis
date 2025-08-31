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
<cfquery name="get" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	SELECT  *
	FROM    RequestHeader H
	WHERE   RequestHeaderId = '#object.ObjectkeyValue4#'
</cfquery>

<cfquery name="Program" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	SELECT  *
	FROM    Program
	WHERE   ProgramCode = '#get.ProgramCode#'
</cfquery>

<cfquery name="Lines" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">	
	SELECT   DISTINCT ShipToWarehouse, 
	         W.WarehouseName,
			 W.City, 
			 H.Reference,
			 H.Created, 
			 H.ActionStatus,
			 H.OfficerFirstName, 
			 H.OfficerLastName, 
			 ItemNo, UoM, RequestedQuantity
	FROM     RequestHeader H, Request R, Warehouse W
	WHERE    H.Mission     = R.Mission
	AND      H.Reference   = R.Reference
	AND      R.ShipToWarehouse = W.Warehouse
	AND      H.ProgramCode = '#get.ProgramCode#'
	AND      R.Status != '9'
	ORDER BY ItemNo, UoM
</cfquery>

<table width="97%" cellspacing="0" cellpadding="0" align="center">

<tr><td height="8"></td></tr>

<tr><td colspan="6" class="verdana" style="height:40">
<cfoutput>
<font face="Verdana" size="3">Recapitulation of requesta for Project: <b>#Program.ProgramName#</b></td>
</cfoutput>
</tr>

<cfset url.programcode = get.ProgramCode>
<cfset url.mode = "view">

<tr><td colspan="6">
	<table width="93%" align="center">
	  <tr><td>
		<cfdiv bind="url:#SESSION.root#/ProgramREM/Application/Program/Create/ProjectEntryFinancial.cfm?programcode=#get.programcode#&mode=view" id="content">
		</td></tr>
	</table>	
</td>
</tr>

<tr><td colspan="6">

<table width="90%" align="center">
	
	<cfoutput query="lines" group="ItemNo">
	
		<cfoutput group="UoM">
	
	    <tr><td colspan="6" height="30">
		
			<cfquery name="Item" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">	
				SELECT  *
				FROM    Item I , ItemUoM U
				WHERE   I.ItemNo = '#itemno#' and UoM = '#uom#'
				AND     I.ItemNo = U.ItemNo	
			</cfquery>
		
			<font size="3">#Item.Itemdescription# (#Item.UoMdescription#)</font>
			
		</td></tr>
		
		<tr><td colspan="7" class="linedotted"></td></tr>
		
			<cfset cnt = 0>
		
			<cfoutput>
			
			<tr>
				<td width="90">#dateformat(created,CLIENT.DateFormatShow)#</td>
				<td>#officerfirstname# #officerlastname#</td>
				<td>#WarehouseName#</td>
				<td>#City#</td>
				<td>#Reference#</td>
				<td><cfif ActionStatus eq "3">Tasked</cfif></td>				
				<td align="right">#numberformat(RequestedQuantity,"__,__")#</td>
						
			</tr>	
			
			<cfset cnt = cnt+RequestedQuantity>
			
			</cfoutput>
			
			<tr>
				<td colspan="6"></td>
				<td align="right" style="border-top:1px solid gray"><b>#numberformat(cnt,"__,__")#</b></td>
			</tr>
		
		</cfoutput>
		
	</cfoutput>

</table>

</td></tr>	

</table>