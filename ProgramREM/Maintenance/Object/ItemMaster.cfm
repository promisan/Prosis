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

<!--- Item master --->

<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="Check"
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM ItemMasterObject
		WHERE ItemMaster = '#url.itemmaster#'
		AND   ObjectCode = '#url.code#' 	
	</cfquery>
	
</cfif>

<cfif url.action eq "insert">
	
	<cfquery name="Check"
	datasource="appsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM  ItemMasterObject
		WHERE ItemMaster = '#url.itemmaster#'
		AND   ObjectCode = '#url.code#' 	
	</cfquery>
		
		<cfif check.recordcount eq "0">
		
			<cfquery name="Add"
			datasource="appsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    INSERT INTO ItemMasterObject
				(ItemMaster,ObjectCode)
				VALUES
				('#url.itemmaster#','#url.code#')
			</cfquery>
		
		</cfif>

</cfif>

<cfquery name="Item"
datasource="appsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *, 
	       (SELECT count(*) FROM RequisitionLine R, RequisitionLineFunding RF
		                    WHERE R.ItemMaster = I.Code
							AND R.RequisitionNo = RF.RequisitionNo
							AND RF.ObjectCode = '#url.code#') as UsedProcurement,
		   (SELECT count(*) FROM  Program.dbo.ProgramAllotmentRequest 
		                    WHERE ItemMaster = I.Code
							AND   ObjectCode = '#url.code#') as UsedProgram
	FROM   ItemMaster I, 
	       ItemMasterObject O
	WHERE  I.Code = O.ItemMaster
	AND    O.ObjectCode = '#url.code#' 	
	ORDER BY EntryClass
</cfquery>

<table cellspacing="0" cellpadding="0" width="100%" class="formpadding">
<tr><td>

<table width="94%" style="border:0px dotted silver" cellspacing="0" cellpadding="0" class="formpadding">

<cfoutput>
<tr>

<td colspan="8" style="border: 1px sold Silver;">
	
	<table><tr>
	<td height="21">&nbsp;</td>
	<td class="labelit">
	<cfif item.recordcount eq "0">
	There are no items found to be shown in this view.
	</cfif>
	</td>
	<td style="padding-left:4px" class="labelit"><a href="javascript:itemadd('#url.code#')"><font color="gray">Add a new Item</font></a></td>
	<td>&nbsp;|&nbsp;</td>
	<td class="labelit">
	
	   <cfset link = "#SESSION.root#/ProgramREM/Maintenance/Object/ItemMaster.cfm?code=#URL.code#">
	   
	   <cf_selectlookup
				    class    = "ItemMaster"
				    box      = "#URL.code#detail"
					title    = "Associate an Item"				
					link     = "#link#"								
					dbtable  = "Procurement.dbo.ItemMasterObject"
					des1     = "ItemMaster">
	</td>
	</tr>
	</table>
	
</td>
</tr>

</cfoutput>

<cfoutput query="Item" group="EntryClass">
<tr><td height="20" colspan="8" class="labelit linedotted" style="padding-left:4px">#EntryClass#</td></tr>
<cfoutput group="Code">

<tr class="labelit">
    
	<TD align="center" style="padding-left:8px;padding-top:2px">	
	   <cf_img icon="edit" onClick="itemedit('#code#','#url.Code#','#mission#')">	   			  
	</TD>	
	<td style="padding-left:4px;padding-top:2px">
	 <cf_space spaces="8" padding="0">
	 <cfif UsedProcurement eq "0" and UsedProgram eq "0">	 
	 	 <cf_img icon="delete" onClick="itemdelete('#code#','#url.Code#','#mission#')">	  
	 </cfif>		  
	</td>	
	<td><cf_space spaces="20" padding="0" label="#Code#"></td>
	<td>
	<cfif mission eq "">
		<cf_space spaces="20" padding="0" label="Global">
	<cfelse>
		<cf_space spaces="20" padding="0" label="#Mission#">
	</cfif>
	</td>	
	<td><cf_space spaces="120" label="#description#"></td>
	<td><cfif isServiceItem eq "1">Service</cfif></td>
	<td><cfif Operational eq "0"><font color="FF0000">&nbsp;disabled</font></cfif></td>
	<td width="100%"></td>	
	
</tr>
</cfoutput>

</cfoutput>

</table>

</td></tr></table>