<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Journal Action" 
			  option="Record a journal ledger action" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_dialogLedger>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td></td></tr>
    <TR>
    <TD class="labelmedium">Action:</TD>
    <TD>
  	   <cfinput class="regularxl" type="Text" name="ActionCode" value="" message="Please enter the Action Code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="Description" value="" message="Please enter the description of the Action" required="Yes" size="30" maxlength="50">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Template:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="Template" value="" message="Please enter the Template to be executed" required="Yes" size="40" maxlength="40"
			onblur="ColdFusion.navigate('CollectionTemplate.cfm?template='+this.value+'&container=indexTemplate&resultField=valIndexDataTemplate','indexTemplate')">
  	</TD>
	<td>
	 	<cfdiv id="indexTemplate" 
		   bind="url:CollectionTemplate.cfm">
	</td>	
	</TR>
		
	<TR>
    <TD class="labelmedium">Listing Order:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="ListingOrder" message="Please enter the listing order of the Action" validate="integer" required="No" size="4" maxlength="2" style="text-align: left;">
    </TD>
	</TR>
	
					
	<TR>
    <TD class="labelmedium">Lead Days:</TD>
    <TD>
  	    <cfinput class="regularxl" type="Text" name="LeadDays" message="Please enter the Lead Days" validate="integer" required="No" size="4" maxlength="4" style="text-align: left;">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Mail Body Text:</TD>
    <TD><textarea id="BodyText" name="BodyText" rows="5" cols="40" style="padding:3px;font-size:14px" class="regular"></textarea>
  	  </TD>
	</TR>
	<TR>
	<TD class="labelmedium">Is Open:</TD>
    <TD>
  	    <select name="IsOpen" class="regularxl">     	   
        	<option value="1">Yes</option>
			<option value="0">No</option>
	    </select>	
	</td>
	</tr>
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
		<select name="Operational" class="regularxl">     	   
        	<option value="1" selected>Yes</option>
			<option value="0" >No</option>
	    </select>	
	</TD>
	</TR>		
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td></tr>	
	
</TABLE>

	
</CFFORM>


</BODY></HTML>