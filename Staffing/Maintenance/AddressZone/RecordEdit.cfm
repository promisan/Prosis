<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Address Zone" 
			  option="Address Zone Maintenance" 
			  scroll="Yes" 
			  layout="webapp"
			  banner="yellow" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<cfquery name="Get" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	*
	FROM 	Ref_AddressZone
	WHERE 	Code = '#URL.ID1#'
</cfquery>

<cfquery name="VerifyDeleteUpdate" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	
    SELECT TOP 1 addressZone
	FROM	vwPersonAddress
	WHERE AddressZone = '#URL.ID1#'

 </cfquery>
 
<script language="JavaScript">

function ask() {
	if (confirm("Do you want to remove this record ?")) {	
	return true 	
	}	
	return false	
}	

</script>

<!--- edit form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

	 <cfoutput>
	 <TR>
	 <TD class="labelit">Code:&nbsp;</TD>  
	 <TD class="labelit">
	 	<cfif VerifyDeleteUpdate.recordCount eq 0>
		 	<cfinput type="Text" name="Code" value="#get.Code#" message="Please enter a code" required="Yes" size="20" maxlength="20" class="regularxl">
		<cfelse>
			#get.Code#
			<input type="hidden" name="Code" value="#get.Code#">
		</cfif>
		<input type="hidden" name="CodeOld" value="#get.Code#">
	 </TD>
	 </TR>
	 
	 <!--- Field: Mission --->
    <TR>
    <TD class="labelit">Mission:&nbsp;</TD>
    <TD>
  	  	<cfquery name="getLookup" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ParameterMission
		</cfquery>
		<select name="mission" class="regularxl">
			<cfloop query="getLookup">
			  <option value="#getLookup.mission#" <cfif getLookup.mission eq #get.mission#>selected</cfif>>#getLookup.mission#</option>
		  	</cfloop>
		</select>	
    </TD>
	</TR>
	

	 <!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="description" value="#get.description#" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
				
    </TD>
	</TR>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	<tr><td colspan="2" align="center" height="30">
	<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">	
	<cfif VerifyDeleteUpdate.recordCount eq 0><input class="button10g" type="submit" name="Delete" value=" Delete " onclick="return ask()"></cfif>
	<input class="button10g" type="submit" name="Update" value=" Update ">	
	</td></tr>
	
</cfoutput>
</CFFORM>
    	
</TABLE>
