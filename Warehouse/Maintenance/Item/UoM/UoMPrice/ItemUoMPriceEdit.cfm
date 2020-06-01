<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	P.*, 
			ISNULL(W.WarehouseName, 'For All Warehouses') as WarehouseName, 
			S.Description as PriceScheduleName
	FROM 	ItemUoMPrice P
			INNER JOIN Ref_PriceSchedule S
				ON P.PriceSchedule = S.Code
			LEFT OUTER JOIN Warehouse W
				ON P.Warehouse = W.Warehouse
	WHERE 	P.ItemNo = '#URL.ID#'
	AND		P.UoM = '#URL.UoM#'
	<cfif url.price neq "">AND P.PriceId = '#URL.price#'<cfelse>AND 1=0</cfif>
</cfquery>

<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	I.ItemDescription, U.UoMDescription
	FROM 	Item I,
			ItemUoM U
	WHERE 	I.ItemNo = U.ItemNo
	AND		I.ItemNo = '#URL.ID#'
	AND		U.UoM = '#URL.UoM#'
</cfquery>

<cfquery name="Taxes"
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_Tax
</cfquery>

<cfif url.price neq "">
	<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('mydialog',true)" html="No" scroll="Yes" layout="webapp" label="Unit of Measure Price" option="Maintain Unit of Measure Price [#Item.ItemDescription# - #Item.UoMDescription#]" banner="yellow">
<cfelse>
	<cf_screentop height="100%" close="parent.ColdFusion.Window.destroy('mydialog',true)" html="No" scroll="Yes" layout="webapp" label="Unit of Measure Price" option="Add Unit of Measure Price [#Item.ItemDescription# - #Item.UoMDescription#]">
</cfif>
<cfoutput>

<cf_tl id = "Do you want to remove this record ?" var = "vConfirm">

<script language="JavaScript">
	
	function ask() {
		if (confirm("#vConfirm#")) {	
		return true 	
		}	
		return false	
	}	

</script>
</cfoutput>

<cf_calendarscript>

<!--- edit form --->
<iframe name="processItemUoMPrice" id="processItemUoMPrice" frameborder="0" style="display:none"></iframe>

<cfform action="ItemUoMPriceSubmit.cfm" method="POST" name="frmItemUoMPrice" target="processItemUoMPrice">

<table width="92%" align="center" class="formpadding formspacing">
		
	<tr><td colspan="2" align="center" height="10"></tr>
	
    <cfoutput>
	
	<cfinput type="hidden" name="ItemNo" value="#url.id#">
	<cfinput type="hidden" name="UoM" value="#url.uom#">
	<cfinput type="hidden" name="PriceId" value="#url.price#">		
	
    <TR class="labelmedium">
    <TD width="30%"><cf_tl id="Entity">:</TD>
    <TD>
   		<cfquery name="getLookup" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterMission
			WHERE	Mission IN (SELECT Mission FROM Organization.dbo.Ref_MissionModule WHERE SystemModule = 'Warehouse')
		</cfquery>
		<select name="mission" id="mission" class="regularxl">
			<option value="">Applies to all</option>
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif getLookup.mission eq #get.mission#>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>		
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Warehouse">:</TD>
    <TD>
  	   <cfdiv id="divWarehouse" bind="url:Warehouse.cfm?mission={mission}&warehouse=#get.warehouse#">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Price Schedule">:</TD>
    <TD>
  	   <cfquery name="getLookup" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_PriceSchedule
		</cfquery>
		<select name="PriceSchedule" id="PriceSchedule" class="regularxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.Code#" <cfif getLookup.Code eq #get.PriceSchedule#>selected</cfif>>#getLookup.description#</option>
		  	</cfloop>
		</select>
    </TD>
	</TR>	
	
	<TR class="labelmedium">
		<td><cf_tl id="Currency">:</td>
		<td>
		<cfquery name="getLookup" 
			datasource="AppsLedger" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Currency
			WHERE EnableProcurement = 1
			AND		Operational = 1 			
		</cfquery>
		
		<cfif get.currency eq "">
		   <cfset curr = APPLICATION.BaseCurrency>
		<cfelse>
		   <cfset curr = get.currency>   
		</cfif>
							
		<select name="currency" id="currency" class="regularxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.currency#" <cfif curr eq getLookup.currency>selected</cfif>>#getLookup.currency# - #getLookup.description#</option>
		  	</cfloop>
		</select>		
		
		</td>		
	</TR>
	
	<TR class="labelmedium">
		<td><cf_tl id="Date Effective">:</td>
		<td>
		<cfif url.price neq "">   
			<cf_intelliCalendarDate9
				FieldName="dateEffective" 
				class="regularxl"
				Default="#dateformat(get.dateEffective, CLIENT.DateFormatShow)#"
				AllowBlank="False">
		<cfelse>
			<cf_intelliCalendarDate9
				FieldName="dateEffective" 
				class="regularxl"
				Default="#dateformat(now(), CLIENT.DateFormatShow)#"
				AllowBlank="False">
		</cfif>			 						 					 
       </td>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Price">:</TD>
    <TD>
  	   <cfinput type="text" style="text-align:right" name="SalesPrice" value="#NumberFormat(get.SalesPrice, ".__")#" size="11" required="yes" message="Please, enter a sales price" validate="numeric" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Tax">:</TD>
    <TD>
	   <select name="TaxCode" class="regularxl">
		    <cfloop query="taxes">
				<option value="#TaxCode#" <cfif TaxCode eq get.TaxCode>selected</cfif>>
		    		#Description#
				</option>
			</cfloop>
	    </select>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Calculation Mode">:</TD>
    <TD>
  	   <input readonly style="background-color:f4f4f4" type="text" name="CalculationMode" value="#get.CalculationMode#" size="20" required="no" message="Please, enter a calculation mode" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Calculation Class">:</TD>
    <TD>
  	   <input readonly style="background-color:f4f4f4" type="text" name="CalculationClass" value="#get.CalculationClass#" size="20" required="no" message="Please, enter a calculation class" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD><cf_tl id="Calculation Pointer">:</TD>
    <TD>
  	   <input readonly style="background-color:f4f4f4" type="text" name="CalculationPointer" value="#get.CalculationPointer#" size="20" required="yes" message="Please, enter a calculation pointer" validate="numeric" maxlength="20" class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6"></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6"></tr>
	
	<tr><td align="center" colspan="2" height="40">
	<cfif url.price neq "">
    <cf_button class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask();">
    <cf_button class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	<cfelse>
	<cf_button class="button10g" type="submit" name="Save" id="Save" value="  Save  ">
	</cfif>
	</td>	
	
	</tr>
	


</TABLE>
</CFFORM>