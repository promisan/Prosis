<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Organization" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Function Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
	FROM Ref_FunctionClass
WHERE FunctionClass = '#URL.ID1#'
</cfquery>


<cfquery name="Owner" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
	FROM Ref_ParameterOwner
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this class?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

    <cfoutput>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <input type="text" name="FunctionClass" value="#get.FunctionClass#" size="20" maxlength="20"class="regularh">
	   <input type="hidden" name="FunctionClassOld" value="#get.FunctionClass#" size="20" maxlength="20" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Owner:</TD>
    <TD>
	   <select name="Owner">
	   <cfloop query="Owner">
	   <option value="#Owner#" <cfif get.Owner eq Owner>selected</cfif>>#Owner#</option>	   
	   </cfloop>
	   </select>
  	 </TD>
	</TR>
	
	</cfoutput>
	
	
	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>
	
	
	<tr>
	<td align="center" colspan="2" valign="bottom">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	</tr>
	
</TABLE>
	
</CFFORM>

	