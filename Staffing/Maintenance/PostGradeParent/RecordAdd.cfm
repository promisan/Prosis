<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<cfquery name="Posttype"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostType
</cfquery>

<!--- Entry form --->

<table width="92%" align="center" class="formpadding formspacing">

    <tr><td height="6" colspan="2"></td></tr>
	
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a display description" required="Yes" size="30" maxlength="30" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Listing order:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="ViewOrder" value="0" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Show subtotal:</TD>
    <TD class="labelmedium">
  	   <input type="Radio" class="radiol" name="ViewTotal" value="1">Yes
	   <input type="Radio" class="radiol" name="ViewTotal" value="0" checked>No
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Posttype:</TD>
    <TD class="labelmedium">
	   <select name="PostType" class="regularxxl">
	   <cfloop query="PostType">
	   <cfoutput>
	   <option value="#PostType.PostType#">#PostType.Description#</option>
	   </cfoutput>
	   </cfloop>
	   </select>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Category:</TD>
    <TD class="labelmedium">
  	   <cfinput type="Text" name="Category" value="" message="Please enter a category" required="Yes" size="20" maxlength="20" class="regularxxl">
    </TD>
	</TR>

	
	<tr class="line"><td height="1" colspan="2"></td></tr>
		
	<tr>
		<td colspan="2" align="center">	
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    	<input class="button10g" type="submit" name="Insert" value=" Submit ">
		</td>
	</tr>
		
</table>



</CFFORM>
