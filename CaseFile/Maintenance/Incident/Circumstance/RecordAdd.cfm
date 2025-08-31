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

<cf_tl id="Add Circumstance" var = "1">

<cf_screentop height="100%" 
              scroll="Yes" 
			  layout="webapp" 
			  title="#lt_text#" 
			  label="#lt_text#" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cfoutput>
<CFFORM action="RecordSubmit.cfm" method="post" enablecab="yes" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding formspacing">

   <!--- Field: Id --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Code">:</TD>
    <TD>
		<cf_tl id="Please enter a code" class="Message" var = "1">
		<cfinput type="Text" name="Code" id="Code" value="" message="#lt_text#" required="Yes" size="20" maxlength="20"
		class="regularxxl">
	</TD>
	</TR>
	
	   <!--- Field: Description --->
    <TR class="labelmedium2">
    <TD><cf_tl id="Description">:</TD>
    <TD>
		<cf_tl id="Please enter a description" class="Message" var = "1">
		<cfinput type="Text" name="Description" id="Description" value="" message="#lt_text#" required="Yes" size="50" maxlength="50"
		class="regularxxl">
	</TD>
	</TR>
	

	<tr><td colspan="2" class="line"></td></tr>
	
	<tr>	
		<td colspan="2" align="center">
		<cf_tl id="Cancel" var = "1" >
		<input class="button10g" type="button" name="Cancel" value=" #lt_text# " onClick="window.close()">

		<cf_tl id="Submit" var = "1" >		
		<input class="button10g" type="submit" name="Insert" value=" #lt_text# ">
		</td>
	</tr>

    
</TABLE>


</CFFORM>
</cfoutput> 