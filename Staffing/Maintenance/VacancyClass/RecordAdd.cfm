<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Vacancy Class" 
			  menuAccess="Yes" 
			  jQuery="Yes"
			  systemfunctionid="#url.idmenu#">

<cf_colorScript>			  
<!--- Entry form --->

<table width="100%"><tr><td style="padding-top:10px">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="90%" cellspacing="0" cellpadding="0" align="center">

    <TR style="height:33px">
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR style="height:33px">
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="25" maxlength="40"class="regularxl">
    </TD>
	</TR>
	
	<TR style="height:33px">
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a Listing Order" required="No" size="2" maxlength="2" class="regularxl">
    </TD>
	</TR>
	
	<TR style="height:33px">
    <TD class="labelmedium" style="PADDING-RIGHT:3PX">Presentation Color:</TD>
    <TD>
		<cf_color 	name  ="PresentationColor" 
					style ="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;"
					mode  ="limited">			
    </TD>
	</TR>

	<TR style="height:33px">
    <TD class="labelmedium">Trigger Track:</TD>
    <TD>
		<input type="checkbox" class="radiol"  name="TriggerTrack" value="1">
    </TD>
	</TR>
	
	<TR style="height:33px">	
    <TD class="labelmedium">Show Vacancy:</TD>
    <TD>
		<input type="checkbox" class="radiol" name="ShowVacancy" value="1" checked>
  	 </TD>
	</TR>

	<TR style="height:33px">	
    <TD class="labelmedium">Operational:</TD>
    <TD>
		<input type="checkbox" class="radiol" name="Operational" value="1">
  	 </TD>
	</TR>
	
	
	
	<tr><td height="3"></td></tr>
	<tr><td style="padding:0px" colspan="2" class="linedotted"></td></tr>
	<tr><td height="3"></td></tr>
	
	<tr>		
	<td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    	<input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>		
	</tr>
	
</TABLE>

</CFFORM>

</td></tr>
</table>

