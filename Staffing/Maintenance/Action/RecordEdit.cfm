
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Action" 
			  line="No"
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_Action
	WHERE 	ActionCode = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Action  ?")) {
		return true 	
	}	
	return false	
}	

</script>


<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- edit form --->

<table width="89%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

<tr><td height="8"></td></tr>

   <cfoutput>
	
	 <cfquery name="Src" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ActionSource		
	</cfquery>
	 
	<TR>
	 <TD width="150" class="labelmedium">Source:&nbsp;</TD>  
	 <TD>
	 	<select name="ActionSource" class="regularxl" onchange="javascript: ColdFusion.navigate('EntityClass.cfm?ActionSource='+this.value+'&entityClass=','divWorkflow');">
		<cfloop query="Src">
			<option value="#ActionSource#" <cfif get.actionSource eq ActionSource>selected</cfif>>#ActionSource#</option>
		</cfloop>
		</select>
	 </TD>
	</TR>
	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <input type="text" name="ActionCode" value="#get.ActionCode#" size="10" maxlength="10" class="regularxl">
	   <input type="hidden" name="ActionCodeOld" value="#get.ActionCode#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Action Effective Mode:</TD>
    <TD class="labelmedium" style="height:25px">
	   <table cellspacing="0" cellpadding="0">
	   <tr>
	   <td><input type="radio" class="radiol" name="ModeEffective" value="0" <cfif get.ModeEffective eq "0">checked</cfif>></td><td class="labelmedium">Validate</td>
	   <td style="padding-left:10px"><input type="radio" class="radiol" name="ModeEffective" value="1" <cfif get.ModeEffective eq "1">checked</cfif>></td><td class="labelmedium">Overlap</td>
	   <td style="padding-left:10px"><input type="radio" class="radiol" name="ModeEffective" value="9" <cfif get.ModeEffective eq "9">checked</cfif>></td><td class="labelmedium">Disable edit</td>
	   </tr>
	   </table>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Workflow:</TD>
    <TD class="labelmedium">
		<cfdiv id="divWorkflow" bind="url:EntityClass.cfm?ActionSource=#get.ActionSource#&entityClass=#get.EntityClass#">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
  	   <input type="checkbox" class="radiol" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>>
    </TD>
	</TR>
	
	<tr><td height="6" colspan="2" ></td></tr>
	
	<tr><td  colspan="2" class="linedotted"></td></tr>
	
	<tr><td height="6" colspan="2" ></td></tr>	

	<tr><td align="center" colspan="2">
	
	<input class="button10g" style="width:90px" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" style="width:90px" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" style="width:90px" type="submit" name="Update" value=" Update ">
	
	</td></tr>
		
	</cfoutput>
	
	
</TABLE>
	
</CFFORM>
