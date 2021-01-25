<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Settlement" 
			  option="Add Settlement"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

<table width="92%" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Mode:</TD>
    <TD class="labelmedium">
  	   <cfselect name="mode" id="mode" required="No" class="regularxxl">
	   		<option value="">
			<option value="Cash">Cash
			<option value="Credit">Credit
			<option value="Gif">Gif
	   </cfselect>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Operational:</TD>
    <TD class="labelmedium">
	   <input type="radio" class="radiol" name="Operational" value="1" checked> Yes&nbsp;
 	   <input type="radio" class="radiol" name="Operational" value="0" > No
    </TD>
	</TR>
		
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td height="6"></td></tr>
			
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="  Save  ">	
	</td>	
	
	</tr>
	
	</CFFORM>
	
</TABLE>

<cf_screenbottom layout="innerbox">