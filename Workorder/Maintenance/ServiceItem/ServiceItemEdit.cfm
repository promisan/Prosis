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
<cfparam name="url.loadcolor" default="0">

<cfquery name="Get" 
datasource="AppsWorkorder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ServiceItem
	WHERE  Code = '#URL.ID1#'
</cfquery>
 
<!--- edit form --->

<cfset col = "4">

<CFFORM action="RecordSubmit.cfm?loadcolor=#url.loadcolor#" method="post" name="editform" onsubmit="return false">

<table width="94%" class="formpadding" align="center">

	<cfoutput>
	
	<tr><td height="5"></td></tr>
	
	<TR>
	 <TD class="labelmedium2" height="23"><cf_tl id="Code">:</TD>  
	    <td>
		
		<table>
		<tr>
	 	<cfif url.id1 eq "">
		    <TD colspan="#col#">
			<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regularxl">
		<cfelse>
		    <TD colspan="#col#" class="labellarge">
			#get.Code#
			<cfinput type="hidden" name="Code" value="#get.Code#">
		</cfif>
		<cfinput type="hidden" name="CodeOld" value="#get.Code#">
		
		<td style="padding-left:25px" class="labelmedium2"><cf_tl id="Operational">:</TD>	
		<td style="padding-left:10px" colspan="#col#" class="labelmedium">
	        <table cellspacing="0" cellpadding="0">
			<tr>
			<td><input type="radio" class="radiol" name="Operational" id="Operational" value="0" <cfif Get.Operational neq "1" and get.Operational neq "">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
			<td style="padding-left:6px"><input type="radio" class="radiol" name="Operational" id="Operational" value="1" <cfif Get.Operational eq "1" or get.Operational eq "">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
			</tr>
			</table>
	  	</TD>
	
		</table></td>
	</tr>
			
		
	 </TD>
	</TR>
		
    <TR valign="top">
    <TD class="labelmedium2"><cf_tl id="Description"> *:&nbsp;</TD>
    <TD colspan="#col#">
		<cf_LanguageInput
			TableCode		= "ServiceItem"
			Mode            = "Edit"
			Name            = "Description"
			Id              = "Description"
			Type            = "Input"
			Value			= "#get.Description#"
			Key1Value       = "#get.Code#"
			Required        = "Yes"
			Message         = "Please enter a description"
			MaxLength       = "50"
			Size            = "50"
			Class           = "regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2"><cf_tl id="Mode">:</TD>
    <TD colspan="#col#" class="labelmedium2">
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td style="height:24"><input type="radio" class="radiol" name="ServiceMode" id="ServiceMode" value="Service" <cfif Get.ServiceMode eq "Service">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Continuing service (car maintenance, phone service, IT hosting, cleaning service) </td>
		</tr>
		<tr>
		<td><input type="radio" class="radiol" name="ServiceMode" id="ServiceMode" value="WorkOrder" <cfif Get.ServiceMode neq "Service">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Workorder (repair, medical treatment / production / sale order)</td>
		</tr>
		</table>
  	</TD>
	</TR>	
	
	<cfquery name="qServiceClass" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    *
		FROM 	  ServiceItemClass
		WHERE	  Operational = 1
		ORDER BY  ListingOrder
	</cfquery>	
	
			
    <TR>
    <TD class="labelmedium2"><cf_tl id="Class">:</TD>
    <TD colspan="#col#">
	
	<select name="ServiceClass" id="ServiceClass" class="regularxxl">
		
		<cfloop query="qServiceClass">
		<option value="#Code#" <cfif get.serviceclass eq code>selected</cfif>>#Code# - #Description#</option>
		</cfloop>
		
	</select>
	
  	</TD>
	</TR>		    
	
	<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ServiceItemDomain		
	</cfquery>	
		
    <TR>
    <TD class="labelmedium2">Service Item (Domain):&nbsp;</TD>
    <TD colspan="#col#">
	
	<select name="ServiceDomain" id="ServiceDomain" class="regularxxl">		
		<cfloop query="Domain">
		<option value="#Code#" <cfif get.servicedomain eq code>selected</cfif>>#Code# - #Description#</option>
		</cfloop>		
	</select>
	
  	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2" width="30%">Presentation Order *:&nbsp;</TD>
    <TD colspan="#col#">
	
	    <table><tr><td>
  	  	<cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a numeric listing order" 
			   validate="integer" 
			   required="Yes" 
			   size="2" 
			   maxlength="3" 
			   class="regularxxl" 
			   style="text-align:center">	
			   
		</td>
		
		<td class="labelmedium" style="padding-left:10px">Color:</td>
		<td style="padding-left:10px">
		
			<cf_color name="serviceColor" 
					value="#get.ServiceColor#"
					style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 16; width: 16; ime-mode: disabled; layout-flow: vertical-ideographic;"
					mode="limited">
		</td>
		
		</tr>
		</table>	   			
    </TD>
	</TR>	

    <TR>
    <TD class="labelmedium2" style="cursor:pointer" title="Please enter a relative directory WorkOrder/Application/WorkOrder/Create/">Custom Form for new workorder:</TD>
    <TD colspan="#col#">
		<cfinput type="Text" name="CustomForm" value="#get.customform#" 
		       message="Please enter a relative directory" class="regularxl" required="No" size="50" maxlength="80">		
			   
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2" style="cursor:pointer" title="Please enter a relative directory WorkOrder/Application/WorkOrder/Custom/">Custom Form for billing summary:</TD>
    <TD colspan="#col#" title="Use this template to collect information to be posted into TransactionHeaderTopic.Topic:Billing">
		<cfinput type="Text" name="CustomFormBilling" value="#get.customformBilling#" 
		       message="Please enter a relative directory" class="regularxl" required="No" size="50" maxlength="80">		
			   
	</TD>
	</TR>
	
	<tr><td style="height:40px" class="labellarge">Workorder line settings</td></tr>
	
	<TR>
    <TD class="labelmedium2" style="padding-left:10px;padding-right:3px">Set responsible <b>Person</b>:&nbsp;</TD>
    <TD colspan="#col#" class="labelmedium">
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td><input type="radio" class="radiol" name="EnablePerson" id="EnablePerson" value="0" <cfif Get.EnablePerson neq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
		<td style="padding-left:6px"><input class="radiol" type="radio" name="EnablePerson" id="EnablePerson" value="1" <cfif Get.EnablePerson eq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
		</tr>
		</table>
  	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium2" style="padding-left:10px;padding-right:3px">Set <b>Customer unit</b>:</TD>
    <TD class="labelmedium2" colspan="#col#">
	     <table cellspacing="0" cellpadding="0">
		<tr>
		<td><input type="radio" class="radiol" name="EnableOrgUnit" id="EnableOrgUnit" value="0" <cfif Get.EnableOrgUnit neq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
		<td style="padding-left:6px"><input class="radiol" type="radio" name="EnableOrgUnit" id="EnableOrgUnit" value="1" <cfif Get.EnableOrgUnit eq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
		</tr>
		</table>
  	</TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium2" style="padding-left:10px;padding-right:3px">Set <b>Implementing unit</b>:</TD>
    <TD class="labelmedium2" colspan="#col#">
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td><input type="radio" class="radiol" name="EnableOrgUnitWorkOrder" id="EnableOrgUnitWorkOrder" value="0" <cfif Get.EnableOrgUnitWorkOrder neq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
		<td style="padding-left:6px"><input class="radiol" type="radio" name="EnableOrgUnitWorkOrder" id="EnableOrgUnitWorkOrder" value="1" <cfif Get.EnableOrgUnitWorkOrder eq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>
		</tr>
		</table>	
  	</TD>
	</TR>

	<!--- <tr><td>Service Line Custom Fields</td>
	    <td colspan="#col#">
		   <cfinclude template="ServiceItemTopic.cfm">									
		</td>
	</tr> --->
	
