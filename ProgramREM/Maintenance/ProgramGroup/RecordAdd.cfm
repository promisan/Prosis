<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Group" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

	<tr><td height="5"></td></tr>
		
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="text" name="code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Description:</TD>
    <TD>
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="40" maxlength="40" class="regularxl">
    </TD>
	</TR>
		
	<cfquery name="MissionList" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_ParameterMission
	</cfquery>
	
	<TR>
    <TD class="labelmedium">Entity:</TD>
    <TD>
	<cfoutput>
		<select name="Mission" class="regularxl">
        	<option value="0" selected>All entities</option>
     	   <cfloop query="MissionList">
        	<option value="#Mission#">#Mission#</option>
         	</cfloop>
	    </select>
	</cfoutput>		
    </TD>
	</TR>		
		
	<cfquery name="QPeriod" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Ref_Period
	</cfquery>
	
	<TR>
    <TD class="labelmedium">Period:</TD>
    <TD>
	<cfoutput>
		<select name="Period" class="regularxl">
        	<option value="0" selected>All periods</option>
     	   <cfloop query="QPeriod">
        	<option value="#QPeriod.Period#">#QPeriod.Description#</option>
         	</cfloop>
	    </select>
	</cfoutput>		
    </TD>
	</TR>		
	
	<TR>
    <TD class="labelmedium">Order:</TD>
    <TD>
  	   <cfinput type="text" name="ListingOrder" value="1" size="20" maxlength="20" class="regularxl" validate="integer">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Color:</TD>
    <TD class="regular">
  	   <input type="text" name="ViewColor" value="" size="20" maxlength="20" class="regularxl">
    </TD>
	</TR>
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr>	
	<td colspan="2" align="center" valign="bottom" height="40">	
		
	<input class="button10g" type="button" name="Cancel" value="Cancel" onClick="window.close()">
    <input class="button10g" type="submit" name="Insert" value="Submit">
	
	</td>	
	
	</tr>
		
</TABLE>

</CFFORM>
