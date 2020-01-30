<cfparam name="url.idmenu" default="">

<cf_tl id = "Edit Status" var = "1">
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp"
			  banner="gray" 
			  title="#lt_text#" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  line="no"
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Status
	WHERE StatusClass = '#URL.ID1#'
	AND Status = '#URL.ID2#'
</cfquery>

<cfoutput>
<cf_tl id = "Do you want to remove this record ?" var = "1" class = "Message">

<script language="JavaScript">

function ask() {

	if (confirm("#lt_text#")) {
	
		return true 
	
	}
	
	return false
	
}	
</script>
</cfoutput>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">


<!--- edit form --->


<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	 <tr><td></td></tr>
	 <cfoutput>
	 <TR>
	 <TD class="labelmedium" style="padding-right:5px"><cf_tl id="Class">:</TD>  
	 <TD class="labelmedium">
			<select name="StatusClass" id="StatusClass" class="regularxl">
			  <option value="clm" <cfif Get.StatusClass eq "clm">selected</cfif>>Claim Header</option>
			  <option value="lne" <cfif Get.StatusClass eq "lne">selected</cfif>>Line</option>
			</select>
		   <input type="hidden" name="StatusClassOld" value="#get.StatusClass#">
	 </TD>
	 </TR>
	 
	<!--- Field: code --->
	 <TR>
	 <TD class="labelmedium" style="padding-right:5px"><cf_tl id="Code">:</TD>  
	 <TD class="labelmedium">
	 	<input type="Text" name="Status" id="Status" value="#get.Status#" size="2" maxlength="2"class="regularxl">
		<input type="hidden" name="StatusOld" id="StatusOld" value="#get.Status#">
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelmedium" style="padding-right:5px"><cf_tl id="Description">:</TD>
    <TD class="labelmedium">
		<cf_tl id = "Please enter a description" var = "1" class = "Message"> 
  	  	<cfinput type="Text" name="Description" id="Description" value="#get.Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
				
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr>	
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Delete" var = "1">
		<input class="button10g" type="submit" name="Delete" value=" #lt_text# " onclick="return ask()">
		<cf_tl id="Update" var = "1">
		<input class="button10g" type="submit" name="Update" value=" #lt_text# ">
		</td>
	</tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>
