
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  title="Add Reason" 			 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="95%" align="center" class="formpadding formspacing">

	<tr><td style="height:6px"></td></tr>

    <TR class="labelmedium2">
    <TD>Code:</TD>
    <TD>
  	   <input type="text" name="Code" id="Code" value="" size="15" maxlength="15" class="regularxxl">
    </TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Description:</TD>
    <TD>
  	   <cfinput type="Text" name="Description" value="" message="Please enter a description" required="Yes" size="34" maxlength="80" class="regularxxl">
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
	 
	 <TR class="labelmedium2">
	 <TD width="150">Entity:&nbsp;</TD>  
	 <TD>
	 	<select name="Mission" id="Mission" class="regularxxl">
		<option value="" selected>[Apply to all]</option>
		<cfoutput query="Mis">
		<option value="#Mission#">#Mission#</option>
		</cfoutput>
		</select>
	 </TD>
	 </TR>
	
	
	<TR class="labelmedium2">
    <TD>Reason Status:&nbsp;</TD>
	
	<TD>
	    <input class="radiol" type="radio" name="Status" id="Status" value="2i">
		Accept
		<input class="radiol" type="radio" name="Status" id="Status" value="9" checked>
		Deny
    </TD>	


	<TR class="labelmedium2">
    <TD>Include Specification:&nbsp;</TD>
	
	<TD>
	    <input class="radiol" type="radio" name="Specification" id="Specification" value="1">
		Yes
		<input class="radiol" type="radio" name="Specification" id="Specification" value="0" checked>
		No
    </TD>		
	
	<!--- Field: ListingOrder --->
    <TR class="labelmedium2">
    <TD>Relative&nbsp;Order:</TD>
    <TD>
  	  	<cfinput type="Text" name="Listingorder" value="" message="Please enter a valid number" validate="integer" 
		  required="No" visible="Yes" enabled="Yes" size="3" maxlength="3" class="regularxxl">
	</TD>
	</TR>
	
	<TR class="labelmedium2">
    <TD>Operational:&nbsp;</TD>
	
	<TD>
	    <input class="radiol" type="radio" name="Operational" id="Operational" value="1" checked>
		Yes
		<input class="radiol" type="radio" name="Operational" id="Operational" value="0" >
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
