
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Task Order Class" 			  
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" enablecab="Yes" name="dialog">

	<table width="95%" align="center" class="formpadding formspacing">
	
		<tr><td height="6"></td></tr>
		
	    <TR class="labelmedium2">
	    <TD width="20%">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
	    </TD>
		</TR>
		
		 <TR class="labelmedium2">
	    <TD>Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium2">
	    <TD>Order:</TD>
	    <TD>
	  	   <cfinput type="Text" name="listingOrder" value="" message="Please enter a numeric listing order" required="Yes" size="1" validate="integer" maxlength="3" class="regularxxl" style="text-align:center;">
	    </TD>
		</TR>		
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>		
		<td align="center" colspan="2" height="30">
		    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">
		</td>	
		
		</tr>
		
	</table>

</CFFORM>

<cf_screenbottom layout="innerbox">
