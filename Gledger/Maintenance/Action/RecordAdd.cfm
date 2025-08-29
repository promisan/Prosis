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
			  label="Journal Action" 
			  option="Record a journal ledger action" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cf_dialogLedger>

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <tr><td></td></tr>
    <TR>
    <TD class="labelmedium2">Action:</TD>
    <TD>
  	   <cfinput class="regularxxl" type="Text" name="ActionCode" value="" message="Please enter the Action Code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	    <cfinput class="regularxxl" type="Text" name="Description" value="" message="Please enter the description of the Action" required="Yes" size="30" maxlength="50">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Template:</TD>
    <TD>
  	    <cfinput class="regularxxl" type="Text" name="Template" value="" message="Please enter the Template to be executed" required="Yes" size="40" maxlength="40"
			onblur="ptoken.navigate('CollectionTemplate.cfm?template='+this.value+'&container=indexTemplate&resultField=valIndexDataTemplate','indexTemplate')">
  	</TD>
	<td id="indexTemplate"><cfinclude template="CollectionTemplate.cfm"></td>	
	</TR>
		
	<TR>
    <TD class="labelmedium2">Listing Order:</TD>
    <TD>
  	    <cfinput class="regularxxl" type="Text" name="ListingOrder" message="Please enter the listing order of the Action" validate="integer" required="No" size="4" maxlength="2" style="text-align: left;">
    </TD>
	</TR>
	
					
	<TR>
    <TD class="labelmedium2">Lead Days:</TD>
    <TD>
  	    <cfinput class="regularxxl" type="Text" name="LeadDays" message="Please enter the Lead Days" validate="integer" required="No" size="4" maxlength="4" style="text-align: left;">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Mail Body Text:</TD>
    <TD><textarea id="BodyText" name="BodyText" rows="5" cols="40" style="padding:3px;font-size:14px" class="regular"></textarea>
  	  </TD>
	</TR>
	<TR>
	<TD class="labelmedium2">Is Open:</TD>
    <TD>
  	    <select name="IsOpen" class="regularxxl">     	   
        	<option value="1">Yes</option>
			<option value="0">No</option>
	    </select>	
	</td>
	</tr>
	<TR>
    <TD class="labelmedium2">Operational:</TD>
    <TD>
		<select name="Operational" class="regularxxl">     	   
        	<option value="1" selected>Yes</option>
			<option value="0" >No</option>
	    </select>	
	</TD>
	</TR>		
	
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr><td colspan="2" align="center">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
	</td></tr>	
	
</TABLE>

	
</CFFORM>


</BODY></HTML>