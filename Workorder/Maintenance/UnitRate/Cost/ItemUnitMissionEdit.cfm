<cf_screentop height="100%" label="Unit Rate: <b>#url.id3#</b>" 
 title="Unit Rate #url.id3#" scroll="Yes" layout="webapp" banner="gray" jquery="yes" html="No">

<cf_calendarscript>
<cf_dialogOrganization>
<cfajaximport tags="cfform">

<cf_tl id="All fields are mandatory" var="lblChargeError">
<cf_tl id="Amount field should be numeric" var="lblChargeAmountError">


<cfoutput>
<script language="JavaScript">

	function ask() {
		if (confirm("Do you want to remove this record ?")) {	
		return true 	
		}	
		return false	
	}
	
	function selectOrgUnitOwner(costId,frm,orgunit,orgunitcode,mission2,orgunitname,orgunitclass,mission,mandate) {
		selectorgmis(frm,orgunit,orgunitcode,mission2,orgunitname,orgunitclass,mission,mandate); 		
	}
	
	function purgeCostOwner(costId, orgunit) {
		ptoken.navigate('OrgUnitOwnerPurge.cfm?orgUnit='+orgunit+'&costId='+costId,'divOrgUnitOwnerList');
	}
	
	function applyunit(org) {
		ptoken.navigate('OrgUnitOwnerList.cfm?orgUnit='+org+'&costId=#url.id1#','divOrgUnitOwnerList');
	}

	function addCharge(mis, costid, unit, dest, amount) {
		var vUnit = $.trim(unit);
		var vDest = $.trim(dest);
		var vAmount = $.trim(amount);
		if (vUnit != '' && vDest != '' && vAmount != '') {
			if ($.isNumeric(vAmount)) {
				ptoken.navigate('ItemUnitMissionChargeSubmit.cfm?mission='+mis+'&costid='+costid+'&unit='+vUnit+'&destination='+vDest+'&amount='+vAmount, 'divCharge');
			} else {
				Prosis.alert('#lblChargeAmountError#');	
			}
		} else {
			Prosis.alert('#lblChargeError#');
		}
	}

	function purgeCharge(mis, costid, unit, dest) {
		ptoken.navigate('ItemUnitMissionChargePurge.cfm?mission='+mis+'&costid='+costid+'&unit='+unit+'&destination='+dest, 'divCharge');
	}	

</script>
</cfoutput>
	
	<cfquery name="get" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	ServiceItemUnitMission
		<cfif url.id1 eq "">
		WHERE    1 = 0
		<cfelse>
		WHERE 	costId = '#URL.ID1#'
		</cfif>
	</cfquery>

<table class="hide">
	<tr><td><iframe name="processUnitMission" id="processUnitMission" frameborder="0"></iframe></td></tr>
</table>

<cf_divscroll>
			
<cfform name="webdialog" action="itemUnitMissionSubmit.cfm" method="POST" target="processUnitMission">			

<cfoutput>

