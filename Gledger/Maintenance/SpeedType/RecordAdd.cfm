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
			  label="Transaction Entry Setting" 
			  menuAccess="Yes" 
			  line="No"
			  systemfunctionid="#url.idmenu#">
  
<cfquery name="TaxAccount"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_Speedtype	
</cfquery>

<cfquery name="Parent"
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AccountParent		
</cfquery>

<cfoutput>

<!--- Entry form --->
<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">
	<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
		 <tr><td height="5"></td></tr>
		 
	
	    <TR>
	    <TD class="labelmedium">Code:</TD>
	    <TD>
	  	   <cfinput type="Text" class="regularxxl" name="Speedtype" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium">Description:</TD>
	    <TD>
	  	    <cfinput type="Text" class="regularxxl" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50">
	    </TD>
		</TR>
		
		
		<tr><td height="5"></td></tr>
		<tr><td class="labelmedium"><b>Header Settings</td></tr>
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
			
		<TR>
	    <td class="labelmedium" style="cursor: pointer;padding-left:10px"><cf_UItooltip  tooltip="Preset Contact selection, if left blank user may select any relation">Relation:</cf_UItooltip></td>
	    <TD> 
			
			<cfquery name="Mission" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		    	SELECT *  
			    FROM   Ref_Mission
				WHERE  MissionStatus = '1' <!--- not dynamic --->
			</cfquery>
			    	
	    	<select name="InstitutionTree" size="1" class="regularxxl">		   
				<option value="">Any</option>
				<option value="Staff">Staff</option>
				<option value="Customer">Customer</option>
			    <cfloop query="Mission">
					<option value="#Mission#">
			    		#Mission#
					</option>
				</cfloop>
		    </select>
		
	    </TD>
		</TR>
				 
		<cfquery name="Custom"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
			FROM   Ref_Topic	L	
			WHERE  Operational = 1
		</cfquery>
		
		<tr>
		<td class="labelmedium" valign="top" style="padding-top:2px;cursor: pointer;padding-left:10px">
			<cf_UItooltip  tooltip="Transaction custom field entry.<br>Fields are declared under Maintenance : Custom Fields">Custom Fields:</cf_UItooltip></td>
		<td>
		
			<table cellspacing="0" cellpadding="0">
				<cfset row = 0>
				<cfloop query="Custom">
					<cfset row = row+1>
					<cfif row eq "1"><tr><cfelse><td>&nbsp;</td></cfif>				
					<td class="labelmedium" style="padding-right:3px">#Code#.</td>
					<td class="labelmedium" style="padding-right:5px">#Description#</td>
					<td style="padding-right:5px"><input type="checkbox" class="radiol" name="CustomSelect" value="#Code#"></td>
					<cfif row eq "2"></tr><cfset row = 0></cfif>
				</cfloop>
			</table>
			  
	    </TD>
		</TR>
		
		<tr><td height="5"></td></tr>
		<tr><td colspan="2" class="labelmedium"><b>Line Settings</td></tr>
		<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		      	
		<TR>
	    <TD class="labelmedium" valign="top" style="pading-top:2px;padding-left:10px">Account Selection Limited to:</TD>
	    <TD>
		
			<table cellspacing="0" cellpadding="0">
			<cfset row = 0>
			<cfloop query="Parent">
			<cfset row = row+1>
			<cfif row eq "1"><tr><cfelse><td>&nbsp;</td></cfif>				
			<td class="labelmedium" style="padding-right:3px">#AccountParent#</td>
			<td class="labelmedium" style="padding-right:3px">#Description#</td>
			<td style="padding-right:5px"><input type="checkbox" class="radiol" name="ParentSelect" value="#AccountParent#"></td>
			<cfif row eq "2"></tr><cfset row = 0></cfif>
			</cfloop>
			</table>
						  
	    </TD>
		</TR>
			
		<TR>
	    <TD class="labelmedium" style="padding-left:10px">Cost Center:</TD>
	    <TD>
		  	 
	  	   <select name="CostCenter" size"1" class="regularxxl">
	          <option value="1" selected>Show</option>
			  <option value="0">Hide</option>
		   </select>
		   
	    </TD>
		</TR>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:10px;">External Program:</TD>
	    <TD>
		  	 
	  	   <select name="ExternalProgram" size"1" class="regularxxl">
	          <option value="1">Enabled</option>
			  <option value="0" selected>Hide</option>
		   </select>
		   
	    </TD>
		</TR>
		
		
		<cfquery name="Tax"
		datasource="AppsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
		FROM Ref_Tax	
		
		</cfquery>
		
		<TR>
	    <TD class="labelmedium" style="padding-left:10px">Tax Code:</TD>
	    <TD>
			  <table cellspacing="0" cellpadding="0">
			  <tr>
			  <td>
			
				 <select name="TaxCodeMode" size"1" class="regularxxl">
			          <option value="1" selected>Show</option>
					  <option value="0">Hide</option>
				   </select>
				   
			  </td>
			
		      <td style="padding-left:4px" id="taxcodebox" class="regular">
		   
			   	<select name="TaxCode" size"1" class="regularxxl">
	    	       <cfloop query="Tax">
				    <option value="#taxcode#">#Description#</option>
				   </cfloop>
			   </select>	   
		   
		   	</td>
		   
		   	</tr>
		   
		   </table>	   
	  	
	    </TD>
		</TR>
		
	
		<tr><td colspan="2" align="center" height="6">
		<tr><td colspan="2" class="linedotted"></td></tr>
		<tr><td colspan="2" align="center" height="6">
	
		
		<tr><td colspan="2" align="center">
			
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Submit ">
		
		</TD></TR>
			
	</TABLE>	

</CFFORM>
	
</cfoutput>
