<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
	  label="City" 
	  option="Add city" 
	  scroll="Yes" 
	  layout="webapp" 
	  banner="blue" 
	  menuAccess="Yes" 
	  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#&mission=&city=" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="6"></td></tr>
    <tr>
    <td width="20%">Entity:</td>
    <td>
		<cfquery name="mis" 
			datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
				SELECT 	*
				FROM  	Ref_ParameterMission
		</cfquery>
  	   	<cfselect name="mission" id="mission" required="Yes" message="Please, select a valid entity." query="mis" display="mission" value="mission">
	   	</cfselect>
    </td>
	</tr>
	
	<tr>
    <td>Region:</td>
    <td>
  	   <cfinput type="Text" name="city" id="city" value="" message="Please enter a city" required="Yes" size="30" maxlength="40" class="regular">
    </td>
	</tr>
	
	<tr>
    <td>Order:</td>
    <td>
  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regular" style="text-align:center;">
    </td>
	</tr>		
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="30">
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
	
	</tr>
	
</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
