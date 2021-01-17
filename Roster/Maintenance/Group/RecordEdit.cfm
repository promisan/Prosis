<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Edit Group" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="Get" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Group
	WHERE  GroupCode = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this group?")) {	
	return true 	
	}	
	return false	
}	

function hl(act){
   	 	 
	 sel = document.getElementById("ShowInColor")	 	 
	 if (act == "hide") { 
	   sel.className = "Hide" ; 
	   sel.value = ""}
	 else { sel.className = "regular" ; }		
  }

</script>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- edit form --->

<table width="92%" align="center" class="formpadding formspacing">

    <cfoutput>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <input type="text" name="GroupCode" value="#get.GroupCode#" size="10" maxlength="10"class="regularxxl">
	   <input type="hidden" name="GroupCodeOld" value="#get.GroupCode#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
			
	<TR>
    <TD class="labelmedium2">Domain:</TD>
    <TD>
	   <select name="GroupDomain" class="regularxxl">
					<option value="Candidate" <cfif get.GroupDomain eq "Candidate">selected</cfif>>Candidate</option>
					<option value="Bucket" <cfif get.GroupDomain eq "Bucket">selected</cfif>>Roster bucket</option>
		</select>
     </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
    </TD>
	</TR>
			
	</cfoutput>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr>		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
    <input class="button10g" type="submit" name="Update" value=" Update ">
	</td>	
	</tr>	
	
</TABLE>

</CFFORM>


	
