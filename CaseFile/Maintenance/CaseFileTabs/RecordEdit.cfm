<cf_tl id="Edit Tab" var="1">

<cf_screentop height="100%" scroll="Yes" layout="webapp" title="#lt_text#" label="#lt_text#">



<script>
	function ask() {
		if (confirm("Do you want to remove this record ?")) {
		
		return true 
		
		}
		
		return false
	}	
</script>	

<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT * 
		FROM Ref_ClaimTypeTab
		WHERE 
		Mission = '#URL.ID1#'
		AND Code  = '#URL.ID2#'
		AND TabName = '#URL.ID3#'
</cfquery>

<cfquery name="qMission" datasource="AppsOrganization">
	SELECT Mission
	FROM Ref_MissionModule
	WHERE SystemModule='Insurance'
</cfquery>
 
 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">
<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td height="5"></td></tr>

    <!--- Entry form --->
	<input type="hidden" name="MissionOld" value="#get.Mission#">
	<input type="hidden" name="TabNameOld" value="#get.TabName#" >
			
    <TR>
    <TD class="labelit"><cf_tl id="Mission">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cfselect name="Mission" required="Yes" class="regularxl">
			<option value=""></option>
			<cfloop query="qMission">
				<option value="#qMission.Mission#" <cfif qMission.Mission eq Get.Mission>selected</cfif> >#qMission.Mission#</option> 
			</cfloop>
		</cfselect>
	</TD>
	</TR>
	
    <TR>
    <TD class="labelit"><cf_tl id="Claim type">:</TD>
    <TD class="labelit">
		<cfquery name="getClaimType" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
					SELECT Code,Description FROM Ref_ClaimType
					WHERE Code = '#Get.Code#'
		</cfquery>
		#getClaimType.Description#
		<input type="hidden" value="#Get.Code#" name="Code">
	</TD>
	</TR>
	
	
    <TR>
    <TD class="labelit"><cf_tl id="Tab Name"> <font color="red">*</font>:</TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Name" var = "1" class="Message">
		<cfinput type="Text" name="TabName" value="#Get.TabName#" message="Please enter a Tab Name" required="Yes" size="50" maxlength="50"
		class="regularxl">
	</TD>
	</TR>

    <TR>
    <TD class="labelit"><cf_tl id="Tab Label">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Label" var = "1" class="Message">
		<cfinput type="Text" name="TabLabel" value="#Get.TabLabel#" message="#lt_text#" required="Yes" size="60" maxlength="50"
		class="regularxl">
	</TD>
	</TR>
	
    <TR>
    <TD class="labelit"><cf_tl id="Tab Order">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Order" var = "1" class="Message">
		<cfinput type="Text" name="TabOrder" value="#Get.TabOrder#" message="Please enter a Tab Order" required="Yes" size="2" maxlength="2"
		class="regularxl">
	</TD>
	</TR>

    <TR>
    <TD class="labelit"><cf_tl id="Tab Icon">:</TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Icon" var = "1" class="Message">
		<cfinput type="Text" name="TabIcon" value="#Get.TabIcon#" message="Please enter a Tab Icon" required="No" size="80" maxlength="80"
		class="regularxl">
	</TD>
	</TR>		

    <TR>
    <TD class="labelit"><cf_tl id="Tab Template">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Template" var = "1" class="Message">
		<cfinput type="Text" name="TabTemplate" value="#Get.TabTemplate#" message="Please enter a Tab Template" required="Yes" size="60" maxlength="60"
		class="regularxl">
	</TD>
	</TR>	
	
	<TR>
    <TD class="labelit"><cf_tl id="Tab Element Class">:</TD>
    <TD class="labelit">
		<cfquery name="ElementClass" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM Ref_ElementClass
			WHERE ClaimType = '#Get.Code#'
		</cfquery>
		<cfselect name="TabElementClass" class="regularxl" required="Yes">
			<cfloop query="ElementClass">
				<option <cfif Get.TabElementClass eq ElementClass.Code>selected</cfif> value="#Code#">#Description#</option>
			</cfloop>
		</cfselect>
	</TD>
	</TR>
	
	
	<TR>
    <td class="labelit"><cf_tl id="Read Level">:</td>
    <TD class="labelit">  
	  <input type="radio" name="AccessLevelRead" <cfif Get.AccessLevelRead eq "0">checked</cfif> value="0">0
      <input type="radio" name="AccessLevelRead" <cfif Get.AccessLevelRead eq "1">checked</cfif> value="1">1
      <input type="radio" name="AccessLevelRead" <cfif Get.AccessLevelRead eq "2">checked</cfif> value="2">2	  
    </td>
    </tr>		
	
	<TR>
    <td class="labelit"><cf_tl id="Edit Level">:</td>
    <TD class="labelit">  
	  <input type="radio" name="AccessLevelEdit" <cfif Get.AccessLevelEdit eq "0">checked</cfif> value="0">0
      <input type="radio" name="AccessLevelEdit" <cfif Get.AccessLevelEdit eq "1">checked</cfif> value="1">1
      <input type="radio" name="AccessLevelEdit" <cfif Get.AccessLevelEdit eq "2">checked</cfif> value="2">2	  
    </td>
    </tr>			
		
	<TR>
    <td class="labelit"><cf_tl id="Mode">:</td>
    <TD class="labelit">  
	  <input type="radio" name="ModeOpen" <cfif Get.ModeOpen eq "Embed">checked</cfif> value="Embed"><cf_tl id="Embed upon opening">
      <input type="radio" name="ModeOpen" <cfif Get.ModeOpen eq "Bind">checked</cfif> value="Bind"><cf_tl id="Bind on select">
    </td>
    </tr>	
	
	<TR>
    <td class="labelit"><cf_tl id="Operational">:</td>
    <TD class="labelit">  
	  <input type="radio" name="Operational" <cfif Get.Operational eq "1">checked</cfif> value="1"><cf_tl id="Yes">
      <input type="radio" name="Operational" <cfif Get.Operational eq "0">checked</cfif> value="0"><cf_tl id="No">
    </td>
    </tr>		
	
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">	
	
	<TR>	
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Delete" var = "1">
		<input class="button10g" type="submit" name="Delete" value=" #lt_text# " onclick="return ask()">
		<cf_tl id="Update" var = "1">
		<input class="button10g" type="submit" name="Update" value=" #lt_text# ">
		</td>	
	</TR>

    
</TABLE>


</cfoutput>
</CFFORM>

</BODY></HTML>



