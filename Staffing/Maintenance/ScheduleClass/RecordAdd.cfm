<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gray"
			  label="Add Post Class" 
			  menuAccess="Yes" 
			  jQuery = "Yes"
			  line="no"
			  systemfunctionid="#url.idmenu#">
			  

<cf_colorScript>			  
			  
<!--- Entry form --->

<table width="95%" align="center" class="formpadding formspacing">

<cfform action="RecordSubmit.cfm" method="POST"  name="dialog">

	<tr><td height="5"></td></tr>

    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="23" maxlength="50" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Order:</TD>
    <TD>
  	   <cfinput type="Text" style="text-align:center" name="ListingOrder" value="" message="Please enter a valid Listing Order" required="No" size="2" maxlength="2" range="0,999" class="regularxxl">
    </TD>
	</TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>		
	<td colspan="2" align="center" height="30">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    	<input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>		
	</tr>

</CFFORM>

	
</TABLE>



