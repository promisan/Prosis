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
  	   <cfinput type="Text" class="regularxl" name="Speedtype" value="" message="Please enter a code" required="Yes" size="10" maxlength="10">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	    <cfinput type="Text" class="regularxl" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="50">
    </TD>
	</TR>
	
	
	<tr><td height="5"></td></tr>
	<tr><td class="labelmedium"><b>Header Settings</td></tr>
	<tr><td colspan="2" height="1" class="linedotted"></td></tr>
		
	<TR>
    <td class="labelmedium" style="cursor: pointer;padding-left:10px"><cf_UItooltip  tooltip="Preset Vendor Selection Tree, if left blank user may select tree him/herself">Vendor Tree:</cf_UItooltip></td>
    <TD> 
		
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *  
	    FROM   Ref_Mission
		WHERE  MissionStatus = '1' <!--- not dynamic --->
	</cfquery>
		    	
    	<select name="InstitutionTree" size="1" class="regularxl">
		    <option value=""></option>
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
	FROM Ref_Topic	L	
	WHERE Operational = 1
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
				<td style="padding-right:5px"><input type="checkbox" name="CustomSelect" value="#Code#"></td>
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
		<td style="padding-right:5px"><input type="checkbox" name="ParentSelect" value="#AccountParent#"></td>
		<cfif row eq "2"></tr><cfset row = 0></cfif>
		</cfloop>
		</table>
					  
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium" style="padding-left:10px">Cost Center:</TD>
    <TD>
	  	 
  	   <select name="CostCenter" size"1" class="regularxl">
          <option value="1" selected>Show</option>
		  <option value="0">Hide</option>
	   </select>
	   
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium" style="padding-left:10px;">External Program:</TD>
    <TD>
	  	 
  	   <select name="ExternalProgram" size"1" class="regularxl">
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
		
			 <select name="TaxCodeMode" size"1" class="regularxl">
		          <option value="1" selected>Show</option>
				  <option value="0">Hide</option>
			   </select>
			   
		  </td>
		
	      <td style="padding-left:4px" id="taxcodebox" class="regular">
	   
		   	<select name="TaxCode" size"1" class="regularxl">
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
