
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
	
	<table style="width:100%;padding-left:10px" border="0" class="formpadding">
			
	<tr><td valign="top">
	
	<cfform name="mycategory" id="mycategory">
	
	<!--- Entry form --->
		
	<table class="formpadding formspacing">
	
		<cfoutput>
	   
	    <!--- Field: Id --->
	   
		<cfif url.id2 eq "">
			
		   <TR class="labelmedium2">
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
	    <TR class="labelmedium2">
	    <TD ><cf_tl id="Allow Oversale">:</TD>
	    <TD style="height:25px">		
		
		    <table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Oversale" id="Oversale" <cfif Get.Oversale eq "1">checked</cfif> value="1"></td>
			<td style="padding-left:4px">#vYes#</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="Oversale" id="Oversale" <cfif Get.Oversale eq "0"  or url.id2 eq "">checked</cfif> value="0"></td>
			<td style="padding-left:4px">No</td>	
			</tr>		
			</table>
			
		</TD>
		</TR>	
		
		<tr class="labelmedium2">
			<td><cf_tl id="Discount Threshold"> :</td>
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
			       class="regularxxl enterastab"
	         	   style="width:30;text-align:center;padding-right:4px">
				   
				</td>
				<td class="labelmedium2" style="padding-left:5px">%</td>			
				</tr></table>
			</td>
		</tr>
			
		<!--- Field: Selfservice --->
	    <TR class="labelmedium2">
	    <TD><cf_tl id="Self-service">:</TD>
	    <TD style="height:25px">	
		
		 <table>
			<tr class="labelmedium2">
			<td><input type="radio" class="radiol" name="Selfservice" id="Selfservice" <cfif Get.Selfservice eq "1" or url.id2 eq "">checked</cfif> value="1"></td>
			<td style="padding-left:4px">#vYes#</td>
			<td style="padding-left:5px"><input type="radio" class="radiol" name="Selfservice" id="Selfservice" <cfif Get.Selfservice eq "0">checked</cfif> value="0"></td>
			<td style="padding-left:4px">No</td>	
			</tr>		
			</table>
			
		</TD>
		</TR>		
		
		<!--- Field: Request Mode --->
	    <TR class="labelmedium2">
	    <TD><cf_tl id="POL Request Mode">:</TD>
	    <TD style="height:25px">		
			<input type="radio" class="radiol" name="RequestMode" id="RequestMode" <cfif Get.RequestMode eq "1" or url.id2 eq "">checked</cfif> value="1"><cf_tl id="Consolidated">
			<input type="radio" class="radiol" name="RequestMode" id="RequestMode" <cfif Get.RequestMode eq "0">checked</cfif> value="0"><cf_tl id="Not Consolidated">
		</TD>
		</TR>	
		
		<!--- Field: TaxCode --->
	    <TR class="labelmedium2">
	    <TD><cf_tl id="Tax Code">:</TD>
	    <TD style="height:25px">		
			
			<select name="TaxCode" id="TaxCode" class="regularxxl">
					<cfloop query="TaxCodes">
						<option value="#TaxCode#" <cfif TaxCode eq Get.TaxCode>selected</cfif>>#Description#</option>
					</cfloop>
				</select>
					
		</TD>
		</TR>	 
		
		<!--- Field: Operational --->
	    <TR class="labelmedium2">
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
		
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr><td colspan="2" height="25" align="center">
		<cfoutput>	
			<input type="button"
			  class="button10g" style="width:120" name="Save" id="Save" value="#vSave#" 
			  onclick="ptoken.navigate('#session.root#/Warehouse/Maintenance/Warehouse/Category/CategorySubmit.cfm?idmenu=#url.idmenu#&id1=#url.id1#&id2=#url.id2#','contentsubbox1','','','POST','mycategory')">
		</cfoutput>
	</td></tr>
		
	</TABLE>