<!--- 	<TR>
    <TD>Show in selfservice module:&nbsp;</TD>
    <TD colspan="#col#">
	  <input type="radio" name="SelfService" value="0" <cfif Get.SelfService neq "1">checked</cfif>>No
		<input type="radio" name="SelfService" value="1" <cfif Get.SelfService eq "1">checked</cfif>>Yes	
  	</TD>
	</TR>	 --->
	
	<cfif Get.ServiceMode eq "Service">
	  <cfset cl = "regular">
	<cfelse>
      <cfset cl = "hide">  
	</cfif>
				
	<tr><td height="4"></td></tr>
	<tr id="items"class="#cl#">
	  <td valign="top" style="padding-top:6px" class="labelmedium">Scope the associated equipment items:</td>
	  <td class="labelmedium">
	  
	  <table class="formpadding">
	  
	
	 <cfquery name="Cls" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ItemClass		
		</cfquery>
		
		<cfloop query="Cls">
			
			 <cfquery name="getClass" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM   ServiceItemMaterials
				WHERE  ServiceItem    = '#get.Code#'		
				AND    MaterialsClass = '#code#'
			</cfquery>
			
			<tr>
			    <td></td>
		     	<td class="labelmedium">#Code#</td>	
			  		
				<td style="padding-left:10px"> 
				
				 <cfquery name="getCategory" 
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   Ref_Category						
					</cfquery>
					
					<select name="#code#_Category" id="#code#_Category" class="regularxl">
				        <option value="">[<cf_tl id="undefined">]</option>
						<cfloop query="getCategory">
						<option value="#Category#" <cfif getClass.MaterialsCategory eq category>selected</cfif>>#Category# #Description#</option>
						</cfloop>		
					</select>
						   	
				</td>
					
			</tr>
		
	    </cfloop>	  
	  
	  </table>
	 </td>
	</tr>
		
	 
	<TR>
    <TD class="labelmedium">Set funding on service unit level (UN-only):</TD>
    <TD colspan="#col#" class="labelmedium">
	    <table cellspacing="0" cellpadding="0">
		<tr>
		<td><input type="radio" class="radiol" name="FundingMode" id="FundingMode" value="0" <cfif Get.FundingMode neq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">No</td>
		<td style="padding-left:6px"><input class="radiol" type="radio" name="FundingMode" id="FundingMode" value="1" <cfif Get.FundingMode eq "1">checked</cfif>></td><td class="labelmedium" style="padding-left:4px">Yes</td>	
		</tr>
		</table>
  	</TD>
	</TR>						
	
	<TR>
    <TD class="labelmedium" valign="top" style="padding-top:3px">Memo:</TD>
    <TD colspan="#col#" style="padding-top:4px">
	    <textarea name="Memo" class="regular" style="font-size:13px;padding:3px;width:90%;height:40">#get.Memo#</textarea>			
  	</TD>
	</TR>	
	
	    	
	<tr><td height="5"></td></tr>	
		
	<tr><td height="1" colspan="#col#" class="line"></td></tr>
	<tr>
		<td colspan="#col#" align="center" height="36">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">	
		<cfif url.id1 neq ""><input class="button10g" type="button" name="Delete" id="Delete" value=" Delete " onclick="return ask()"></cfif>
		<input class="button10g" type="button" name="Update" id="Update" value=" Save " onclick="validate()">	
		</td>
	</tr>
	
    </cfoutput>
    	
</table>

</cfform>

<cfif url.loadcolor eq 1>
	<cfset AjaxOnLoad("colorInitialize")>
<cfelse>
	<script>
		colorInitialize();
	</script> 
</cfif>
