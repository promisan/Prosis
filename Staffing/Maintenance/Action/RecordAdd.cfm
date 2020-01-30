
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Action" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

<tr><td height="8"></td></tr>

	 <cfquery name="Src" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT 	*
		FROM 	Ref_ActionSource		
	</cfquery>
	 
	<TR>
	 <TD width="150" class="labelmedium">Source:&nbsp;</TD>  
	 <TD>
	 	<select name="ActionSource" class="regularxl" onchange="javascript: ColdFusion.navigate('EntityClass.cfm?ActionSource='+this.value+'&entityClass=','divWorkflow');">
		<cfoutput query="Src">
		<option value="#ActionSource#">#ActionSource#</option>
		</cfoutput>
		</select>
	 </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="ActionCode" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Effective Mode:</TD>
    <TD class="labelmedium" style="height:25px">
  	   <input type="radio" class="radiol" name="ModeEffective" value="0" checked>Validate
	   <input type="radio" class="radiol" name="ModeEffective" value="1">Allow overlap
	   <input type="radio" class="radiol" name="ModeEffective" value="9">Disable Edit
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Workflow:</TD>
    <TD style="height:25px" class="labelmedium">
		<cfdiv id="divWorkflow" bind="url:EntityClass.cfm?ActionSource=#Src.ActionSource#&entityClass=">
    </TD>
	</TR>
	
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
  	   <input type="checkbox" class="radiol" name="Operational" value="1" checked>
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>
		
	<td align="center" colspan="2" height="40">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

