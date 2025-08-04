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

<cf_tl id = "Yes" var = "vYes">
<cf_tl id = "Save"   var = "vSave">

<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*,
			(SELECT Description FROM Ref_Category WHERE Category = '#URL.ID2#') AS CategoryDescription
	FROM 	WarehouseCategory
	WHERE 	Warehouse = '#URL.ID1#'
	AND		Category  = '#URL.ID2#'
</cfquery>

<cfquery name="TaxCodes" 
datasource="appsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Tax	
</cfquery>
	
	<table style="width:100%;padding-left:10px" border="0">
			
	<tr><td valign="top">
	
	<cfform name="mycategory" id="mycategory">
	
	<!--- Entry form --->
		
	<table class="formpadding formspacing" style="width:100%">
	
		<cfoutput>
	   
	    <!--- Field: Id --->
	   
		<cfif url.id2 eq "">
			
		   <TR class="labelmedium2 linedotted">
	   		<td style="min-width:150px"><cf_tl id="Category">:</td>
		    <TD>
	
			<cfquery name="getLookup" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM 	Ref_Category
					WHERE   Category NOT IN (SELECT Category 
					                         FROM   WarehouseCategory
										     WHERE  warehouse = '#url.id1#')
					
			</cfquery>
			<select name="Category" id="Category" class="regularxxl">
				<cfloop query="getLookup">
					<option value="#getLookup.Category#" <cfif getLookup.Category eq Get.Category>selected</cfif>>#getLookup.Description#</option>
				</cfloop>
			</select>
			
			</TD>
			</TR>
				
		<cfelse>		
			<input type="hidden" name="Category" ID="Category" value="<cfoutput>#get.Category#</cfoutput>">
		</cfif>
		<input type="hidden" name="CategoryOld" id="CategoryOld" value="<cfoutput>#Get.Category#</cfoutput>">
		<input type="hidden" name="Warehouse" ID="Warehouse" value="<cfoutput>#url.id1#</cfoutput>">
		
		<!--- Field: Oversale --->
	    <TR class="labelmedium2 linedotted">
	    <TD ><cf_tl id="Minimum Reorder mode">:</TD>
	    <TD style="height:25px">		
		
		    <table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="MinReorderMode" <cfif Get.MinReorderMode eq "Default" or url.id2 eq "">checked</cfif> value="Default"></td>
			<td style="padding-top:2px;min-width:90px;padding-left:4px">Default (1)</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="MinReorderMode" <cfif Get.MinReorderMode eq "Parent">checked</cfif> value="Parent"></td>
			<td style="padding-top:2px;padding-left:4px">Parent warehouse</td>	
			</tr>		
			</table>
			
		</TD>
		</TR>	
		
		<!--- Field: Request Mode --->
	    <TR class="labelmedium2 linedotted">
	    <TD><cf_tl id="POL Request Mode">:</TD>
	    <TD style="height:25px">		
    		 <table>
			<tr class="labelmedium2">
			<td>
			<input type="radio" class="radiol" name="RequestMode" id="RequestMode" <cfif Get.RequestMode eq "1" or url.id2 eq "">checked</cfif> value="1">
			</td>
			<td style="padding-top:2px;min-width:90px;padding-left:4px"><cf_tl id="Consolidated"></td>
			<td style="padding-left:5px">			
			<input type="radio" class="radiol" name="RequestMode" id="RequestMode" <cfif Get.RequestMode eq "0">checked</cfif> value="0"></td>
			<td style="padding-top:2px;padding-left:4px"><cf_tl id="Not Consolidated"></td>	
			</tr>		
			</table>
			
		</TD>
		</TR>	
		
		<!--- Field: Oversale --->
	    <TR class="labelmedium2 linedotted">
	    <TD ><cf_tl id="Allow Oversale">:</TD>
	    <TD style="height:25px">		
		
		    <table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Oversale" id="Oversale" <cfif Get.Oversale eq "1">checked</cfif> value="1"></td>
			<td style="padding-top:2px;padding-left:4px">#vYes#</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="Oversale" id="Oversale" <cfif Get.Oversale eq "0"  or url.id2 eq "">checked</cfif> value="0"></td>
			<td style="padding-top:2px;padding-left:4px">No</td>	
			</tr>		
			</table>
			
		</TD>
		</TR>	
		
		<tr class="labelmedium2 linedotted">
			<td><cf_tl id="Maximum Quote Discount"> :</td>
			<td style="height:25px">
			   <table><tr><td>
				<cfinput type="Text"
			       name="ThresholdDiscount"
			       value="#Get.ThresholdDiscount#"
			       range="1,100"
			       validate="integer"
			       required="No"
			       visible="Yes"
			       enabled="Yes"		       
			       typeahead="No"
			       class="regularxl enterastab"
	         	   style="width:30;text-align:center;padding-right:4px">
				   
				</td>
				<td class="labelmedium2" style="padding-left:5px">%</td>			
				</tr></table>
			</td>
		</tr>
			
		<!--- Field: Selfservice --->
	    <TR class="labelmedium2 linedotted">
	    <TD><cf_tl id="WWW presentation">:</TD>
	    <TD style="height:25px">	
		
		 <table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Selfservice" id="Selfservice" <cfif Get.Selfservice eq "1" or url.id2 eq "">checked</cfif> value="1"></td>
			<td style="padding-top:2px;padding-left:4px">#vYes#</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="Selfservice" id="Selfservice" <cfif Get.Selfservice eq "0">checked</cfif> value="0"></td>
			<td style="padding-top:2px;padding-left:4px">No</td>	
			</tr>		
			</table>
			
		</TD>
		</TR>		
		
		
		
		<!--- Field: TaxCode --->
	    <TR class="labelmedium2 linedotted">
	    <TD><cf_tl id="Default Tax Code">:</TD>
	    <TD style="height:25px">		
			
			<select name="TaxCode" id="TaxCode" class="regularxl">
					<cfloop query="TaxCodes">
						<option value="#TaxCode#" <cfif TaxCode eq Get.TaxCode>selected</cfif>>#Description#</option>
					</cfloop>
				</select>
					
		</TD>
		</TR>	 
		
		<!--- Field: Operational --->
	    <TR class="labelmedium2 line">
	    <TD><cf_tl id="Enabled">:</TD>
	    <TD style="height:25px">		
		
		    <table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Operational" id="Operational" <cfif Get.Operational eq "1" or url.id2 eq "">checked</cfif> value="1"></td>
			<td style="padding-left:4px">#vYes#</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="Operational" id="Operational" <cfif Get.Operational eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px">No</td>	
			</tr>		
			</table>
			
		</TD>
		</TR>	
		 
		</cfoutput>
	</table>	
	
	</CFFORM>
	
	</td>
	
	</tr>
				
	<tr><td colspan="2" height="25" align="center">
		<cfoutput>	
			<input type="button"
			  class="button10g" style="width:120" name="Save" id="Save" value="#vSave#" 
			  onclick="ptoken.navigate('#session.root#/Warehouse/Maintenance/Warehouse/Category/CategorySubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#','contentsubbox1','','','POST','mycategory')">
		</cfoutput>
	</td></tr>
		
	</TABLE>

