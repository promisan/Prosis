<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  label="Price Schedule" 
			  option="Add Price Schedule"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="20" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Acronym:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="Acronym" 
		   value="" 
		   message="Please enter an acronym" 
		   requerided="no" 
		   size="10" 
	       maxlength="10" 
		   class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="" 
		   message="Please enter a numeric order" 
		   validate="integer"
		   requerided="yes" 
		   size="2" 
	       maxlength="3" 
		   class="regularxl" 
		   style="text-align:center;">
    </TD>
	</TR>
	
	<!--- Field: FieldDefault --->
    <TR>
    <TD class="labelit">Default Schedule:&nbsp;</TD>
    <TD class="labelit">
  	  	<input type="Checkbox" class="radiol" name="FieldDefault" id="FieldDefault">
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">