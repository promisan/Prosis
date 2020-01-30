
<cfparam name="url.idmenu" default="">

<cf_tl id="Add Relationship" var="1">
<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="#lt_text#" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">



<cfquery name="ElementClass" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM  Ref_ElementClass
ORDER BY Code,ListingOrder
</cfquery>
 
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->


<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">	 
	 
   <!--- Field: Code --->
    <TR>
    <TD class="labelit"><cf_tl id="Code">:</TD>
    <TD class="labelit">
		<cfoutput>
		<cf_tl id="Please enter an element code" var = "1" class="Message">
		<cfinput type="Text" name="Code" id="Code" value="" message="#lt_text#" required="Yes" size="10" maxlength="10"
		class="regularxl">
		</cfoutput>
	</TD>
	</TR>	
	
	<tr><td height="3"></td></tr>
	
	<TR>
	 <TD class="labelit"><cf_tl id="From">:&nbsp;</TD>  
	 <TD class="labelit">
			<select name="ElementFrom" id="ElementFrom" class="regularxl">
			<cfoutput query="ElementClass">
			  <option value="#Code#">#Description#</option>
		  	</cfoutput>
			</select>
	 </TD>
	 </TR>

	<tr><td height="3"></td></tr>
	
	<TR>
	 <TD class="labelit"><cf_tl id="To">:&nbsp;</TD>  
	 <TD class="labelit">
			<select name="ElementTo" id="ElementTo" class="regularxl">
			  	<cfoutput query="ElementClass">
				  <option value="#Code#">#Description#</option>
			  	</cfoutput>
			</select>
	 </TD>
	 </TR>	
	   <!--- Field: Description --->
    <TR>
    <TD class="labelit"><cf_tl id="Description">:</TD>
    <TD class="labelit">
		<cfoutput>
		<cf_tl id="Please enter a description" var = "1" class="Message">
		<cfinput type="Text" name="Description" id="Description" value="" message="#lt_text#" required="Yes" size="50" maxlength="50"
		class="regularxl">
		</cfoutput>
	</TD>
	</TR>
	
	   <!--- Field: Listing Order --->
    <TR>
    <TD class="labelit"><cf_tl id="Listing Order">:</TD>
    <TD class="labelit">
		<cf_tl id="Please enter a listing order" var = "1" class="Message">
		<cfoutput>
		<cfinput type="Text" name="ListingOrder" id="ListingOrder" value="" message="#lt_text#" required="Yes" size="2" maxlength="2"
		class="regularxl">
		</cfoutput>
	</TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr>		
		<td align="center" colspan="2">
		<cfoutput>
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Insert" var = "1">
		<input class="button10g" type="submit" name="Insert" value=" #lt_text# ">
		</cfoutput>
		</td>
		
	</tr>
    
</TABLE>

	


</CFFORM>

</BODY></HTML>