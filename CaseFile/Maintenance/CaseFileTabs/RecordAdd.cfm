<cf_tl id = "Add Tab" var = "1">
<cf_screentop height="100%" scroll="Yes" layout="webapp" title="#lt_text#" label="#lt_text#">




<cfquery name="qMission" datasource="AppsOrganization" 	username="#SESSION.login#"  password="#SESSION.dbpw#">
	SELECT Mission
	FROM Ref_MissionModule
	WHERE SystemModule='Insurance'
</cfquery>
 
 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">
<cfoutput>
<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

   <tr><td height="5"></td></tr>
<!--- Entry form --->

    <TR>
    <TD class="labelit"><cf_tl id="Mission">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cfselect name="Mission" required="Yes" class="regularxl">
			<option value="" selected></option>
			<cfloop query="qMission">
				<option value="#qMission.Mission#">#qMission.Mission#</option> 
			</cfloop>
		</cfselect>
	</TD>
	</TR>

    <TR>
    <TD class="labelit"><cf_tl id="Claim type">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cfquery name="getClaimType" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
					SELECT Code,Description FROM Ref_ClaimType
					WHERE Code = '#URL.ID1#'
		</cfquery>

		<input type="hidden" value="#getClaimType.Code#" name="code">
		#getClaimType.Description#

	</TD>
	</TR>
	
    <TR>
    <TD class="labelit"><cf_tl id="Tab Name">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab name" var = "1" class="Message">
		<cfinput type="Text" name="TabName" value="" message="#lt_text#" required="Yes" size="60" maxlength="50"
		class="regularxl">
	</TD>
	</TR>

    <TR>
    <TD class="labelit"><cf_tl id="Tab Label">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Label" var = "1" class="Message">
		<cfinput type="Text" name="TabLabel" value="" message="#lt_text#" required="Yes" size="60" maxlength="50"
		class="regularxl">
	</TD>
	</TR>
	
    <TR>
    <TD class="labelit"><cf_tl id="Tab Order">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Order" var = "1" class="Message">
		<cfinput type="Text" name="TabOrder" value="" message="#lt_text#" required="Yes" size="2" maxlength="2"
		class="regularxl">
	</TD>
	</TR>

    <TR>
    <TD class="labelit"><cf_tl id="Tab Icon">:</TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Icon" var = "1" class="Message">
		<cfinput type="Text" name="TabIcon" value="" message="Please enter a Tab Icon" required="No" size="60" maxlength="80"
		class="regularxl">
	</TD>
	</TR>		

    <TR>
    <TD class="labelit"><cf_tl id="Tab Template">: <font color="red">*</font></TD>
    <TD class="labelit">
		<cf_tl id = "Please enter a Tab Template" var = "1" class="Message">
		<cfinput type="Text" name="TabTemplate" value="" message="#lt_text#" required="Yes" size="60" maxlength="60"
		class="regularxl">
	</TD>
	</TR>	
	
    <TR>
    <TD class="labelit"><cf_tl id="Tab Element Class">:</TD>
    <TD class="labelit">
		<cfselect name="TabElementClass" required="Yes" 
				bindOnLoad="yes"
		   		bind="cfc:service.Input.Input.DropdownSelect('AppsCaseFile','Ref_ElementClass','Code','Description','ClaimType',{code},'','','')" class="regularxl">				
	    </cfselect>
	</TD>
	</TR>
	
	<TR>
    <td class="labelit"><cf_tl id="Read Level">:</td>
    <TD class="labelit">  
	  <input type="radio" name="AccessLevelRead" checked value="0">0
      <input type="radio" name="AccessLevelRead" value="1">1
      <input type="radio" name="AccessLevelRead" value="2">2	  
    </td>
    </tr>		
	
	<TR>
    <td class="labelit"><cf_tl id="Edit Level">:</td>
    <TD class="labelit">  
	  <input type="radio" name="AccessLevelEdit" checked value="0">0
      <input type="radio" name="AccessLevelEdit" value="1">1
      <input type="radio" name="AccessLevelEdit" value="2">2	  
    </td>
    </tr>			
		
	<TR>
    <td class="labelit"><cf_tl id="Mode">:</td>
    <TD class="labelit">  
	  <input type="radio" name="ModeOpen" checked value="Embed"><cf_tl id="Embed upon opening">
      <input type="radio" name="ModeOpen" value="Bind"><cf_tl id="Bind on selection">
    </td>
    </tr>	
	
	<TR>
    <td class="labelit">Operational:</td>
    <TD class="labelit">  
	  <input type="radio" name="Operational" checked value="1"><cf_tl id="Yes">
      <input type="radio" name="Operational" value="0"><cf_tl id="No">
    </td>
    </tr>		
	
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">	
	
	<TR>	
		<td align="center" colspan="2">
			<cf_tl id="Cancel" var = "1">
			<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
			<cf_tl id="Submit" var = "1">
			<input class="button10g" type="submit" name="Insert" value=" #lt_text# ">
		</td>	
	</TR>

    
</TABLE>


</cfoutput>
</CFFORM>

</BODY></HTML>