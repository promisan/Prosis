
<cfparam name="url.idmenu" default="">
 
<cf_screentop height="100%" scroll="Yes" label="Edit" layout="webapp"  menuAccess="Yes" systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AccountGroup 
	WHERE AccountGroup = '#URL.ID1#'
</cfquery>

<cfquery name="All" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM    Ref_AccountGroup 
</cfquery>

<script>
function recordedit(id1) {
          window.open("RecordEdit.cfm?ID1=" + id1, "Edit", "left=80, top=80, width= 350, height= 200, toolbar=no, status=no, scrollbars=no, resizable=no");
}
</script>

<cfform action="GroupSubmit.cfm" method="POST" enablecab="Yes" name="edit">

<!--- Entry form --->

<table width="95%" align="center">

	<tr>
		<td colspan="2" height="10"></td>
	</tr>

     <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Code</TD>
    <TD><select name="acc" id="acc" class="regularxl" onChange="javascript:recordedit(this.value)">
	    <cfoutput query="all">
		<option value="#AccountGroup#" <cfif #AccountGroup# eq #Get.AccountGroup#>selected</cfif>>#AccountGroup#</option>
		</cfoutput>
		</select>
    </TD>
	</TR>
	
	<tr><td height="4"></td></tr>
  
    <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Name:</TD>
    <TD>
  	    <cfoutput query="get">
		<input type="hidden" name="AccountGroup" id="AccountGroup" value="#AccountGroup#">
		<cfinput class="regularxl" type="Text" name="Description" value="#Description#" message="Please enter a description" required="No" size="30" maxlength="50">
		</cfoutput>
    </TD>
	</TR>
	
	<tr><td height="2"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Interface:&nbsp;</TD>
    <TD style="height:25px" class="labelmedium"><input type="radio" name="UserInterface" id="UserInterface" value="HTML" <cfif #get.UserInterface# eq "HTML">checked</cfif>>HTML
	    <input type="radio" name="UserInterface" id="UserInterface" value="Optional" <cfif #get.UserInterface# neq "HTML">checked</cfif>>Optional
	</TD>
	</TR>
	<tr><td height="3"></td></tr>
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2">
	<table width="100%"><tr><td class="labelmedium">
	<cfoutput>Last update: <b>#dateformat(Get.Created,CLIENT.DateFormatShow)#</b></cfoutput></td>
    <td align="right">
	   <table><tr><td>
		<input type="button" class="button10g" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
		</td>
		<td>
		<input type="submit" class="button10g" name="Update" id="Update" value="Update">
		</td></tr></table>
	</td>	
	</tr>
	</TABLE>
	</td>
</tr>
	
</CFFORM>