<table width="94%" cellspacing="2" cellpadding="1" align="center" class="formpadding">

	<cfinput type="Hidden" name="costId" value="#get.costId#">
	
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
		
		<!---									
		<TR>
			<td height="20">Unit:&nbsp;</td>
			<td>#getUnitMission.unit#</td>
		</TR>
		--->
		
	<cfelse>
	
		<cfinput type="hidden" name="serviceItem"     value="#get.serviceItem#">
		<cfinput type="hidden" name="serviceItemUnit" value="#get.serviceItemUnit#">
			
		<!---		
		<TR>
			<td height="20">Unit:&nbsp;</td>
			<td>#get.serviceItem# - #get.serviceItemUnit#</td>
			
		</TR>
		--->
		
	</cfif>			 						
	 	 
	<TR class="labelmedium">	
		<td width="150">Entity:<font color="FF0000">*</font>&nbsp;</td>
		<td>	
			
		<cfquery name="getLookup" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_parameterMission
				WHERE  Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'WorkOrder')
		</cfquery>
		
		<select name="mission" id="mission" class="regularxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif getLookup.mission eq #get.mission#>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>	
					    	 					 
       </td>	 
	  
	 
		
		<td align="right">
			<table>
			<tr class="labelmedium">
			<td style="padding-right:7px">Operational:</td>
			<td><input type="radio" class="radiol" name="operational" id="operational" value="0" <cfif get.operational eq "0">checked</cfif>></td><td style="padding-left:3px">No</td>
			<td style="padding-left:10px"><input type="radio" class="radiol" name="operational" id="operational" value="1" <cfif get.operational eq "1" or url.id1 eq "">checked</cfif>></td><td style="padding-left:3px">Yes</td>
			</tr>
			</table>
		</td>		
												
	</TR>	 	 
	 	 	 	
	 	 
	<TR class="labelmedium">
		<td>Effective:<font color="FF0000">*</font>&nbsp;</td>
		<td colspan="2" style="padding-left:0px">	
		
		<table><tr><td style="padding-left:0px">
		    
		<cf_intelliCalendarDate9
			FieldName="dateEffective" 
			Default="#dateformat(get.dateEffective, CLIENT.DateFormatShow)#"
			class="regularxl"
			AllowBlank="false">		
			
			</td>
			
			<td style="padding-left:3px;padding-right:3px">-</td>
			
			<td>
		    <cf_intelliCalendarDate9
				FieldName="dateExpiration" 
				Default="#dateformat(get.dateExpiration, CLIENT.DateFormatShow)#"
				class="regularxl"
				AllowBlank="false">						 						 					 
	       </td>
			
			</tr>
			</table>			 						 					 
       </td>
	</TR>	 	 	
		
		
	<!--- Field: Frequency, Billing Mode inherited --->
		<tr class="labelmedium">
			<td><cf_tl id="Frequency">:<font color="FF0000">*</font>&nbsp;</td>
			<td>
			
			<cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_Frequency
			</cfquery>			
			
			<cfif get.Frequency eq "">
			  <cfset freq = getUnitMission.frequency>
			<cfelse>
			  <cfset freq = get.Frequency>  
			</cfif>
				
			<select name="frequency" id="frequency" class="regularxl">
				<cfloop query="getLookup">
				  <option value="#getLookup.code#" <cfif getLookup.code eq freq>selected</cfif>>#getLookup.description#</option>
			  	</cfloop>
			</select>		
			</td>
		</tr>
		<tr class="labelmedium">
			<td>Billing Mode:<font color="FF0000">*</font>&nbsp;</td>
			<td>
			
			<cfif get.BillingMode eq "">
			  <cfset bmde = getUnitMission.BillingMode>
			<cfelse>
			  <cfset bmde = get.BillingMode>  
			</cfif>

			<cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM   Ref_BillingMode
			</cfquery>
				
			<select name="billingMode" id="billingMode" class="regularxl">
				<cfloop query="getLookup">
				  <option value="#getLookup.code#" <cfif getLookup.code eq bmde>selected</cfif>>#getLookup.description#</option>
			  	</cfloop>
			</select>		
			</TD>
	</TR>	
	
	
	
	<tr class="fixlengthlist"><td class="labelmedium" valign="top" style="padding-top:5px"><cf_tl id="Provisioning line">:</td>
	
	    <td>
		
		<table class="formpadding">
						
			<TR class="labelmedium2 fixlengthlist" style="">
				<td style="padding-right:10px;background-color:f1f1f1">Preselect:</td>
				<td style="padding-left:0px"><input type="radio" class="radiol" name="enableSetDefault" id="enableSetDefault" value="0" <cfif get.enableSetDefault eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
				<td style="padding-left:7px"><input type="radio" class="radiol" name="enableSetDefault" id="enableSetDefault" value="1" <cfif get.enableSetDefault eq "1" or url.id1 eq "">checked</cfif>></td>
				<td style="padding-left:4px">Yes</td>
			
				<td style="padding-left:20px;background-color:f1f1f1">Quantity:</td>
				<td style="padding-left:0px"><input type="radio" class="radiol" name="enableEditQuantity" id="enableEditQuantity" value="0" <cfif get.enableEditQuantity eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Default</td>
				<td style="padding-left:7px"><input type="radio" class="radiol" name="enableEditQuantity" id="enableEditQuantity" value="1" <cfif get.enableEditQuantity eq "1" or url.id1 eq "">checked</cfif>></td>
				<td style="padding-left:4px">Edit</td>
			</TR>	
			
			<TR class="labelmedium2 fixlengthlist">
				<td style="padding-right:10px;background-color:f1f1f1">Amend Cost Price:</td>
				<td style="padding-left:0px"><input type="radio" class="radiol" name="enableEditCharged" id="enableEditCharged" value="0" <cfif get.enableEditCharged eq "0">checked</cfif>></td>
				<td style="padding-left:4px">No</td>
				<td style="padding-left:7px"><input type="radio" class="radiol" name="enableEditCharged" id="enableEditCharged" value="1" <cfif get.enableEditCharged eq "1" or url.id1 eq "">checked</cfif>></td>
				<td style="padding-left:4px">Yes</td>
			
				<td style="padding-left:20px;background-color:f1f1f1">Amend Sales price / charge:</td>
				<td style="padding-left:0px"><input type="radio" class="radiol" name="enableEditRate" id="enableEditRate" value="0" <cfif get.enableEditRate eq "0">checked</cfif>></td>
				<td style="padding-left:4px">Default</td>
				<td style="padding-left:7px"><input type="radio" class="radiol" name="enableEditRate" id="enableEditRate" value="1" <cfif get.enableEditRate eq "1" or url.id1 eq "">checked</cfif>></td>
				<td style="padding-left:4px">Edit</td>
			</TR>				
		
		</table>
		</td>
	</tr>
	
	<tr class="labelmedium2">
	<td colspan="2">Materials connector <font size="1">issues the quantity recorded also as stock consumption</font></td>	
	</tr>
	
	<tr class="labelmedium">
	<td align="right" style="padding-right:10px"><cf_tl id="Warehouse">:</td>
	<td>	
		  <cf_securediv bind="url:getWarehouse.cfm?mission={mission}&selected=#get.warehouse#&itemmno=#get.ItemNo#&ItemUoM=#get.ItemUoM#" id="warehouse">	
	
	</td>
	</tr>
		
	<cfif get.Warehouse eq "">
		<cfset cl = "hide">
	<cfelse>
		<cfset cl = "regular">	
	</cfif>	
	
	<tr id="itemline" class="#cl#">
	<td class="labelit" align="right" style="padding-right:10px"><cf_tl id="Item">:</td>
	<td class="labelmedium" colspan="3">
	
		<table>
		<tr>
		<td id="itembox">		
			<cf_securediv bind="url:getWarehouseItem.cfm?warehouse=#get.warehouse#&itemno=#get.ItemNo#&ItemUoM=#get.ItemUoM#">		
		</td>
		
		<td id="itemuom" style="padding-left:4px">		
			<cf_securediv bind="url:getWarehouseItemUoM.cfm?warehouse=#get.warehouse#&itemno=#get.ItemNo#&ItemUoM=#get.ItemUoM#">			
		</td>
		
		</tr>
		
		</table>
		
	</td>
	</tr>
	
	<TR class="labelmedium">
		<td class="labelit" align="right" style="padding-right:10px">Stock deduction :</td>
		<td>
			<table><tr class="labelmedium">
			<td><input type="radio" class="radiol" name="enableUsageEntry" id="enableUsageEntry" value="0" <cfif get.enableUsageEntry eq "0">checked</cfif>></td><td style="padding-left:3px">Same as service quantity</td>
			<td style="padding-left:10px"><input type="radio" class="radiol" name="enableUsageEntry" id="enableUsageEntry" value="1" <cfif get.enableUsageEntry eq "1" or url.id1 eq "">checked</cfif>></td><td style="padding-left:3px">Explicitly set</td>
			</tr>
			</table>	
		</td>
	</TR>	 
		
	<TR>
		<td class="labelmedium"><cf_tl id="Currency">:<font color="FF0000">*</font>&nbsp;</td>
		<td>
		<cfquery name="getLookup" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Currency
			where  Operational = 1
			<!---
			and    Description is not null
			and    rtrim(ltrim(description)) != ''
			--->
		</cfquery>
		
		<cfif get.currency eq "">
		   <cfset curr = APPLICATION.BaseCurrency>
		<cfelse>
		   <cfset curr = get.currency>   
		</cfif>
							
		<select name="currency" id="currency" class="regularxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.currency#" <cfif curr eq getLookup.currency>selected</cfif>>#getLookup.currency#</option>
		  	</cfloop>
		</select>		
		
		</td>		
	</TR> 					
	 	 
	<TR class="labelmedium">
		<td style="padding-top:5px;" width="150">Standard Cost:<font color="FF0000">*</font>&nbsp;</td>
		<td style="padding-top:5px;">
			<cfinput type="Text" 
		         value="#get.standardCost#" 
				 name="standardCost" 
				 message="You must enter a numeric standard cost" 
				 required="Yes" 
				 size="7" 
				 style="text-align:right;padding-right:2px"
				 validate="numeric"
				 maxlength="20" 
				 class="regularxl">
		</td>		
	</TR>

	<tr class="labelmedium">
		<td valign="top" style="padding-top:5px;" title="Internal payroll payment" width="150">Remuneration:</td>
		<td valign="top" style="padding-top:2px;">
			<cf_securediv id="divRemuneration" bind="url:#session.root#/WorkOrder/maintenance/unitRate/Cost/ItemUnitMissionRemunerationListing.cfm?costid=#get.costid#&mission={mission}">
		</td>
	</tr>	 	 	
	 	 
	<TR class="labelmedium2">
		<td>Sale Price:&nbsp;</td>
		<td>
		<table>
		<tr><td>
		<cfinput type="Text" 
	         value="#get.price#" 
			 name="price" 
			 message="You must enter a numeric price" 
			 required="no" 
			 size="7" 
			 style="text-align:right;padding-right:2px"
			 maxlength="20"
			 validate="numeric"
			 class="regularxl">
		</td>
		<td style="padding-left:10px">Tax code:<font color="FF0000">*</font>&nbsp;</td>
		<td>
		<cfquery name="getTax" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_Tax
			
			<!---
			and    Description is not null
			and    rtrim(ltrim(description)) != ''
			--->
		</cfquery>
		
		<cfif get.currency eq "">
		   <cfset cde = "00">
		<cfelse>
		   <cfset cde = get.taxcode>   
		</cfif>
							
		<select name="taxcode" id="taxcode" class="regularxl">
			<cfloop query="getTax">
			  <option value="#TaxCode#" <cfif taxcode eq cde>selected</cfif>>#description#</option>
		  	</cfloop>
		</select>	
		
		</td></tr></table>	
		
		</td>		
	</TR> 					
	
	
	
	<tr class="labelmedium" style="height:25px">
		<td><cf_tl id="Cost Owner">:</td>
		<td colspan="3">
			<cf_securediv id="divCostOwner" bind="url:setOrgUnitOwner.cfm?mission={mission}&costId=#url.id1#">
		</td>
	</tr>	

	<tr class="labelmedium" style="height:1px">
		<td></td>
		<td colspan="3">
			<cf_securediv id="divOrgUnitOwnerList" bind="url:OrgUnitOwnerList.cfm?orgUnit=&costId=#url.id1#">
		</td>
	</tr>

	<cfif url.id1 neq "">
		<tr class="labelmedium">
			<td valign="top" style="padding-top:5px;"><cf_tl id="Charge">:</td>
			<td colspan="3" valign="top">
				<cf_securediv id="divCharge" bind="url:ItemUnitMissionCharge.cfm?costId=#url.id1#&mission={mission}">
			</td>
		</tr>
	</cfif>	 
	   
   <tr><td height="2"></td></tr>
   <tr><td height="1" colspan="4" class="line"></td></tr>
	<tr><td colspan="3" align="center" height="35">
	
	<cfif url.id1 eq "">
		<input class="button10g" type="submit" name="Save" id="Save" value=" Save ">	
	<cfelse>
		<input class="button10g" type="submit" name="Delete"    id="Delete"    value=" Delete " onclick="return ask()">	
		<input class="button10g" type="submit" name="Update"    id="Update"    value=" Update ">
		<input class="button10g" type="submit" name="SaveAsNew" id="SaveAsNew" value=" Save As New ">
	</cfif>		
	
	</td></tr>

</TABLE>

</cfoutput>

</cfform>

</cf_divscroll>