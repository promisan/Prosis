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

<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Snapshot S, Ref_AllotmentEdition R
	WHERE  S.EditionId = R.EditionId
	AND    S.SnapshotBatchId = '#URL.ID#'
</cfquery>

<script language="JavaScript">

function ask() {
	if (confirm("Are you sure. This action can not be reversed?")) {
		return true 	
	}	
	return false	
}	

</script>

<cf_screentop height="100%" 
			  scroll="Yes" 
			  label="Edit snapshot" 
			  layout="webapp" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm?snapshotbatchid=#get.snapshotBatchid#" method="POST" name="dialog">
	
<table width="93%" cellspacing="0" cellpadding="0" align="center" class="formspacing formpadding">

	<tr><td></td></tr>
	
	<cfoutput>
    <TR>
    <TD height="20" class="labelmedium"><cf_tl id="Date">:</TD>
    <TD class="labelmedium">
  	   #dateformat(get.snapshotdate,CLIENT.DateFormatShow)#
    </TD>
	</TR>
	</cfoutput>
	
	<TR>
    <TD class="labelmedium" height="20"><cf_tl id="Entity">:</TD>
    <TD class="labelmedium">
		<cfoutput>
			#get.mission#
		</cfoutput>		
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" height="20"><cf_tl id="Period">:</TD>
	<TD class="labelmedium">
	    <cfoutput>
			#get.period#
		</cfoutput>		
	</TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" height="20"><cf_tl id="Edition">:</TD>
    <TD class="labelmedium">
		<cfoutput>
			#get.description#
		</cfoutput>		
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelmedium"><cf_tl id="Memo">:</TD>
    <TD class="labelmedium">
		   <cfinput type="text" name="Memo" value="#get.Memo#" message="please enter a description" size="30" maxlenght= "90" class= "regularxl">
    </TD>
	</TR>	
	
	<tr><td></td></tr>
		
	<tr><td colspan="2"  class="line"></td></tr>	
	
	<tr>	
		<td colspan="2" align="center" height="33">
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
	    <input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
    	<input class="button10g" type="submit" name="Update" value="Update">
		</td>	
	</tr>
	
</TABLE>
	
</CFFORM>
