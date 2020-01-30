
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Add Reason" 
			  label="Add Reason" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
  	   <input type="text" name="Code" id="Code" value="" size="15" maxlength="15"class="labelit">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="34" maxlength="80"class="labelit">
    </TD>
	</TR>
		 
	 <cfquery name="Mis" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
		WHERE Mission IN (SELECT Mission 
                  FROM Organization.dbo.Ref_MissionModule 
				  WHERE SystemModule = 'Procurement')
	</cfquery>
	 
	 <TR>
	 <TD class="labelit" width="150">Entity:&nbsp;</TD>  
	 <TD>
	 	<select name="Mission" id="Mission" class="regularxl">
		<option value="" selected>[Apply to all]</option>
		<cfoutput query="Mis">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>
	
	
	<TR>
    <TD class="labelit">Reason Status:&nbsp;</TD>
	
	<TD class="labelit">
	    <input type="radio" name="Status" id="Status" value="2i">
		Accept
		<input type="radio" name="Status" id="Status" value="9" checked>
		Deny
    </TD>	


	<TR>
    <TD class="labelit">Include Specification:&nbsp;</TD>
	
	<TD class="labelit">
	    <input type="radio" name="Specification" id="Specification" value="1">
		Yes
		<input type="radio" name="Specification" id="Specification" value="0" checked>
		No
    </TD>		
	
	<!--- Field: ListingOrder --->
    <TR>
    <TD class="labelit">Relative&nbsp;Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="Listingorder" value="" message="Please enter a valid number" validate="integer" required="No" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxl">
	</TD>
	</TR>
	
	<TR>
    <TD class="labelit">Operational:&nbsp;</TD>
	
	<TD class="labelit">
	    <input type="radio" name="Operational" id="Operational" value="1" checked>
		Yes
		<input type="radio" name="Operational" id="Operational" value="0" >
		No
    </TD>	
	</TR>
	

	<tr><td colspan="2" align="center" height="6">
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="6">
	
	<TR>
		<td align="center" colspan="2">
		<input type="button" name="Cancel" id="Cancel" value=" Cancel " class="button10g" onClick="window.close()">
	    <input class="button10g" type="submit" name="Insert" id="Insert" value=" Submit ">
		</td>		
	</TR>
		
</table>




</CFFORM>
