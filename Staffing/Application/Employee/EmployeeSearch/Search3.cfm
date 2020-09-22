
<cf_screentop height="100%" scroll="Yes" html="No" jquery="Yes">

<cfform action="Search3Submit.cfm?Mission=#URL.Mission#" method="POST" name="search">

<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

 <tr class="line">
    <td height="22" class="labelmedium" style="font-size:25px;height:45px">
	  <cf_tl id="Staff search">:
	</td>
	<td align="right" style="padding-right:10px">
	<cfoutput>
	<cf_tl id="Reset" var="1">
	<input class="button10g" type="reset"  value=" #lt_text#  ">
	<cf_tl id="Find" var="1">
	<input type="submit" name="Submit" id="Submit" value="#lt_text#" class="button10g">
	</cfoutput>
    </td>
 </tr> 	
   
  <tr><td colspan="2">
  
<cfquery name="Parameter" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>  

<cfquery name="Nationality" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_Nation
	WHERE Name > 'a'
	AND Code IN (SELECT DISTINCT Nationality FROM Employee.dbo.Person)
</cfquery>

<cfif getAdministrator(url.mission) eq "1">
	
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   DISTINCT M.Mission 
	    FROM     Ref_Mission M, Ref_MissionModule R
		WHERE    M.Mission      = R.Mission
		AND      R.SystemModule = 'Staffing'
		AND      M.Mission IN (SELECT Mission FROM Employee.dbo.PositionParent WHERE Mission = R.Mission)
	</cfquery>
		
	<cfquery name="PostType" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT PostType
		    FROM Ref_PostType
	</cfquery>

<cfelse>
	
	<cfquery name="Mission" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT DISTINCT M.Mission 
	    FROM   Ref_Mission M, Ref_MissionModule R, OrganizationAuthorization A
		WHERE  M.Mission    = R.Mission
		AND    R.SystemModule = 'Staffing'
		AND    A.Mission      = M.Mission
		AND    A.UserAccount  = '#SESSION.acc#'
		AND    A.Role IN ('HROfficer','HRPosition','HRAssistant','HRInquiry')
	</cfquery>
		
	<cfquery name="PostType" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT DISTINCT T.PostType 
		    FROM Ref_PostType T, Organization.dbo.OrganizationAuthorization A
			WHERE T.PostType  = A.ClassParameter
			AND A.UserAccount = '#SESSION.acc#'
			AND A.Role IN ('HROfficer','HRPosition','HRAssistant','HRInquiry')
	</cfquery>

</cfif>

<cfquery name="Grade" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_PostGrade
	ORDER By PostOrder
</cfquery>

