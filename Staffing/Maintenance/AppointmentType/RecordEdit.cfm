<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Edit Appointment type" 
			  scroll="Yes" 			  
			  layout="webapp" banner="gray"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_AppointmentStatus
	WHERE  Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

	function ask() {
		if (confirm("Do you want to remove this Appointment Status ?")) {
			return true 
		}
		return false	
	}

	function hlMission(mis,cl) {
		var control = document.getElementById('mission_'+mis);
		if (control.checked) {
			document.getElementById('td_'+mis).style.backgroundColor = cl;
		}else{
			document.getElementById('td_'+mis).style.backgroundColor = '';
		}
	}
</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">

	<tr><td></td></tr>
    <cfoutput>
    <TR class="labelmedium">
    <TD width="120"><cf_tl id="Code">:</TD>
    <TD>
  	   <input type="text" name="Code" value="#get.Code#" size="10" maxlength="10"class="regularxl">
	   <input type="hidden" name="CodeOld" value="#get.Code#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="33" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Reference content:</TD>
    <TD>
  	   <cfinput type="Text" name="MemoContent" value="#get.MemoContent#" message="Please enter a description" required="no" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
		
	<TR class="labelmedium">
    <TD>List Ordering:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" style="width:37px;text-align:center" value="#get.ListingOrder#" message="Please enter a Listing Order" required="No" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD style="height:25px;padding-top:2px;">Enabled for:</TD>	
    <TD style="padding-right:10px">
		<cfdiv id="divMission" bind="url:RecordMission.cfm?code=#get.code#">
    </TD>
	</TR>
	
	<TR class="labelmedium">
    <TD>Operational:</TD>
    <TD>
  	   <input type="Checkbox" name="Operational" value="#get.Operational#" visible="Yes" enabled="Yes" class="radiol">
    </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
		
	<tr>	
	<td align="center" colspan="2" height="35">
	
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	</tr>
	
</TABLE>
	
</CFFORM>