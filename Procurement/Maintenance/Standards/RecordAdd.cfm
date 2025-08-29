<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Procurement Standard" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<script language="JavaScript">

function maxlength(element, maxvalue) {
     var q = eval("document.dialog."+element+".value.length");
     var r = q - maxvalue;
     var msg = "At maximum, you can enter "+maxvalue+" characters";
     if (q > maxvalue) {
		alert (msg);
	 	return false;
	} else
		return true;
}

</script>

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- edit form --->

<table width="92%" align="center" class="formpadding formpadding">
<!--- Field: code --->
	 <cfoutput>
	 <tr><td height="7"></td></tr>
	 <TR class="labelmedium2">
	 <TD>Code:&nbsp;</TD>  
	 <TD>
	 	<input type="Text" name="Code" id="Code" value="" size="20" maxlength="20"class="regularxxl">
	 </TD>
	 </TR>
		
    <TR class="labelmedium2">
    <TD>Description:&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="Description" id="Description" value="" message="Please enter a description" required="Yes" size="50" maxlength="100" class="regularxxl">				
    </TD>
	</TR>
	 
    <TR class="labelmedium2">
    <TD>Reference:&nbsp;</TD>
    <TD>
  	  	<input type="Text" name="Reference" id="Reference" value="" message="Please enter a Reference" required="Yes" size="20" maxlength="20" class="regularxxl">				
    </TD>
	</TR>
	
	<cf_calendarscript>
	   
	 <!--- Field: Date Expiration --->
    <TR class="labelmedium2">
    <TD>Date Expiration:&nbsp;</TD>
    <TD>
	   <cf_intelliCalendarDate9
	      FieldName="DateExpiration" 			 
		  class="regularxxl"			  
	      Default="#Dateformat(now(), CLIENT.DateFormatShow)#">
    </TD>
	</TR>
    
	 <!--- Field: Memo --->
    <TR class="labelmedium2">
    <TD>Scope:&nbsp;</TD>
    <TD>
		<textarea style="width:95%;padding:3px;font-size:14px" rows="3" class="regular" name="Memo"></textarea>
    </TD>
	</TR>				
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center" height="40">
		<input class="button10g" type="button" name="Cancel" id="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit " onClick = "return maxlength('Memo',200);">
	</td></tr>
	
</cfoutput>
    	
</TABLE>

</CFFORM>