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
			  banner="yellow" 
			  layout="webapp" 
			  label="Journal Action" 
			  option="Edit settings of the ledger action" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_Action
WHERE Code = '#URL.ID1#'
</cfquery>

<script language="JavaScript">

function ask()

{
	if (confirm("Do you want to remove this Action ?")) {
	
	return true 
	
	}
	
	return false
	
}	

</script>

<cf_dialogLedger>

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST"name="dialog">
<table width="95%" align="center" class="formpadding formspacing">
	
    <cfoutput>
	<tr><td></td></tr>
    <TR>
    <TD class="labelmedium2">Action:</TD>
    <TD>
  	   <input type="text"
       name="ActionCode"
       value="#get.Code#"
       size="10"
       maxlength="10"
       readonly	   
       class="regularxxl"
       style="text-align: center;background: ffffcf;">
    </TD>
	</TR>
					
	<TR>
    <TD class="labelmedium2">Description:</TD>
    <TD>
  	   <input type="text"
       name="Description"
       value="#get.Description#"
       size="50"
       maxlength="50"       	   
       class="regularxxl"
       style="text-align: left;background: ffffcf;">
  	  </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium2">Template:</TD>
    <TD>
  	   <input type="text"
       name="Template"
       value="#get.Template#"
       size="40"
       maxlength="40"       	   
       class="regularxxl"
       style="text-align: left;background: ffffcf;"
	   onblur="ptoken.navigate('CollectionTemplate.cfm?template='+this.value+'&container=indexTemplate&resultField=valIndexDataTemplate','indexTemplate')">
  	  </TD>
		 <td id="indexTemplate">
		    <cfinclude template="CollectionTemplate.cfm">		 	
		 </td>	  
	</TR>
		
	<TR>
    <TD class="labelmedium2">Listing Order:</TD>
    <TD>
  	   <input type="text"
       name="ListingOrder"
       value="#get.ListingOrder#"
       size="4"
       maxlength="2"     	   
       class="regularxxl"
       style="text-align: center;background: ffffcf;">
  	  </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Lead Days:</TD>
    <TD>
  	   <input type="text"
       name="LeadDays"
       value="#get.LeadDays#"
       size="4"
       maxlength="2" 
       class="regularxxl"
       style="text-align: center;background: ffffcf;">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Mail Body Text:</TD>
    <TD>
		<textarea id="BodyText" name="BodyText" style="padding:3px;font-size:14px;width:99%" rows="7" class="regular">#get.MailTextBody#</textarea>	 
	</TD>
	</TR>

	<TR>
    <TD class="labelmedium">Is Open:</TD>
    <TD>
		<select name="IsOpen" class="regularxl">     	   
        	<option value="1" <cfif get.IsOpen eq "1">Selected</cfif>>Yes</option>
			<option value="0" <cfif get.IsOpen eq "0">Selected</cfif>>No</option>
	    </select>	
	</TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Operational:</TD>
    <TD>
		<select name="Operational" class="regularxl">     	   
        	<option value="1" <cfif get.Operational eq "1">Selected</cfif>>Yes</option>
			<option value="0" <cfif get.Operational eq "0">Selected</cfif>>No</option>
	    </select>	
	</TD>
	</TR>		
	</cfoutput>
	
	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<tr><td colspan="2" align="center">
	
		<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
		<input class="button10g" type="submit" name="Delete" value="Delete" onclick="return ask()">
		<input class="button10g" type="submit" name="Update" value="Update">

	</td></tr>
	
</TABLE>
</CFFORM>

</BODY></HTML>