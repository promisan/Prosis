<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  scroll="Yes" 
			  layout="webapp" 
			  label="Add Position/Contract Grade" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">


<cfquery name="Parent"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_PostGradeParent
	ORDER BY Description
</cfquery>

<!--- Entry form --->

<cfform action="RecordSubmit.cfm" method="POST" enablecab="Yes" name="dialog">

<table width="92%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">
		
	<tr><td></td></tr>	
    <TR>
    <TD class="labelmedium">Code:</TD>
    <TD>
  	   <cfinput type="Text" name="PostGrade" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Display:</TD>
    <TD>
  	   <cfinput type="Text" name="PostgradeDisplay" value="" message="Please enter a display description" required="Yes" size="20" maxlength="20" class="regularxxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelmedium">Budget code:</TD>
    <TD>
  	   <cfinput type="Text" name="PostgradeBudget" value="" message="Please enter a budget code" required="Yes" size="10" maxlength="10" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Listing order:</TD>
    <TD>
  	   <cfinput type="Text" name="PostOrder" value="0" message="Please enter a listing order" validate="integer" required="Yes" size="3" maxlength="3" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Maximum number of steps:</TD>
    <TD>
  	   <cfinput type="Text" name="PostGradeSteps" value="15" range="1,20" validate="integer" style="text-align:center;width:30" required="Yes" visible="Yes" enabled="Yes" size="3" maxlength="2" class="regularxxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelmedium">Parent:</TD>
    <TD class="labelmedium">
	   <select name="PostGradeParent" class="regularxxl">
	   <cfloop query="Parent">
	   <cfoutput>
	   <option value="#Parent.Code#">#Parent.Description#</option>
	   </cfoutput>
	   </cfloop>
	   </select>
    </TD>
	</TR>
		
</table>

<cf_dialogBottom option="Add">

</CFFORM>

<cf_screenbottom layout="innerbox">

