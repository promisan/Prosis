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

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">

	<tr><td height="5"></td></tr>

    <TR>
    <TD class="labelmedium">&nbsp;&nbsp;Code:</TD>
    <TD>
  	   <cfinput type="Text" name="PostClass" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="23" maxlength="40" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Grouping:</TD>
    <TD>
  	   <cfinput type="Text" name="PostClassGroup" value="" message="Please enter a Post Class Group" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD 
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Presentation Color:</TD>
    <TD>
		<cf_color 	name="PresentationColor" 
			style="cursor: pointer; font-size: 0; border: 1px solid gray; height: 20; width: 20; ime-mode: disabled; layout-flow: vertical-ideographic;">   				     
    </TD>
	</TR>

	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Access Level:</TD>
    <TD>
		<cfoutput>
		<select name="AccessLevel" id="AccessLevel" class="regularxl">
			<cfloop index = "LoopCount" from = "1" to= "5">
				  <option value="#LoopCount#">#LoopCount#</option>
			</cfloop>
		</select>	
		</cfoutput>
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">&nbsp;&nbsp;Order:</TD>
    <TD>
  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a Listing Order" required="No" size="2" maxlength="2"class="regularxl">
    </TD>
	</TR>
	
	<TR>	
    <TD class="labelmedium">&nbsp;&nbsp;Operational:</TD>
    <TD>
		<input type="checkbox" class="radiol" name="Operational" value="1">
  	 </TD>
	</TR>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>		
	<td colspan="2" align="center" height="30">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
    	<input class="button10g" type="submit" name="Insert" value=" Submit ">	
	</td>		
	</tr>
	
</TABLE>

</CFFORM>
