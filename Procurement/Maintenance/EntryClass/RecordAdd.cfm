<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Add Entry Class" 
			  scroll="Yes" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<CFFORM action="RecordSubmit.cfm?idmenu=#url.idmenu#&fmission=&id1=" method="post" enablecab="yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	  <tr><td height="8"></td></tr>
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10"
		class="labelmedium">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Description:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="30" maxlength="30"
		class="labelmedium">
	</TD>
	</TR>
	
	
	
	 <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium">Mode:</TD>
    <TD>
	   <table width="100%" cellspacing="0" cellpadding="0">
	   <tr class="labelmedium">
	   <td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Materials" checked>Warehouse/Asset to be received as Stock
		</td>
		</tr>
		<tr class="labelmedium">
		<td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Contract">Staffing Position to be funded
		</td>
		</tr>
		<tr class="labelmedium">
		<td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="Travel">Travel and/or SSA initiation
		</td>
		</tr>
		<tr class="labelmedium">
		<td>
		<input type="radio" class="radiol" name="CustomDialog" id="CustomDialog" value="">Other services and/or goods
		</td>
		</tr>
		</table>
	</TD>
	</TR>
	
	   <!--- Field: Listing Order --->
    <TR>
    <TD class="labelmedium">Listing Order:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="ListingOrder" value="" message="Please enter Listing Order" required="Yes" size="2" maxlength="2"
		class="labelmedium">
	</TD>
	</TR>
			
	
	 <!--- Field: Listing Order --->
    <TR class="labelmedium">
    <TD>Template:</TD>
    <TD>
  	  	<input type="Text" name="RequisitionTemplate" id="RequisitionTemplate" value="" message="Please enter a template name" size="40" maxlength="60" class="labelmedium">
				
    </TD>
	</TR>	
	
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>
	</tr>
	
</CFFORM>
	    
</TABLE>


<cf_screenbottom layout="innerbox">
