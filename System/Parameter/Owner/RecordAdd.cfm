<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
	  label="Add" 
	  html="Yes" 			 
	  line="No"
	  layout="webapp">
	
<cfform action="RecordSubmit.cfm" method="POST"  name="dialog" menuAccess="Yes" systemfunctionid="#url.idmenu#">

	<!--- Entry form --->
	
	<table width="90%" align="center" class="formpadding formspacing">
	
		<tr><td height="5"></td></tr>
	
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"class="regularxl">
	    </TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="40"class="regularxl">
	    </TD>
		</TR>
				
		<TR>
	    <TD class="labelmedium">eMail : </TD>
	    <TD>
	  	   <cfinput type="Text" validate="email" name="emailaddress" value="" message="Please enter a valid email address" required="Yes" size="30" maxlength="40" class="regularxl">
		   
	    </TD>
		</TR>
		
		<tr><td></td></tr>
			
		<cf_dialogBottom option="add">
			
	</table>

</cfform>

<cf_screenbottom layout="webapp">

