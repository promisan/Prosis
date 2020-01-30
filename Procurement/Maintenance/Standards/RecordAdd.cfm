<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Procurement Standard" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script language="JavaScript">


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
	 <tr><td height="7"></td></tr>
	 <TR>
	 <TD class="labelit">Code:&nbsp;</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="" size="20" maxlength="20"class="regularxl">
	 </TD>
	 </TR>
		
    <TR>
    <TD class="labelit">Description:&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="50" maxlength="100" class="regularxl">				
    </TD>
	</TR>
	 
    <TR>
    <TD class="labelit">Reference:&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="Reference" id="Reference" value="" message="Please enter a Reference" required="Yes" size="20" maxlength="20" class="regularxl">				
    </TD>
	</TR>
	
	<cf_calendarscript>
	   
	 <!--- Field: Date Expiration --->
    <TR>
    <TD class="labelit">Date Expiration:&nbsp;</TD>
    <TD>
	   <cf_intelliCalendarDate9
	      FieldName="DateExpiration" 			 
		  class="regularxl"			  
	      Default="#Dateformat(now(), CLIENT.DateFormatShow)#">
    </TD>
	</TR>
    
	 <!--- Field: Memo --->
    <TR>
    <TD class="labelit">Scope:&nbsp;</TD>
    <TD>
		<textarea style="width:95%;padding:3px;font-size:14px" rows="3" class="regular" name="Memo"></textarea>
    </TD>
	</TR>				
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="40">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
	<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit " onClick = "return maxlength('Memo',200);">
	</td></tr>
	
</cfoutput>
    	
</TABLE>

</CFFORM>