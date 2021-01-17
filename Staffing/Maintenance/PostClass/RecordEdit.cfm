<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 			  
			  menuAccess="Yes" 
			  banner="gray"
			  jQuery="yes"
			  line="No"
			  systemfunctionid="#url.idmenu#">
			  
<cf_colorScript>			  
  
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_PostClass
WHERE PostClass = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this Post Class ?")) {
		return true 
	}
	return false	
}	

</script>

<!--- edit form --->

<cfform action="RecordSubmit.cfm" method="POST"  name="dialog">

<table width="92%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

    <tr><td></td></tr>
    <cfoutput>
    <TR>
    <TD class="labelmedium" width="120">&nbsp;&nbsp;Code:</TD>
    <TD>
  	   <input type="text" name="PostClass" value="#get.PostClass#" size="10" maxlength="10" class="regularxxl">
	   <input type="hidden" name="PostClassOld" value="#get.PostClass#" size="10" maxlength="10" readonly>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="#get.description#" message="Please enter a description" required="Yes" size="23" maxlength="40"class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Grouping:</TD>
    <TD>
  	   <cfinput type="Text" name="PostClassGroup" value="#get.PostClassGroup#" message="Please enter a Post Class Group" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Presentation Color:</TD>
    <TD>
	
		<cf_color 	name="PresentationColor" 
					value="#get.PresentationColor#"
					style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">					
		
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Access Level:</TD>
    <TD>
		
		<select name="AccessLevel" id="AccessLevel" class="regularxxl">
			<cfloop index = "LoopCount" from = "1" to= "5">
				  <option value="#LoopCount#" <cfif get.AccessLevel eq LoopCount>selected</cfif>>#LoopCount#</option>
			</cfloop>
		</select>	
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="#get.ListingOrder#" message="Please enter a Listing Order" required="No" size="2" maxlength="2" class="regularxxl">
    </TD>
	</TR>
	
	<TR>	
    <TD class="labelmedium">&nbsp;&nbsp;Operational:</TD>
    <TD>
		<input type="checkbox" class="radiol" name="Operational" value="1" <cfif get.operational eq "1">checked</cfif>>
  	 </TD>
	</TR>
	
	</cfoutput>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>
		
		<td align="center" colspan="2">
		<input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()">
	    <input class="button10g" type="submit" name="Update" value=" Update ">
		</td>	
	
	</tr>

</CFFORM>
	
</TABLE>
	

