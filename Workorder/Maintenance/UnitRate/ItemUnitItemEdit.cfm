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
<cf_screentop height="100%" label="Item for Unit <b>#url.id3#</b>"    
    title="Unit #url.id3#" html="No" scroll="No" jquery="Yes" layout="webapp" banner="gray">


<script language="JavaScript">
	
	function ask() {
		if (confirm("Do you want to remove this item ?")) {	
		return true 	
		}	
		return false	
	}	

</script>

	<cfquery name="get" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	I.*,
				(SELECT ItemDescription FROM Materials.dbo.Item WHERE ItemNo = I.ItemNo) as ItemDescription
		FROM 	ServiceItemUnitItem I
		<cfif url.id1 eq "">
		WHERE 	1 = 0
		<cfelse>
		WHERE 	I.ItemNo = '#URL.ID1#'
		AND		I.ServiceItem = '#URL.ID2#'
		AND		I.Unit = '#URL.ID3#'
		</cfif>
	</cfquery>
			
<cfoutput>

<cf_divscroll>

	<cfform name="fDetailUnitItem" action="ItemUnitItemSubmit.cfm" method="POST" target="processUnitItem">		
	
	<table width="94%" align="center">
	
	<tr class="hide"><td><iframe name="processUnitItem" id="processUnitItem" frameborder="0"></iframe></td></tr>
	
	<tr><td height="5"></td></tr>
	
		<tr><td height="5"></td></tr>
		
		<cfif url.id1 eq "">
		
			<cfquery name="getUnitMission" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   ServiceItemUnit
				WHERE  ServiceItem = '#url.id2#'
				AND    Unit        = '#url.id3#'		
			</cfquery>	
			
			<cfinput type="hidden" name="serviceItem"     value="#getUnitMission.serviceItem#">
			<cfinput type="hidden" name="serviceItemUnit" value="#getUnitMission.unit#">
					
		<cfelse>
		
			<cfinput type="hidden" name="serviceItem"     value="#get.serviceItem#">
			<cfinput type="hidden" name="serviceItemUnit" value="#get.unit#">
				
			<!---		
			<TR>
				<td height="20">Unit:&nbsp;</td>
				<td>#get.serviceItem# - #get.serviceItemUnit#</td>
				
			</TR>
			--->
			
		</cfif>			 						
		 	 
		<TR>	
			<td class="labelmedium2" width="15%"><cf_tl id="Item">:<font color="FF0000">*</font>&nbsp;</td>
			<td  class="labelmedium2">	
			
			<cfif url.id1 eq "">
			
				<cfquery name="getLookup" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT 	*,
								(ItemNo + ' - ' + ItemDescription) as DisplayDescription
						FROM 	Item
						WHERE	Category IN 
								(
									SELECT	MaterialsCategory
									FROM 	WorkOrder.dbo.ServiceItemMaterials
									WHERE	ServiceItem = '#URL.ID2#'
									AND		MaterialsClass = 'Asset'
								)
						ORDER BY ItemDescription ASC
				</cfquery>
				
				<cfselect 	name="ItemNo" 
							id="ItemNo" 
							class="regularxl" 
							required="Yes" 
							query="getLookup" 
							message="Please, select a valid item." 
							value="ItemNo" 
							display="DisplayDescription" 
							selected="#get.itemno#">
				</cfselect>	
				
			<cfelse>
				
				#get.ItemNo# - #get.ItemDescription#
				<input type="Hidden" name="ItemNo" id="ItemNo" value="#get.ItemNo#">
			
			</cfif>
						    	 					 
	       </td>	   
		</TR>	 	 	
		 	
		<TR>
			<td class="labelmedium2"><cf_tl id="Operational"></td>
			<td colspan="3" class="labelmedium2">
				<input type="radio" class="radiol" name="operational" id="operational" value="1" <cfif get.operational eq "1" or url.id1 eq "">checked</cfif>>Yes
				<input type="radio" class="radiol" name="operational" id="operational" value="0" <cfif get.operational eq "0">checked</cfif>>No
			</td>												
		</TR>	 	 
	   
	   <tr><td height="4"></td></tr>
	   <tr><td height="1" colspan="4" class="line"></td></tr>
	   <tr><td colspan="4" align="center" height="35">
		
		<cfif url.id1 eq "">
			<input class="button10g" type="submit" name="Save" id="Save" value=" Save ">	
		<cfelse>
			<input class="button10g" type="submit" name="Delete" id="Delete" value="Delete" onclick="return ask()">	
			<input class="button10g" type="submit" name="Update" id="Update" value="Update">
		</cfif>		
		
		</td></tr>
	
	</TABLE>
	
	</cfform>

</cf_divscroll>

</cfoutput>