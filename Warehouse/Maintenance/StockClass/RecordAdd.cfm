<!--
    Copyright © 2025 Promisan

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
              scroll="Yes" 
			  layout="webapp" 
			  label="Stock Class" 
			  option="Add Stock Class"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cf_PreventCache>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?idmenu=#url.idmenu#" method="POST" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="10"></td></tr>

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="20" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Order:</TD>
    <TD class="labelit">
  	   
	    <cfinput type="text" 
	       name="ListingOrder" 
		   value="" 
		   message="please enter an integer order"  
		   validate="integer"
		   required="yes" 
		   size="2" 
	       maxlength="2" 
		   style="text-align:center;"
		   class="regularxl">
    </TD>
	</TR>
	
	<tr><td height="6"></td></tr>
	<tr><td colspan="2" class="line"></td></tr>
	<tr>
	<tr><td height="6"></td></tr>
	<tr>	
		
	<tr>
		
	<td colspan="2" align="center">
	<input class="button10g" type="button" name="Cancel" id="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" id="Insert" value="Save">	
	</td>	
	
	</tr>
	
</TABLE>

</CFFORM>

<cf_screenbottom layout="innerbox">