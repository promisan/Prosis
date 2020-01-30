<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Metric" 
			  option="Maintaing Metric - #url.id1#" 
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_Metric
		WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="CountRec" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT TOP 1 Metric
		FROM 	AssetItemActionMetric
		WHERE 	Metric  = '#URL.ID1#' 
		UNION
		SELECT TOP 1 Metric
		FROM 	ItemSupplyMetric
		WHERE 	Metric  = '#URL.ID1#'
		UNION
		SELECT TOP 1 Metric
		FROM 	Ref_AssetActionMetric
		WHERE 	Metric  = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this metric?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>


<!--- edit form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelmedium">
		<cfif CountRec.recordCount eq 0>
  	   		<cfinput type="text" name="code" value="#get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regularxl">
		<cfelse>
		   <input type="hidden" name="Code" id="Code" value="#get.Code#">
			#get.Code#
		</cfif>
	   <input type="hidden" name="Codeold" id="Codeold" value="#get.Code#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
	   <cfinput type="text" name="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">UoM:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="MeasurementUoM" value="#get.MeasurementUoM#" message="Please enter a valid uom" required="No" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <td class="labelit">Measurement:</td>
    <TD class="labelit">
		<select name="measurement" id="measurement" class="regularxl">
			<option value="Cumulative" <cfif lcase(get.measurement) eq "cumulative">selected</cfif>>Cumulative
			<option value="Increment" <cfif lcase(get.measurement) eq "increment">selected</cfif>>Increment
		</select>
    </td>
    </tr>
	
	<TR>
    <td class="labelit">Operational:</td>
    <TD class="labelit">
		<input type="radio" name="operational" id="operational" class="radiol" value="1" <cfif get.operational eq 1>checked</cfif>>Yes
		<input type="radio" name="operational" id="operational" class="radiol" value="0" <cfif get.operational eq 0>checked</cfif>>No		
    </td>
    </tr>
		
	</cfoutput>
	
	<tr><td height="6"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td height="6"></td></tr>
	
			
	<tr>
		
	<td align="center" colspan="2">	
	
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<cfif CountRec.recordCount eq 0>
    <input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onclick="return ask()">
	</cfif>
    <input class="button10g" type="submit" name="Update" id="Update" value=" Update ">
	</td>	
	</tr>
	
</TABLE>

</cfform>
	
<cf_screenbottom layout="innerbox">
