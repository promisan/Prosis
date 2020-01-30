<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Add" 
			  layout="webapp"  
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="94%" align="center">

     <tr><td height="8"></td></tr>
	
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="code" value="" message="Please enter a code" required="Yes" size="3" maxlength="3"
		class="regularxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="name" value="" message="Please enter a description" required="Yes" size="20" maxlength="25"
		class="regularxl">
	</TD>
	</TR>
	
	<tr><td height="3"></td></tr>
	
    <TR>
    <TD class="labelmedium">Iso Code (3 chars):</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="isocode" id="isocode" value="" message="Please enter a Iso 3 chars" required="No" size="3" maxlength="3" class="regularxl">
				
    </TD>
	</TR>

	<tr><td height="3"></td></tr>

    <TR>
    <TD class="labelmedium">Iso Code (2 chars):</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="isocode2" id="isocode2" value="" message="Please enter a Iso 2 chars" required="No" size="2" maxlength="2" class="regularxl">
				
    </TD>
	</TR>
	
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Class:</TD>
    <TD class="labelmedium">
	  <input class="radiol" type="radio" name="Operational" id="Operational" value="1" checked>Yes
	  <input class="radiol" type="radio" name="Operational" id="Operational" value="0">No
	</TD>
	</TR>
	
	<cf_dialogBottom option="add">
	    
</TABLE>

</CFFORM>
