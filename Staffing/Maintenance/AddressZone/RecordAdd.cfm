<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Address Zone" 
			  option="Address Zone Maintenance" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="blue" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

<CFFORM action="RecordSubmit.cfm" method="post" name="dialog">

<!--- Entry form --->

<table width="95%" cellspacing="0" cellpadding="0" align="center" class="formpadding">

   <!--- Field: Id --->
    <TR>
    <TD class="labelit">Code:</TD>
    <TD>
		<cfinput type="Text" name="Code" value="" message="Please enter a code" required="Yes" size="20" maxlength="20"
		class="regularxl">
	</TD>
	</TR>
	
	   <!--- Field: Mission --->
    <TR>
    <TD class="labelit">Mission:&nbsp;</TD>
    <TD class="labelit">
  	  	<cfquery name="getLookup" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM Ref_ParameterMission
		</cfquery>
		<select name="mission" class="regularxl">
			<cfoutput query="getLookup">
			  <option value="#getLookup.mission#">#getLookup.mission#</option>
		  	</cfoutput>
		</select>	
    </TD>
	</TR>
	

	 <!--- Field: Description --->
    <TR>
    <TD class="labelit">Description:&nbsp;</TD>
    <TD>
  	  	<cfinput type="Text" name="description" value="" message="Please enter a description" required="Yes" size="30" maxlength="50" class="regularxl">
				
    </TD>
	</TR>	
		
	<tr><td height="3"></td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr>	
		<td align="center" colspan="2" height="30">
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="window.close()">
		<input class="button10g" type="submit" name="Insert" value=" Save ">
		</td>
	</tr>
	    
</TABLE>

</CFFORM>
