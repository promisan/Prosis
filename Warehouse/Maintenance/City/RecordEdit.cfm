<cfparam name="url.idmenu" default="">

<cfquery name="get" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM   	Ref_WarehouseCity
		WHERE  	Mission = '#url.mission#'
		AND		City = '#url.city#'
</cfquery>

<cfquery name="Countrec" 
	datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT 	*
		FROM  	Warehouse
		WHERE  	Mission = '#url.mission#'
		AND		City = '#url.city#'
</cfquery>

<script language="JavaScript">

function ask(mission,city) {
	if (confirm("Do you want to remove this record ?")) {	
		ColdFusion.navigate('RecordPurge.cfm?mission='+mission+'&city='+city,'processDelete');
	}	
}	

</script>

<cf_screentop height="100%" 
	  label="City" 
	  option="Maintain #url.city#" 
	  scroll="Yes" 
	  layout="webapp" 
	  banner="yellow" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&mission=#url.mission#&city=#url.city#" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <cfoutput>
    <tr>
    <td width="20%">Entity:</td>
    <td>
	   	#get.mission#
		<input type="hidden" name="mission" id="mission" value="#get.mission#">
    </td>
	</tr>
	
	<tr>
    <td width="20%">Region:</td>
    <td>
	   	#get.city#
		<input type="hidden" name="city" id="city" value="#get.city#">
    </td>
	</tr>
	
	<tr>
    <td>Order:</td>
    <td>
  	   <cfinput type="Text" name="listingOrder" value="#get.listingOrder#" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regular" style="text-align:center;">
    </td>
	</tr>
			
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
		<table>
			<tr>
				<td>
					<cf_tl id = "Save" var ="1">
					<cf_button 
						type		= "submit"
						mode        = "silver"
						label       = "#lt_text#" 
						id          = "save"
						width       = "100px" 					
						color       = "636334"
						fontsize    = "11px">
				</td>
				<cfif Countrec.recordcount eq 0>
				<td width="5"></td>
				<td>
					<cf_tl id = "Delete" var ="1">
					<cf_button 
						type		= "button"
						mode        = "silver"
						label       = "#lt_text#"
						onclick		= "return ask('#url.mission#','#url.city#');" 
						id          = "delete"
						width       = "100px" 					
						color       = "636334"
						fontsize    = "11px">
				</td>
				</cfif>
			</tr>
		</table>
	</td>	
	
	</tr>
	
	<tr><td id="processDelete"></td></tr>
	
</table>

</cfform>	

<cf_screenbottom layout="webapp">
	