<!--- Search form --->

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td>

		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" style="border-collapse: collapse">
		 
		<TR class="line">  
		   <td colspan="1" class="labelmedium" height="20"><cf_tl id="Status"></td>
		   <td colspan="1" class="labelmedium" ><cf_tl id="Identification"></td>
		   <td colspan="1" class="labelmedium" ><cf_tl id="Gender">&nbsp;</td> 
		</TR>
		
		<TR>
		   <td height="5" colspan="3" valign="middle"></td>
		</TR> 
			
		<TR><td width="25%" valign="top">
		
		    <table border="0" cellspacing="0" cellpadding="0">
		       <tr><td class="labelit"><input class="radiol" type="radio" name="EmployeeStatus" id="EmployeeStatus" value="OnBoard"><cf_tl id="On board"><td></tr>
		       <tr><td class="labelit"><input class="radiol" type="radio" name="EmployeeStatus" id="EmployeeStatus" value="History"><cf_tl id="History"><td></tr>
			   <tr><td class="labelit"><input class="radiol" type="radio" name="EmployeeStatus" id="EmployeeStatus" value="All" checked><cf_tl id="All"><td></tr>
			</table>	
		
		   </td>	
			
		   <TD width="58%">	
		   
		   <table border="0" cellspacing="0" cellpadding="0" class="formpadding">
		   <tr>
		   <TD class="labelit"><cfoutput>#client.IndexNoName#</cfoutput>:&nbsp;</TD>
		   <TD><INPUT type="text" name="IndexNo" id="IndexNo" size="20" class="regularxl"></td>
		   </tr>
		   <tr>
		   <TD class="labelit"><cf_tl id="Full name">:&nbsp;</TD>
		   <TD><INPUT type="text" name="FullName" id="FullName" size="40" class="regularxl"></td>
		   </tr>
		   <tr>
		   <TD class="labelit"><cf_tl id="Last name">:&nbsp;</TD>
		   <TD><INPUT type="text" name="LastName" id="LastName" size="40" class="regularxl"></td>
		   </tr>
		   <tr>
		   <TD class="labelit"><cf_tl id="First name">:&nbsp;</TD>
		   <TD><INPUT type="text" name="FirstName" id="FirstName" size="30" class="regularxl"></td>
		   </tr>
		   </table>
		 	
		   </TD>
			
		    <td class="regular" width="17%" valign="top">
			<table border="0" cellspacing="0" cellpadding="0">
		    <tr><td class="labelit"><input class="radiol" type="radio" name="Gender" id="Gender" value="M"><cf_tl id="Male"></td></tr>
			<tr><td class="labelit"><input class="radiol" type="radio" name="Gender" id="Gender" value="F"><cf_tl id="Female"></td></tr>
			<tr><td class="labelit"><input class="radiol" type="radio" name="Gender" id="Gender" value="B" checked><cf_tl id="Both"></td></tr>
			</table>		
		  </td>
		 
		</TR>		
		
		<tr><td width="100%" colspan="3">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		    <TR>
		     <td height="2" colspan="6" valign="middle" class="line"></td>
		   </TR>     
		
		   <TR>  
		    <td width="33%" height="20" class="labelmediumcl" colspan="2">&nbsp;<cf_tl id="Nationality"></td>
			<td colspan="2">&nbsp;</td>
			<td colspan="2">&nbsp;</td>
		   </TR>
		   
		   <tr><td colspan="3" class="line"></td></tr>
		   
		   <TR>
		   <td height="3" colspan="6" valign="middle"></td>
		   </TR>   		
			
			<TD valign="top" class="labelit">
		
			<input type="radio" class="radiol" name="NationalityStatus" id="NationalityStatus" value="ANY" checked><cf_tl id="ANY">
			<p>
			<input type="radio" class="radiol" name="NationalityStatus" id="NationalityStatus" value="ALL"><cf_tl id="ALL"> 
		    
			</TD>
			<TD>
		    	<select name="Nationality" id="Nationality" size="8"  class="regularxl" style="height:150" multiple>
			    <cfoutput query="Nationality">
				<option value="'#Code#'">#Name#</option>
				</cfoutput>
			   	</select>
			</TD>	
			</TR>	
			
			<TR>
		   <td height="5" colspan="6" valign="middle"></td>
		</TR> 		
		
		</table>
		
		</td></tr>
		
		<tr><td width="100%" colspan="3">
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			
			<TR>
			   <td height="5" colspan="6" valign="middle"></td>
			</TR>   
			
			<TR>
			   <td height="2" colspan="6" valign="middle" class="line"></td>
			</TR>  
			
			   <tr><td colspan="6">
			   
			   <table width="100%" border="0" cellspacing="0" cellpadding="0">
			   
			   <TR class="line">  
			   <td width="25%" class="labelmedium" height="20"><cf_tl id="Criteria"></td>
			   <td width="25%" class="labelmedium"><cf_tl id="Expiration"></td>
			   <td width="25%" class="labelmedium"><cf_tl id="Criteria"></td>
			   <td width="25%" class="labelmedium"><cf_tl id="Expiration"></td>
			   </TR> 
			 		   
			   <tr class="line">
			   <td colspan="1" style="height:40" class="labelmedium"><cf_tl id="Contract expiration"></td>
			   <td colspan="1">  
			   
			   <cf_calendarscript>
			   
			   		<cf_intelliCalendarDate9
						FormName="search"
						FieldName="ContractExpiration" 
						DateFormat="#APPLICATION.DateFormat#"
						Default=""
						class="regularxl"
						AllowBlank="True">
						
			   </td>
			   <td class="labelit">[not defined]</td>
			   <td></td>
			   </tr>
			   		   
			   </table>
			   
			   </td></tr>
					
			   <TR class="line">
			   <cfif Parameter.AccessMode neq "Parent">  
			       <td colspan="2" class="labelmedium" height="20"><cf_tl id="Mission">/<cf_tl id="Tree"></td>
			   </cfif>
			   <td colspan="2" class="labelmedium"><cf_tl id="Grade"></td>
			   <td colspan="2" class="labelmedium"><cf_tl id="Category"></td>
			   </TR>
			   		      
			   	<cfif Parameter.AccessMode neq "Parent">
				
				<TD valign="top" class="labelit">
			
				<input type="radio" class="radiol" name="MissionStatus" id="MissionStatus" value="ANY" checked><cf_tl id="ANY">
				<p>
			    <input type="radio" class="radiol" name="MissionStatus" id="MissionStatus" value="ALL"><cf_tl id="ALL"> 
				
				</TD>
				
				<TD>
			    	
			    	<cfselect name="Mission" id="Mission" size="8" message="Please select one or more tree/missions" style="height:140" class="regularxl" multiple>
				    <cfoutput query="Mission">
					<option value="'#Mission#'" selected>#Mission#</option>
					</cfoutput>
				   	</cfselect>
					
				</TD>	
				
				</cfif>
					
			    <!--- Field: Staff.Expereince=CHAR;40;FALSE --->
				
				<td valign="top" class="labelit"> 
			
				<input type="radio" class="radiol" name="GradeStatus" id="GradeStatus" value="ANY" checked><cf_tl id="ANY"> 
				<p>
			    <input type="radio" class="radiol" name="GradeStatus" id="GradeStatus" value="ALL"><cf_tl id="ALL"> 
				
				</td>
				<td align="left" style="padding-top:3px">
			    	
			    	<select name="Grade" id="Grade" size="8" multiple style="height:150px" class="regularxl">
				    <cfoutput query="Grade">
					<option value="'#PostGrade#'">#PostGrade#</option>
					</cfoutput>
				   	</select>
				</td>	
				   
				
				<TD valign="top" class="labelit">
				
				<input type="radio" class="radiol" name="PostTypeStatus" id="PostTypeStatus" value="ANY" checked><cf_tl id="ANY">
				<p>
				<input type="radio" class="radiol" name="PostTypeStatus" id="PostTypeStatus" value="ALL"><cf_tl id="ALL"> 
					    
				</TD>
				
				<TD  style="padding-top:3px">
			    	<select name="PostType" id="PostType" size="8"  style="height:150px" class="regularxl" multiple>
					<cfset ptemax = "">
				    <cfoutput query="PostType">
					   <cfif ptemax eq "">
					       <cfset ptemax = "#PostType#"> 
					   <cfelse>
			    		   <cfset ptemax = "#ptemax#,#PostType#">
					   </cfif>
					   <option value="'#PostType#'">#PostType#</option>
					</cfoutput>
				   	</select>
					
					<input type="hidden" name="ptemaxform" id="ptemaxform" value=<cfoutput>#ptemax#</cfoutput>>
				</TD>	
				</TR>		
				
				<TR>
				   <td height="5" colspan="6" valign="middle"></td>
				</TR> 		
			
			</TABLE>
		
		</td></tr>
		
		</TABLE>

</td></tr>

</TABLE>

</td></tr>

<tr><td colspan="2" height="1" class="line"></td></tr>

<tr>
<td align="center" height="40" colspan="2" valign="middle" class="regular">
		
	<button name="Prios" id="Prios"
	     class="button10g"
		 style="width:300;font-size:13px;height:30px" 
		 value="Prior" 
		 type="submit"><b><cf_tl id="Retrieve Employees"></b></button>
	
</td></tr>

</TABLE>

</CFFORM>
