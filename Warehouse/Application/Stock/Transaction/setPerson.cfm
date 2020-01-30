
<cfparam name="url.personno" default="">
<cfparam name="url.mode" default="entry">

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Code, Name 
    FROM     Ref_Nation
	WHERE    Operational = '1'
	ORDER BY Name
</cfquery>

<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Parameter
</cfquery>

<cfoutput>

<cfform name="formperson" onsubmit="return false">
  
<table width="100%" height="100%" bgcolor="white" cellspacing="0" cellpadding="0" valign="center" align="center">
  
  <cfinput type="Hidden"
	       name="Mission"
	       value="#url.mission#">
	    
  <tr height="1" class="hide"><td colspan="2" id="personresult"></td></tr>
        
  <tr>
    <td width="96%" class="header" valign="top" align="center">
	
    <table border="0" cellspacing="0" width="90%" align="center" class="formpadding">
	
	<tr><td height="8"></td></tr>
	   <!--- Added field by Jorge --->
    <TR>
    <TD class="labelit"><cf_tl id="ExternalReference">: <font color="FF0000">*</font></TD>
    <TD>
	
	<cfinput type="Text"
	       name="Reference"
	       value=""
		   class="regularXL enterastab"
	       required="Yes" 
	       size="7"
	       maxlength="20">
		
	</TD>
	</TR>	
	
	 <!--- Field: BirthDate --->
    <TR>
    <TD class="labelit"><cf_tl id="ID Expiration">:</TD>
    <TD>
	
	  <cf_intelliCalendarDate9
			FieldName="ReferenceDate" 
			Default=""		
			class="regularXL enterastab"		
			AllowBlank="True">	
			
	</TD>
	</TR>
   	
	
    <!--- Field: LastName --->
    <TR>
    <TD class="labelit"><cf_tl id="Last name">: <font color="FF0000">*</font></TD>
    <TD>
	
		<cfinput type="Text" name="LastName" value="" class="regularXL enterastab" message="Please enter lastname" required="Yes" size="30" maxlength="40">
		
	</TD>
	</TR>
	
    <!--- Field: FirstName --->
    <TR>
    <TD class="labelit"><cf_tl id="FirstName">: <font color="FF0000">*</font></TD>
    <TD>
	
		<cfinput type="Text" name="FirstName" class="regularXL enterastab" message="Please enter a firstname" value="" required="Yes" size="30" maxlength="30">
		
	</TD>
	</TR>
		
    <!--- Field: Gender --->
    <TR>
    <TD class="labelit"><cf_tl id="Gender">:</TD>
    <TD height="20" class="labelit">
	
		<INPUT type="radio" name="Gender" id="Gender" value="M" class="enterastab" checked> Male
		<INPUT type="radio" name="Gender" id="Gender" value="F" class="enterastab"> Female 
		
	</TD>
	</TR>
			
    <!--- Field: Nationality --->
	
    <TR>
    <TD class="labelit"><cf_tl id="Nationality">: <font color="FF0000">*</font></TD>
    <TD>
	
    	<select name="Nationality" id="Nationality" message="Please select a nationality" class="regularxl enterastab">
	    <cfloop query="Nation">
			<option value="#Code#">#Name#</option>
		</cfloop>	    
	   	</select>	
				
	</TD>
	</TR>
			   
	<TR>
        <td class="labelit"><cf_tl id="Category">:</td>
        <TD>
		
			<select name="OrganizationCategory" id="OrganizationCategory" class="regularxl enterastab">
			    <option value="MILITARY">Military</option>
				<option value="UNPOL">Police</option>
				<option value="Contractor">Contractor</option>
				<option value="Local">Local Staff</option>
				<option value="International">International</option>			
			</select>
		
		</TD>
	</TR>
	
	   
	<TR>
        <td class="labelit" style="padding-top:4px"><cf_tl id="Memo">:</td>
        <TD><input style="width:90%" class="regularxl enterastab" name="Remarks"></TD>
	</TR>
			
	<tr><td class="Linedotted" colspan="2"></td></tr>
	
    <tr><td colspan="2" height="30" align="center">   
	   <input type="button" id="submitPerson" name="Submit" value="Save" onClick="validate()" class="button10s" style="width:120;height:23">    
       <!--- <cf_button type="button" name="Submit" id="Submit" value="Save" onclick="validate()">  --->
     </td>

	</table>
	</td></tr>
		
</table>	

</CFFORM>

</cfoutput>


<cfset ajaxOnLoad("doCalendar")>
