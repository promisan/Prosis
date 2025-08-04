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
			  label="Add" 
			  layout="webapp"  
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<table width="94%" align="center" class="formpadding formspacing">

     <tr><td height="8"></td></tr>
	
   <!--- Field: Id --->
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="code" value="" message="Please enter a code" required="Yes" size="3" maxlength="3"
		class="regularxxl">
	</TD>
	</TR>
		
	   <!--- Field: Description --->
    <TR>
    <TD class="labelmedium2">Description:</TD>
    <TD class="labelmedium">
		<cfinput type="Text" name="name" value="" message="Please enter a description" required="Yes" size="20" maxlength="25"
		class="regularxl">
	</TD>
	</TR>
	
    <TR>
    <TD class="labelmedium">Iso Code (3 chars):</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="isocode" id="isocode" value="" message="Please enter a Iso 3 chars" required="No" size="3" maxlength="3" class="regularxxl">
				
    </TD>
	</TR>

    <TR>
    <TD class="labelmedium">Iso Code (2 chars):</TD>
    <TD class="labelmedium">
  	  	<input type="Text" name="isocode2" id="isocode2" value="" message="Please enter a Iso 2 chars" required="No" size="2" maxlength="2" class="regularxxl">
				
    </TD>
	</TR>
		
	<!--- Field: Description --->
    <TR>
    <TD class="labelmedium">Operational:</TD>
    <TD class="labelmedium">
	  <input class="radiol" type="radio" name="Operational" id="Operational" value="1" checked>Yes
	  <input class="radiol" type="radio" name="Operational" id="Operational" value="0">No
	</TD>
	</TR>
	
	<cf_dialogBottom option="add">
	    
</TABLE>

</CFFORM>
