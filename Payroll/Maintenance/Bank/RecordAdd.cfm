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
			  scroll="Yes" 
			  layout="webapp" 
			  title="Bank" 
			  label="Add Bank" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Currency"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Currency
</cfquery>

<cf_dialogLedger>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="92%" align="center" class="formpadding formspacing">

    <tr><td style="height:10px"></td></tr>
    <TR>
    <TD class="labelmedium2">Code:</TD>
    <TD>
  	   <cfinput type="Text" class="regularxxl" name="Code" value="" message="Please enter the bank acronym" required="Yes" size="20" maxlength="20">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Name:</TD>
    <TD>
   	   <cfinput type="Text" class="regularxxl" name="Description" value="" message="Please enter the bank acronym" required="Yes" size="40" maxlength="50">

    </TD>
	</TR>
		
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Save ">
	</td></tr>
	
	
</TABLE>
	
</CFFORM>
