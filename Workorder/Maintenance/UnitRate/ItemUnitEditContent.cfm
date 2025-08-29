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
<cfquery name="ServiceItem" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItem
		WHERE  Code = '#URL.ID1#'		
</cfquery>	 	

<cfquery name="Get" 
	datasource="AppsWorkorder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   ServiceItemUnit
		WHERE  serviceItem = '#URL.ID1#'
		<cfif url.id2 eq "">
		AND    1 = 0
		<cfelse>
		AND    unit = '#URL.ID2#'
		</cfif>	
</cfquery>	 	

<!-- <cfform> -->
		
	<table width="94%" class="formpadding" align="center">
					
		 <cfoutput>
		 
		 		 
		 <cfinput type="Hidden" name="serviceItem" value="#URL.ID1#">		 
			
		 <!--- Field: Unit --->
		 
		 <tr><td height="10px"></td></tr>
		 <TR>			 		  			 
			 
			 <!--- Field: UnitDescription --->
			 <TD  class="labelmedium" valign="top" style="padding-top:7px" rowspan="3"><cf_tl id="Name">:</TD>
		     <TD rowspan="3" valign="top" style="min-width:300px;padding-top:4px;padding-right:5px;padding-left:3px">
			 
				<cf_LanguageInput
					TableCode		= "ServiceItemUnit"
					Mode            = "Edit"
					Name            = "UnitDescription"
					Id              = "UnitDescription"
					Type            = "Input"
					Value			= "#get.UnitDescription#"
					Key1Value       = "#get.ServiceItem#"
					Key2Value		= "#get.Unit#"
					Required        = "Yes"
					Message         = "Please enter a Unit Description"
					MaxLength       = "80"
					Size            = "45"
					Class           = "regularxl">
		     </TD>		
			 
			 <TD style="padding-left:3px" class="labelmedium">Unit Id:<font color="FF0000">*</font><cf_space spaces="50"></TD>  
			 <cfif URL.ID2 eq "">
				 <TD>
				  <cfinput type="Text" name="unit" value="#get.unit#" message="Please enter a Unit Id" required="Yes" size="10" maxlength="10" class="regularxl">
				 </TD>
			 <cfelse>
			 	<cfinput type="Hidden" name="unit" value="#URL.ID2#">
				 <TD class="labelmedium">#URL.ID2#</TD>
			 </cfif>	
			 	 			 
		 </TR>
		 
		 <tr class="fixlengthlist">
		 	<TD class="labelmedium" style="cursor:pointer" title="The class set the lowest billing level, units that belong to the same class will be billed together.">Billing Class: <font color="FF0000">*</font>&nbsp;</td>
			<td style="min-width:280px">
			
				<cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT   *
				  FROM     Ref_UnitClass				    
				  ORDER BY Description ASC
				</cfquery>
				
				<select name="unitClass" id="unitClass" class="regularxl" style="width:280px"
					onchange="ptoken.navigate('ItemUnitEdit_UnitParent.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#&unitParent=#get.UnitParent#&unitClass='+this.value,'unitParentDiv')">
					<cfset selectedUnitClass = "#getLookup.code#">
					<cfloop query="getLookup">
					  <option value="#getLookup.code#" <cfif getLookup.code eq get.unitClass>selected <cfset selectedUnitClass = "#getLookup.code#"> </cfif>>#getLookup.description# (#getLookup.Code#)</option>
				  	</cfloop>
				</select>
				
			</td>
		 </tr>
		 
		 <TR  class="fixlengthlist">
			 <!--- need an ajax filter on the selected class here --->
			 <TD class="labelmedium">Present under Unit Id:</TD>
			 <TD class="labelmedium">
				 <cf_securediv id="unitParentDiv"
				   bind="url:ItemUnitEdit_UnitParent.cfm?ID1=#URL.ID1#&ID2=#URL.ID2#&unitParent=#get.UnitParent#&unitClass=#selectedUnitClass#">
		 	</TD>	
			
		</TR>		 
		
		<!--- Field: Label Rate, Listing order --->
		<tr class="fixlengthlist">
			
			<TD class="labelmedium">Listing Order:<font color="FF0000">*</font></TD>
		    <TD>
		  	  	<cfif get.ListingOrder eq "">
		  	  		<cfset vListingOrder = 0>
		  	  	<cfelse>
		  	  		<cfset vListingOrder = get.ListingOrder>
		  	  	</cfif>	
		  	  	<cfinput type="Text" name="ListingOrder" value="#vListingOrder#" message="Please enter a numeric listing order" validate="integer" required="Yes" style="text-align:center;width:30px" maxlength="2" class="regularxl">
		    </TD>
			
			<td class="labelmedium">Apply to Order Domain:</td>
			<td>
						
			<cfquery name="getServiceClass" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_ServiceItemDomainClass
				WHERE ServiceDomain = '#ServiceItem.ServiceDomain#'
			</cfquery>		
			
			<input type="hidden" name="ServiceDomain" value="#ServiceItem.ServiceDomain#">	
				
			<select name="ServiceDomainClass" class="regularxl">
			    <option value="">Any</option>
				<cfloop query="getServiceClass">
				  <option value="#Code#" <cfif Code is get.ServiceDomainClass>selected</cfif>>#description#</option>
			  	</cfloop>
			</select>					
			
			</td>
			
		</TR>						
		
		<!--- Field: Frequency, Billing Mode --->
		<tr class="fixlengthlist">
			<td class="labelmedium">Billing Frequency:</td>
			<td>
			
			<cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_Frequency
				<cfif ServiceItem.ServiceMode eq "Workorder">				
				WHERE Code = 'Once'
				</cfif>
			</cfquery>			
				
			<select name="frequency" id="frequency" class="regularxl">
				<cfloop query="getLookup">
				  <option value="#getLookup.code#" <cfif getLookup.code eq #get.frequency#>selected</cfif>>#getLookup.description#</option>
			  	</cfloop>
			</select>		
			</td>
			
			<td class="labelmedium">Billing data Source:&nbsp;<font color="FF0000">*</font></td>
			<td>
			<cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_BillingMode
					
				</cfquery>
				
				<cfselect 
					name="billingMode" 
					id="billingMode" 
					query="getLookup" 
					value="code" 
					class="regularxl"
					display="description" 
					onchange="labelme(this.value)"
					selected="#get.billingMode#" 
					required="Yes" 
					message="Please, select a billing mode.">
					
				</cfselect>
				
			</TD>
		</TR>		
		
		<cfif get.BillingMode eq "Detail">
			<cfset cl = "regular fixlengthlist">
		<cfelse>
			<cfset cl = "Hide">
		</cfif>
		
		<tr id="labelling" class="#cl#">		
		   <td></td>  
		   <td></td>
		   <td colspan="1" class="labelmedium">Labelling (Usage):</td>
		   <td colspan="2">
		   
		   <table cellspacing="1" cellpadding="1" style="height:27px;border-top:1px solid silver;border-bottom:1px solid silver">
		   
				    <TR>
				    <TD class="labelit">Quantity:</td>
					<td style="padding-left:2px">
				  	  	<cfinput type="Text" style="height:19px" name="LabelQuantity" value="#get.LabelQuantity#" message="Please enter a Label Quantity" required="Yes" size="5" maxlength="20" class="regularh">
					</td>
					
					<td style="padding-left:5px" class="labelit">Currency:</td>
					<td style="padding-left:2px">								
						<cfinput type="Text" style="height:19px" name="LabelCurrency" value="#get.LabelCurrency#" message="Please enter a Label Currency" required="Yes" size="5" maxlength="20" class="regularh">
					</td>									
				
					<td style="padding-left:5px" class="labelit">Rate:</td>
					<td style="padding-left:2px">
						<cfinput type="Text" style="height:19px" name="LabelRate" value="#get.LabelRate#" message="Please enter a Label Rate" required="Yes" size="5" maxlength="20" class="regularh">
					</td>
					
				</TR>		
		   
		   </table>
		   
		   </td>
		
		</tr>							
		
				 
	    <TR class="fixlengthlist">
			<!--- Field: UnitCode --->
			 <TD class="labelmedium">Billing Code:</TD>  
			 <TD>
			 	<cfinput type="Text" name="UnitCode" value="#get.UnitCode#" message="Please enter a Unit Code" required="No" size="10" maxlength="10" class="regularxl">
			 </TD>		
			 
			 <td class="labelmedium">Presentation:<font color="FF0000">*</font></td>
			<td class="labelmedium">
			
			   <cfquery name="getLookup" 
				datasource="AppsWorkorder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_PresentationMode
				</cfquery>
				
			<select name="PresentationMode" id="PresentationMode" class="regularxl">
				<cfloop query="getLookup">
				  <option value="#getLookup.code#" <cfif getLookup.code eq #get.presentationMode#>selected</cfif>>#getLookup.description#</option>
			  	</cfloop>
			</select>			
		    </TD>	 		    
			
			<cf_verifyOperational 
                 module    = "Payroll" 
   				Warning   = "No">
			
		</TR>	 
			 
	    <TR class="fixlengthlist">
			<td class="labelmedium">
			<cf_tl id="Income GL Account">:
			</td>
			<td class="labelmedium" style="padding-right:10px">
			
			<cfquery name="getLookup" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   Ref_Account
					WHERE  Operational  = 1
					AND    AccountClass = 'Result'
			</cfquery>
			
			<select name="GLAccount" id="GLAccount" class="regularxl" style="width:100%">
				<option value=""></option>
				<cfloop query="getLookup">
				  <option value="#getLookup.glAccount#" <cfif getLookup.glAccount eq get.glAccount>selected</cfif>>#getLookup.glAccount# - #getLookup.description#</option>
			  	</cfloop>
			</select>
			</td>
			
			<cfif operational eq "1">

				<TD class="labelmedium"><cf_tl id="Payroll Item">:</TD>
			    <TD class="labelmedium">
					<cfquery name="getLookup" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM Ref_PayrollItem
					</cfquery>
					<select name="PayrollItem" id="PayrollItem" class="regularxl">
						<option value=""></option>
						<cfloop query="getLookup">
						  <option value="#getLookup.PayrollItem#" <cfif getLookup.PayrollItem eq #get.PayrollItem#>selected</cfif>>#getLookup.PayrollItem# - #getLookup.PayrollItemName#</option>
					  	</cfloop>
					</select>		
			    </TD>
			<cfelse>
				<input type="Hidden" name="PayrollItem" id="PayrollItem" value="">
				<td></td>
				<td></td>
			</cfif>	
			
			
		</TR>
		
		<!--- Field: Operational, GLAccount --->
	    <TR class="fixlengthlist">
			<TD class="labelmedium" width="15%"><cf_UIToolTip tooltip="This item is enabled for SLA provisioning definition in a preset billing">Enable for SLA:</cf_UIToolTip></TD>
		    <TD class="labelmedium">
			   <table class="formspacing"><tr>
			    <td>
				<input type="radio" class="radiol" name="baselineMode" id="baselineMode" value="0" <cfif get.baselineMode eq "0">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium">No</td>
				<td style="padding-left:10px">
				<input type="radio" class="radiol" name="baselineMode" id="baselineMode" value="1" <cfif get.baselineMode eq "1" or url.id2 eq "">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>	
				</tr>
			   </table>
		    </TD>	
			<TD class="labelmedium">Operational:</TD>
		    <TD class="labelmedium">
			   <table class="formspacing"><tr><td>
				<input type="radio" class="radiol" name="operational" id="operational" value="0" <cfif get.Operational eq "0">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium">No</td>
				<td style="padding-left:10px"><input type="radio" class="radiol" name="operational" id="operational" value="1" <cfif get.Operational eq "1" or url.id2 eq "">checked</cfif>></td>
				<td style="padding-left:4px" class="labelmedium">Yes</td>	
				</tr>
			   </table>
		    </TD>									
		</tr>	
				
				
		<!--- Field: Unit Specification --->
		<tr class="fixlengthlist">
		    <TD class="labelmedium" valign="top" style="padding-top:4px">Specification Memo:&nbsp;</TD>
		    <TD colspan="3">
			  
				  <cf_LanguageInput
							TableCode       = "ServiceItemUnit" 
							Mode            = "Edit"
							Name            = "UnitSpecification"
							Id			    = "UnitSpecification"
							Type            = "TextArea"
							value			= "#get.UnitSpecification#"
							Key1Value       = "#get.ServiceItem#"
							Key2Value		= "#get.Unit#"
							Required        = "No"
							Message			= "Please enter a Unit Specification"
							MaxLength       = "2000"
							style			= "width:98%;height:50"
							Size            = "40"
							Rows            = "2"
							Class           = "regular">
				  		
		    </TD>					 
		</tr>
		
		
		<tr><td height="6"></td></tr>
		
		<tr><td height="1" colspan="4" class="line"></td></tr> 
		<tr><td colspan="4" align="center" height="28">
		
		<cfif url.id2 neq "">		
			
			<cfquery name="verifyDelete" 
			datasource="AppsWorkorder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				select top 1 *
				from WorkOrderLineBillingDetail
				WHERE serviceItem = '#URL.ID1#'
				AND serviceItemUnit = '#URL.ID2#'
			</cfquery>	
			<cfif verifyDelete.recordCount eq 0>
				<!--- <input class="button10g" type="submit" name="Delete" value="Delete" style="width:140px;height:23" onclick="return ask()"> --->
			</cfif>			
			<input class="button10g" type="submit" name="Update" id="Update" value="Update Service Unit" style="width:190px;height:25">	
			
		<cfelse>
		
			<input class="button10g" type="submit" name="Save" id="Save" value="Save" style="width:190px;height:25">		
		
		</cfif>		
		
		</td></tr>
				
	</cfoutput>

	<tr>
	<td colspan="4" style="padding:7px;border:0px solid silver">
		<cfinclude template="Cost/ItemUnitMissionListing.cfm">
	</td></tr>
	
	<tr>
	<td colspan="4" style="padding:7px;border:0px solid silver">
		<cfinclude template="Service/ItemUnitServiceListing.cfm">
	</td></tr>
	
	<tr>
	<td colspan="4" style="padding:7px;border:0px solid silver">
		<cfinclude template="ItemUnitItemListing.cfm">
	</td></tr>
    	
</TABLE>

<!-- </cfform> -->
