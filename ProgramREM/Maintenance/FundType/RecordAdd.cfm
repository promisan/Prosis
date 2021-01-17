<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="92%" align="center" class="formpadding formspacing">

    
    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Name:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a name" required="Yes" size="20" maxlength="50" class="regularxxl">
    </TD>
	</TR>
		
	<TR class="labelmedium2">
    <TD>Listing Order:</TD>
    <TD>
  	   <cfinput type="Text"
	       name="ListingOrder"
	       message="Please enter a valid order"
	       validate="integer"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="2"
	       class="regularxxl">
	  
    </TD>
	</TR>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>		
	<td colspan="2" height="35" align="center">
		
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value=" Submit ">
	
	</td>	
	</tr>
	
</TABLE>

</CFFORM>


