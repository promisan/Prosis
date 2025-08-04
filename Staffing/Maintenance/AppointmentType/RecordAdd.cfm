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
		      label="Add" 
			  scroll="Yes" 
			  layout="webapp" banner="gray" 
			  menuAccess="Yes" systemfunctionid="#url.idmenu#">

<script>
	function hlMission(mis,cl) {
		var control = document.getElementById('mission_'+mis);
		if (control.checked) {
			document.getElementById('td_'+mis).style.backgroundColor = cl;
		}else{
			document.getElementById('td_'+mis).style.backgroundColor = '';
		}
	}
</script>
			  
<cfform action="RecordSubmit.cfm" method="POST" name="dialog">
	
	<!--- Entry form --->
	
	<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">
	
		<tr><td height="5"></td></tr>
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
	    </TD>
		</TR>
		
		<TR class="labelmedium">
    	<TD>Reference content:</TD>
	    <TD>
  		   <cfinput type="Text" name="MemoContent" message="Please enter a description" required="no" size="30" maxlength="50" class="regularxl">
	    </TD>
		</TR>
	
		
		<TR>
	    <TD class="labelmedium">List Ordering:</TD>
	    <TD>
	  	   <cfinput type="Text" name="ListingOrder" value="" message="Please enter a Listing Order" required="No" size="2" maxlength="2" class="regularxl">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" valign="top" style="height:25px;padding-top:5px;">Enabled:</TD>
		
	    <TD style="padding-left:5px;padding-right:10px">
			<cfdiv id="divMission" bind="url:RecordMission.cfm?code=">
	    </TD>
		</TR>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>		
		<td colspan="2" align="center" height="30">
			<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
	    	<input class="button10g" type="submit" name="Insert" value=" Submit ">	
		</td>		
		</tr>
		
	</TABLE>

</CFFORM>

</BODY></HTML>