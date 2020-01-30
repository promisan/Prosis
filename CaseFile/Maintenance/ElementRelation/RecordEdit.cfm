<cfparam name="url.idmenu" default="">

<cf_tl id="Edit Relation" var="1">

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
	SELECT  *
	FROM    Ref_ElementClass
	ORDER   BY Code,ListingOrder
</cfquery>

<cfquery name="ElementRelation" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ElementRelation
	WHERE Code = '#URL.ID1#'
</cfquery>
<cfoutput>

<cf_tl id = "Do you want to remove this record ?" class="Message" var ="1">

<script language="JavaScript">
function ask() {
	if (confirm("#lt_text#")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>
</cfoutput>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">


<!--- edit form --->


<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

	 <cfoutput>	 
	 
	<!--- Field: Code --->
	 <TR>
	 <TD class="labelit"><cf_tl id="Code">:&nbsp;</TD>  
	 <TD class="labelit" height="30">
	 	#ElementRelation.Code#
		<input type="hidden" name="Code" id="Code" value="#ElementRelation.Code#">
	 </TD>
	 </TR>
	 
	 <!--- Field: Element Class From --->
	 <TR>
	 <TD class="labelit"><cf_tl id="From">:&nbsp;</TD>  
	 <TD class="labelit">			
			<select name="ElementFrom" id="ElementFrom" class="regularxl">
			<cfloop query="ElementClass">
			  <option value="#Code#" <cfif ElementRelation.ElementClassFrom eq "#Code#">selected</cfif>>#Description#</option>
		  	</cfloop>
			</select>
	 </TD>
	 </TR>
	 
	 <!--- Field: Element Class To --->
	 <TR>
	 <TD class="labelit"><cf_tl id="To">:&nbsp;</TD>  
	 <TD class="labelit">			
			<select name="ElementTo" id="ElementTo" class="regularxl">
			<cfloop query="ElementClass">
			  <option value="#Code#" <cfif ElementRelation.ElementClassTo eq "#Code#">selected</cfif>>#Description#</option>
		  	</cfloop>
			</select>
	 </TD>
	 </TR>
	 
	 <!--- Field: Description --->
    <TR>
    <TD class="labelit"><cf_tl id="Description">:&nbsp;</TD>
    <TD class="labelit">
		<cf_tl id="Please enter a description" var = "1" class="Message">
  	  	<cfinput type="Text" name="Description" id="Description" value="#ElementRelation.Description#" message="#lt_text#" required="Yes" size="50" maxlength="50" class="regularxl">
				
    </TD>
	</TR>
	
    <!--- Field: Listing Order --->
    <TR>
    <TD class="labelit"><cf_tl id="Order">:&nbsp;</TD>
    <TD class="labelit">
		<cfoutput>
	 	  <cf_tl id="Please enter a listing order" var = "1" class="Message">
		  <cfinput type="Text" name="ListingOrder" id="ListingOrder" value="#ElementRelation.ListingOrder#" message="#lt_text#" required="Yes" size="2" maxlength="2" class="regularxl">
		</cfoutput>		
    </TD>
	</TR>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr>	
		<td align="center" colspan="2">
		<cf_tl id="Cancel" var = "1">
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">
		<cf_tl id="Delete" var = "1">
		<input class="button10g" type="submit" name="Delete" value=" #lt_text# " onclick="return ask()">
		<cf_tl id="Update" var = "1">		
		<input class="button10g" type="submit" name="Update" value=" #lt_text# ">
		</td>
	</tr>
	

</cfoutput>
    	
</TABLE>

</CFFORM>
