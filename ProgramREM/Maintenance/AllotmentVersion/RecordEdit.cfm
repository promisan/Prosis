<cfparam name="url.idmenu" default="">

<cf_screentop title="Register Allotment Version" 
              option="Maintain the version settings" 
			  label="Allotment Version" 
			  height="100%" 
			  banner="yellow" 
			  layout="webapp"
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">
 
<cfquery name="Get" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_AllotmentVersion
	WHERE Code = '#URL.ID1#'
</cfquery>

<cfquery name="Mission"
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_Mission
	WHERE  Mission IN (SELECT Mission
	                   FROM   Ref_MissionModule 
					   WHERE  SystemModule = 'Program')
</cfquery>

<cfquery name="Usage"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ObjectUsage	
</cfquery>


<cfquery name="Class"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     Ref_ProgramClass	
	WHERE    Code != 'Program'
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="10"></td></tr>

	<TR>
    <TD class="labelit">Code:</TD>
    <TD>
    	<cfinput type="text" name="Code" value="#Get.Code#" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit"><cf_tl id="Description">:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="#Get.Description#" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit"><cf_tl id="Entity">:</TD>
    <TD class="labelit">
		<select name="mission" class="regularxl">
		  <option value="">Any</option>
     	   <cfoutput query="Mission">
        	<option value="#Mission#" <cfif get.Mission eq Mission>selected</cfif>>#Mission#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelit"><cf_tl id="Object Usage">:</TD>
    <TD class="labelit">
		<select name="ObjectUsage" class="regularxl">
     	   <cfoutput query="Usage">
        	<option value="#Code#" <cfif get.ObjectUsage eq Code>selected</cfif>>#Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	   
		

	<TR>
    <TD width="28%" class="labelit"><cf_tl id="Program class">:</TD>
    <TD class="labelit">
		<select name="ProgramClass" class="regularxl">
		  <option value="">Any</option>
     	   <cfoutput query="Class">
        	<option value="#Code#" <cfif get.ProgramClass eq Code>selected</cfif>>#Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	
   
			
	<TR>
    <TD class="labelit"><cf_tl id="Listing Order">:</TD>
    <TD class="labelit">
  	   <cfinput type="Text"
	       name="ListingOrder"
	       value="#Get.ListingOrder#"
	       message="Please enter a number 1..9"
	       validate="integer"
	       required="Yes"
	       visible="Yes"
	       enabled="Yes"
	       size="1"
	       maxlength="1"
	       class="regularxl">
    </TD>
	</TR>
		    
	</TD>
	</TR>
	
	<tr><td colspan="2">
	<cf_dialogBottom option="edit">
	</td></tr>
		
</table>

</CFFORM>

