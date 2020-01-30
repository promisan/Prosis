<cfparam name="url.idmenu" default="">

<cf_screentop title="Register Allotment Version" 
			  height="100%" 
			  layout="webapp" 
			  label="Register Allotment Version" 
			  menuAccess="Yes" 
			  systemfunctionid="#url.idmenu#">

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
</cfquery>

<cfform action="RecordSubmit.cfm" method="POST" name="dialog">

<!--- Entry form --->

<table width="90%" cellspacing="0" cellpadding="0" align="center" class="formpadding formspacing">

	<tr><td height="5"></td></tr>
	
	<TR>
    <TD class="labelit">Code:</TD>
    <TD class="labelit">
    	   <cfinput type="text" name="Code" value="" message="Please enter a code" required="Yes" size="10" maxlength="10" class="regularxl">
    </TD>
	</TR>
		
	<TR>
    <TD class="labelit">Description:</TD>
    <TD class="labelit">
  	   <cfinput type="text" name="Description" value="" message="Please enter a description" required="Yes" size="35" maxlength="50" class="regularxl">
    </TD>
	</TR>
	
	<TR>
    <TD class="labelit">Entity:</TD>
    <TD class="labelit">
		<select name="mission" class="regularxl">
		  <option value=""></option>
     	   <cfoutput query="Mission">
        	<option value="#Mission#">#Mission#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	
	
	<TR>
    <TD class="labelit">Program class:</TD>
    <TD class="labelit">
		<select name="ProgramClass" class="regularxl">
		  <option value="">Any</option>
     	   <cfoutput query="Class">
        	<option value="#Code#">#Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>			

	<TR>
    <TD class="labelit">Object Usage:</TD>
    <TD>
		<select name="ObjectUsage" class="regularxl">
     	   <cfoutput query="Usage">
        	<option value="#Code#">#Description#</option>
         	</cfoutput>
	    </select>
		
    </TD>
	</TR>	   
			
	<TR>
    <TD class="labelit">Listing Order:</TD>
    <TD class="labelit">
  	   <cfinput type="Text"
	       name="ListingOrder"
	       value="1"
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
	<cf_dialogBottom option="add">
	</td></tr>
		
</table>

</CFFORM>

