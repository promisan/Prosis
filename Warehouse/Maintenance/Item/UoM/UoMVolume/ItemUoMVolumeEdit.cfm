<cfquery name="Get" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	ItemUoMVolume
	WHERE	ItemNo = '#URL.ID#'
	AND		UoM = '#URL.UoM#'
	<cfif url.Temperature neq "">AND Temperature = '#URL.temperature#'<cfelse>AND 1=0</cfif>
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

<cfoutput>
	<cf_tl id="Do you want to remove this record" var = "vRemove">

<!---	
<cfif url.temperature neq "">
	<cf_screentop height="100%" scroll="Yes" layout="webapp" label="Unit of Measure Volume" option="Maintain Unit of Measure Volume [#Item.ItemDescription# - #Item.UoMDescription#]" banner="yellow" user="no">
<cfelse>
	<cf_screentop height="100%" scroll="Yes" layout="webapp" label="Unit of Measure Volume" option="Add Unit of Measure Volume [#Item.ItemDescription# - #Item.UoMDescription#]" user="no">
</cfif>
--->

<script language="JavaScript">

function ask() {
	if (confirm("#vRemove#?")) {	
	return true 	
	}	
	return false	
}	

</script>

</cfoutput>

<!--- edit form --->
<table class="hide">
	<tr><td><iframe name="processItemUoMVolume" id="processItemUoMVolume" frameborder="0"></iframe></td></tr>
</table>
	
<cfform action="UoMVolume/ItemUoMVolumeSubmit.cfm" method="POST" name="frmItemUoMVolume" target="processItemUoMVolume">

<table width="80%" align="center" class="formpadding">

	 <cfoutput>

    <tr class="labelmedium"><td colspan="2" style="font-size:18px">
				
	<cfif url.temperature neq "">
		 Maintain Unit of Measure Volume [#Item.ItemDescription# - #Item.UoMDescription#]
	<cfelse>
		 Add Unit of Measure Volume [#Item.ItemDescription# - #Item.UoMDescription#]
	</cfif>
		
	</td></tr>

	<tr><td colspan="2" align="center" height="10"></tr>
	
	<cfinput type="hidden" name="ItemNo" value="#url.id#">
	<cfinput type="hidden" name="UoM" value="#url.uom#">
	<cfinput type="hidden" name="TemperatureOld" value="#url.temperature#">		
	
    <TR>
    <TD class="labelit" width="20%">Temperature:</TD>
    <TD>
   		<cfinput type="text" name="Temperature" value="#get.Temperature#" size="10" required="yes" message="Please, enter a valid numeric temperature" validate="numeric" maxlength="20" style="text-align:right; padding-right:2px;" class="regularxl">	
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelit"><cf_tl id="Volume Ratio">:</TD>
    <TD>
  	   <cfinput type="text" name="VolumeRatio" value="#get.volumeRatio#" size="10" required="yes" message="Please, enter a valid numeric volume ratio" validate="numeric" maxlength="20" style="text-align:right; padding-right:2px;" class="regularxl">
    </TD>
	</TR>
		
	</cfoutput>
		
	<tr><td colspan="2" align="center" height="6"></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6"></tr>
	
	<tr><td align="center" colspan="2" height="40">
	<cfif url.temperature neq "">
    <input type="submit" name="Delete" id="Delete" value="Delete" class="button10g" onClick="return ask()">
    <input type="submit" class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	<cfelse>
	<input type="submit" class="button10g" type="submit" name="Save" id="Save" value="Save">
	</cfif>
	</td>	
	
	</tr>

</TABLE>

</cfform>