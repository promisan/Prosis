<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  title="Organization" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Function Class" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfquery name="Owner" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
	FROM Ref_ParameterOwner
</cfquery>

    <tr><td height="10"></td></tr>
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="FunctionClass" id="FunctionClass" value="" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularh">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Owner:</TD>
    <TD>
	   <select name="Owner" id="Owner">
	   <cfoutput query="Owner">
	   <option value="#Owner#">#Owner#</option>	   
	   </cfoutput>
	   </select>
  	 </TD>
	</TR>

	<tr><td colspan="2" height="6"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" height="6"></td></tr>	
	
	<tr>	
	<td align="center" colspan="2"  valign="bottom">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td>	
	</tr>
	
</TABLE>

</CFFORM>

