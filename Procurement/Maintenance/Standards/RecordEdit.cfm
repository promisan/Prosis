<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Procurement Standard" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  banner="gray"
			  line="no"
			  systemfunctionid="#url.idmenu#">

 
<cfajaximport tags="cfdiv">
 
<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Standard
WHERE Code = '#URL.ID1#'
</cfquery>


<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

function maxlength(element, maxvalue)
{
     var q = eval("document.dialog."+element+".value.length");
     var r = q - maxvalue;
     var msg = "At maximum, you can enter "+maxvalue+" characters";

     if (q > maxvalue) 
	 {
		alert (msg);
	 	return false;
	}
	else
		return true;

}

</script>

<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog"  >

<!--- edit form --->

<table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
<!--- Field: code --->
	 <cfoutput>
	
	 <TR>
	 <TD class="labelit">Code:</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="#get.Code#" size="20" maxlength="20"class="regularxl">
		<input type="hidden" name="CodeOld" id="CodeOld" value="#get.Code#" size="20" maxlength="20"class="regularxl">
	 </TD>
	 </TR>	 
    
	 <!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="#get.Description#" message="Please enter a description" required="Yes" size="50" maxlength="100" class="regularxl">				
    </TD>
	</TR>	
    
	 <!--- Field: Reference --->
    <TR>
    <TD class="labelit">Reference:</TD>
    <TD>
  	  	<input type="Text" name="Reference" id="Reference" value="#get.Reference#" message="Please enter a Reference" required="Yes" size="20" maxlength="20" class="regularxl">				
    </TD>
	</TR>
	
	<cf_calendarscript>	

	 <!--- Field: Date Expiration --->
    <TR>
    <TD class="labelit">Expiration:&nbsp;</TD>
    <TD>
	   <cf_intelliCalendarDate9
	      FieldName="DateExpiration" 			 
		  class="regularxl"			  
	      Default="#Dateformat(get.DateExpiration, CLIENT.DateFormatShow)#">
    </TD>
	</TR>
		  	
	 <!--- Field: Memo --->
    <TR>
    <TD class="labelit">Scope:&nbsp;</TD>
    <TD>
		<textarea style="width:95%;padding:3px;font-size:14px" rows="4" class="regular" name="Memo">#get.Memo#</textarea>
    </TD>
	</TR>	
	
	
	<TR><td class="labelit">Operational:</b></td>
	    <TD>
			<input type="radio" name="Operational" id="Operational" <cfif get.Operational eq "1">checked</cfif> value="1">Yes
			<input type="radio" name="Operational" id="Operational" <cfif get.Operational eq "0">checked</cfif> value="0">No
	    </td>
    </tr>
		
	<TR><TD height="4"></TD></TR>	
	
	<tr><td class="labelit">Attachment:</td>
	<td>
			<cf_filelibraryN
					DocumentPath  = "Standards"
					SubDirectory  = "#URL.ID1#" 
					Filter        = ""						
					LoadScript    = "1"		
					EmbedGraphic  = "no"
					Width         = "100%"
					Box           = "mod"
					Insert        = "yes"
					Remove        = "yes">	
	
	</td>
	
	</tr>		
	
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="40">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" id="Delete" value=" Delete " onClick="return ask()">
		<input class="button10g" type="submit" name="Update" id="Update" value=" Update " onClick = "return maxlength('Memo',200);">
	</td></tr>
	
</cfoutput>
    	
</TABLE>

</CFFORM>
