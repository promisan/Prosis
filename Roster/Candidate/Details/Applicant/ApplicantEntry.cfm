
<cfparam name="URL.class"          default="">  
<cfparam name="URL.header"         default="1">   
<cfparam name="URL.idmenu"         default="">   
<cfparam name="URL.remove"         default="">   
<cfparam name="URL.submissionedition" default="Generic">   
<cfparam name="URL.Next"           default="Default">
<cfparam name="URL.Mission"        default="">
<cfparam name="URL.OrgUnit"        default="">
<cfparam name="URL.PersonNo"       default="">
<cfparam name="URL.date"           default="">
<cfparam name="URL.ID"             default="">  <!--- bucket id of the application --->

<cfquery name="Parameter" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
		SELECT * FROM Parameter 		
</cfquery>

<cfquery name="Last" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT TOP 1 * 
		FROM   Applicant 
		ORDER BY Created DESC		
</cfquery>

<cfset url.source = Parameter.PHPEntry>	

<cfif url.remove neq "">
	
	<cfquery name="RemoveeApplicant" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		DELETE  FROM Applicant 
		WHERE PersonNo = '#url.remove#'
	</cfquery>

</cfif>

<cfif url.header eq "0">
	<cfset html = "No">
<cfelse>
	<cfset html = "Yes">	
</cfif>

<cfif url.submissionedition neq "Generic">
   <cf_screentop height="100%" scroll="Yes" html="#html#" JQuery="yes" menuAccess="no" layout="webapp" label="Add Person" systemfunctionid="#url.idmenu#">
   <cfset url.header = "0">
<cfelseif url.id eq "" and url.remove eq "" and url.idmenu neq "">
	<cf_screentop height="100%" scroll="Yes" html="#html#" JQuery="yes" menuAccess="Yes" label="Add Person" systemfunctionid="#url.idmenu#">
<cfelse>
    <cf_screentop height="100%" scroll="Yes" html="#html#" layout="webapp" JQuery="yes" menuAccess="No"  label="Add Person" systemfunctionid="#url.idmenu#"> 
</cfif>	

<cf_filelibraryScript>
<cf_calendarscript>
<cf_dialogStaffing>
<cf_dialogPosition>
<cfajaximport tags="cfdiv,cfwindow">

<cfset tree = "">

<cfif url.next eq "Bucket">

	<cfquery name="getClass" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT   E.SubmissionEdition, 
		         E.DefaultStatus, 
				 E.EnableManualEntry, 
				 E.EnableAsRoster, 
				 R.TreePublish,
				 R.Source
		FROM     Ref_SubmissionEdition AS E INNER JOIN
	             Ref_ExerciseClass AS R ON E.ExerciseClass = R.ExcerciseClass
	    WHERE    E.SubmissionEdition = (SELECT SubmissionEdition 
		                                FROM   FunctionOrganization 
										WHERE  FunctionId = '#url.id#')
	</cfquery>
	
	<cfif getClass.TreePublish neq "">
		<cfset tree = getClass.TreePublish>
	</cfif>
	
	<cfset url.source = getClass.source>
	
<cfelseif url.submissionedition neq "">	

	<cfquery name="getClass" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  	SELECT   E.SubmissionEdition, 
		         E.DefaultStatus, 
				 E.EnableManualEntry, 
				 E.EnableAsRoster, 
				 R.TreePublish,
				 R.Source
		FROM     Ref_SubmissionEdition AS E INNER JOIN
	             Ref_ExerciseClass AS R ON E.ExerciseClass = R.ExcerciseClass
	    WHERE    E.SubmissionEdition = '#url.submissionedition#'
	</cfquery>
	
	<cfif getClass.TreePublish neq "">
		<cfset tree = getClass.TreePublish>
	</cfif>
	
	<cfset url.source = getClass.source>
	
</cfif>

<cfquery name="Nation" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Code, Name 
    FROM     Ref_Nation
	WHERE    Operational = '1'
	ORDER BY Name
</cfquery>

<cfquery name="Source" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Source
	WHERE  Operational = '1' and AllowEdit = 1
	AND    source <> ''
</cfquery>

<cfquery name="getParameter" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_parameterOwner
	WHERE Owner = (SELECT AccountOwner 
	               FROM System.dbo.UserNames 
				   WHERE  Account = '#session.acc#')
</cfquery>

<cfif getParameter.DefaultPHPEntry neq "">
	<cfset defaultsource = getParameter.DefaultPHPEntry>
<cfelse>
    <cfset defaultsource = "Manual">
</cfif>	

<cfquery name="Class" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_ApplicantClass
	ORDER BY ListingOrder
</cfquery>

<cfoutput>
<script language="JavaScript">

	function indexblank() {
		document.getElementById('indexno').value = ""
	}
	
	function validate() {	   	  		
		ptoken.navigate('ApplicantEntryValidate.cfm?next=#url.next#&submissionedition=#url.submissionedition#&source=#url.source#&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#','submissionbox','','','POST','applicantentry');
	}
	
	function save() {	
	    
	    if (document.getElementById('emailaddress').value == '') {
		    alert('Please record an eMail address')
		} else {
		    ptoken.navigate('ApplicantEntrySubmit.cfm?idmenu=#url.idmenu#&Next=#URL.Next#&id=#URL.ID#&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&date=#url.date#','submissionbox','','','POST','applicantentry');
		}
	}
		
</script>
</cfoutput>

<cfoutput>

<cfif url.header eq "1">
	
	<table width="100%" border="0">
	
	<tr>
		<td width="5%"></td>
	
		<td height="80" valign="middle" align="left" width="98%" style="top; padding-left:10px">
			<table width="100%" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden">
				<tr>
					<td style="z-index:1; width:646px; height:78px; position:absolute; right:0px; top:0px; background-image:url(#SESSION.root#/images/logos/BGV2.png); background-repeat:no-repeat">
					</td>
				</tr>			
				<tr>
					<td style="z-index:5; position:absolute; top:23px; left:40px; ">
						<img src="#SESSION.root#/images/logos/no-picture-male.png" alt="" width="52" height="52" border="0">
					</td>
				</tr>
				<tr>
					<td style="z-index:3; position:absolute; top:25px; left:104px; color:##45617d; font-family:calibri; font-size:25px; font-weight:250;">
						<cf_tl id="Register a Person">
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:5px; left:97px; color:##e9f4ff; font-family:calibri; font-size:45px; font-weight:200; z-index:2">
						<cf_tl id="Register a Person">
					</td>
				</tr>
				
				<tr>
					<td style="position:absolute; top:56px; left:120px; color:##45617d; font-family:calibri; font-size:12px; font-weight:200; z-index:4">
						Register Candidate and Submission edition
					</td>
				</tr>
				
			</table>
		</td>
	</tr>
	</table>

</cfif>

</cfoutput>

<cfform onSubmit="return false;" action="ApplicantEntrySubmit.cfm?idmenu=#url.idmenu#&Next=#URL.Next#&id=#URL.ID#&mission=#url.mission#&orgunit=#url.orgunit#&personno=#url.personno#&date=#url.date#" 
  method="POST" name="applicantentry" id="applicantentry">

<table width="95%" border="0" cellspacing="0" align="center">

	<tr><td style="padding-top:16px;padding-left:20px">
	      
     <table width="98%" border="0"  align="center">
	       
	  <tr>
	    <td width="100%">
				
	    <table border="0" cellpadding="0" class="formpadding formspacing" width="100%">
		
		<!--- capture the organizational source of the candidate, like for secondment --->
						
		<cfif tree neq "">
							
			<cfquery name="Org" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM Organization.dbo.Organization
				WHERE Mission = '#tree#'
				ORDER By HierarchyCode
			</cfquery>
			
			<TR>
		    <TD class="labelmedium"><cf_tl id="Organization">:</TD>
		    <TD>
			
		     	<cfselect name="OrgUnit" required="Yes" class="regularxl enterastab">
			      <cfoutput query="Org"><option value="#OrgUnit#">#OrgUnitName#</option></cfoutput>
			    </cfselect>	
				
		    </TD>		
		
		<cfelse>
		
			<input type="hidden" value="" name="OrgUnit" id="OrgUnit">
		
		</cfif>	
		
		<cfoutput>	
		
		<cfif url.class eq "">
			
	   	    <!--- Field: Applicant.ApplicantClass --->
		    <TR>
		    <td class="labelmedium"><cf_tl id="Candidate Class">:</td>
			<td>
			
				<cf_tl id="Please define an applicant class" var="1" class="message">
		 	    <cfselect name="ApplicantClass" message="#lt_text#" style="width:150" required="Yes" class="regularxl enterastab">
				    <cfloop query="Class">
					<option value="#ApplicantClassId#">#Description#</option>
					</cfloop>
			    </cfselect>			
				
			</td>
			</TR>	
		
		<cfelse>
		
			<input type="hidden" name="ApplicantClass" value="#url.class#">	
		
		</cfif>
			  	   
		
		<tr id="entity">
		<td class="labelmedium"><cf_tl id="Entity">:</td>
		<td>
		<cfdiv bind="url:getEntity.cfm?class={ApplicantClass}&mission=#url.mission#">
		</td>
		</tr>
		
	    <TR>
	    <TD width="20%" class="labelmedium">#client.IndexNoName#:</TD>
	    <TD>	
		
		   <table cellspacing="0" cellpadding="0">
		   <tr>					 
	
			<td style="padding-left:0px"><input type="text" id="indexno" name="indexno" size="16" maxlength="20" readonly class="regularxl enterastab"></td>			
			
			<cfif url.class neq "4">
			
				<td>
				
					<cfset link = "#SESSION.root#/Roster/Candidate/Details/Applicant/setEmployee.cfm?class=">	
								
					 <cf_selectlookup
					    class      = "Employee"
					    box        = "member"
						button     = "yes"
						icon       = "search.png"
						iconwidth  = "26"
						iconheight = "26"
						title      = "#lt_text#"
						link       = "#link#"						
						close      = "Yes"
						des1       = "PersonNo">
				
				</td>		  
				
				<td style="padding-left:2px">
				<input type="button" class="button10g enterastab" style="height:25px;width:50" name="blank" value="Undo" onClick="javascript:indexblank()">
				</td>
				
				<td id="member"></td>
			
			</cfif>
			
			<input type="hidden" id="employeeno" name="employeeno" size="10" maxlength="20" readonly>
			<input type="hidden" id="name" name="name" size="10" maxlength="20" readonly>
			
		   </tr>					
		   </table>	
			
		</TD>
		</TR>	
		 </cfoutput>
		 
		   <!--- Field: Applicant.FirstName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="First name">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD>		
			<cf_tl id="Please enter a firstname" var="1" class="message">
			<cfinput type="Text"  onchange="validate()" class="regularxl enterastab" id="firstname" name="firstName" message="#lt_text#" required="Yes" size="30" maxlength="30">
			
		</TD>
		</TR>
					
	    <!--- Field: Applicant.MiddleName --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Second name">:</TD>
	    <TD>		
			<INPUT type="text" class="regularxl enterastab" name="middlename" id="middlename" maxLength="30" size="30">			
		</TD>
		</TR>
			
	  
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Last name">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD><cf_tl id="Please enter lastname" var="1" class="message">
			<cfinput type="Text" onchange="validate()" class="regularxl enterastab" id="lastname" name="lastname" message="#lt_text#" required="Yes" size="40" maxlength="40" >			
		</TD>
		</TR>	
		
		  <TR>
	    <TD class="labelmedium"><cf_tl id="Second Last name">:</TD>
	    <TD><cf_tl id="Please enter lastname" var="1" class="message">
			<cfinput type="Text" class="regularxl enterastab" id="lastname2" name="lastname2" message="#lt_text#" required="No" size="40" maxlength="40" >			
		</TD>
		</TR>	
		
		 <!--- Field: Applicant.Mainden Name --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Maiden name">:</TD>
	    <TD>		
			<cf_tl id="Please enter maiden name" var="1" class="message">
			<cfinput type="Text" class="regularxl enterastab" id="MaidenName" name="MaidenName" message="#lt_text#" required="No" size="40" maxlength="40">			
		</TD>
		</TR>
		  
		
	    <!--- Field: Applicant.DOB --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="DOB">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD>	
		
		<script language="JavaScript">
		
		  function processdate(dateset) {			  	
			   document.getElementById('DOB').value = dateset.dd+'/'+dateset.mm+'/'+dateset.yyyy	   
			   // now we perform the validation again
			   validate()
		  }
		  
		</script>	
						
		<cf_intelliCalendarDate9
			FieldName="DOB" 
			Default=""		
			Message="Select valid DOB"	
			class="regularxl enterastab"
			DateValidStart="#Dateformat('01/01/1920', 'YYYYMMDD')#"
			DateValidEnd="#Dateformat(now(), 'YYYYMMDD')#"
			AllowBlank="False"
			scriptdate="processdate">	
				
		</TD>
		</TR>

		<!--- Field: Applicant.MaritalStatus --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Marital Status">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD>
			<cfoutput>
			<cfquery name = "qMarital" datasource = "AppsSelection">
				SELECT * FROM Ref_MaritalStatus
				ORDER  BY ListingOrder
			</cfquery>

	  	 	<cfselect name="MaritalStatus" id="maritalstatus" required="Yes" class="regularxl enterastab">
			
		    <cfloop query="qMarital">
	        		 <option value="#Code#"><cf_tl id="#Description#"></option>
			</cfloop> 
		    </cfselect>	
			
			</cfoutput>
		</TD>
		</TR>
		
		
	    <!--- Field: Applicant.Gender --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Gender">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD class="labelmedium">
		
			<INPUT type="radio" name="Gender" id="Mgender" class="enterastab" value="M" checked> <cf_tl id="Male">
			<INPUT type="radio" name="Gender" id="Fgender" class="enterastab" value="F"> <cf_tl id="Female"> 
			
		</TD>
		</TR>
			
	    <!--- Field: Applicant.Nationality --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Nationality">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD>
		
			<cfif tree eq "">
		
		    	<cfselect name="Nationality" id="Nationality" onchange="validate()" required="Yes" message="Select Nationality" class="regularxl enterastab">
				    <cfoutput query="Nation">
						<option value="#Code#" <cfif last.Nationality eq code>selected</cfif>>#Name#</option>
					</cfoutput>
			    </cfselect>	
			
			<cfelse>
			
				<cfdiv id="Nationality_id" bind="url:getNationality.cfm?orgunit={OrgUnit}" bindOnLoad="Yes">

			</cfif>
			
	    </TD>
				
		<TR>
		<TD class="labelmedium"><cf_tl id="2nd Nationality">:</TD>
		<TD>
	
	  	    <cfselect name="NationalityAdditional" class="regularxl enterastab">
				<option value=""><cf_tl id="N/A"></option>
			    <cfoutput query="Nation">
					<option value="#Code#">#Name#</option>
				</cfoutput>
		    </cfselect>			
			
		</TD>
		</TR>	  
		
	    <!--- Field: Applicant.EmailAddress --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="E-mail Address">:<font color="FF0000">&nbsp;*</font></TD>
	    <TD>
			<cf_tl id="Please enter an e-mail address" var="1" class="message">
			<cfinput type="Text" name="emailaddress" id="emailaddress" validate="email" message="#lt_text#" required="Yes" visible="Yes" enabled="Yes" size="40" maxlength="50" class="enterastab regularxl">
		</TD>
		</TR>
						
		<!--- Field: Applicant.EmailAddress --->
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Mobile Number">:</TD>
	    <TD>		
			<cfinput class="regularxl enterastab" type="text" name="MobileNumber" size="40" maxlength="50">			
		</TD>
		</TR>
					 
	    <TR>
	    <TD class="labelmedium"><cf_tl id="Reference">:</TD>
	    <TD><input type="Text" class="regularxl enterastab" name="DocumentReference" maxlength="30"></TD>
		</TR>	
		
		<TR>
	     <td class="labelmedium" valign="top" style="padding-top:4px"><cf_tl id="Remarks">:</td>
	     <TD><textarea style="font-size:14px;padding:4px;width:99%" class="regular enterastab" rows="3" name="Remarks" totlength="400" onkeyup="return ismaxlength(this)"></textarea>
	    </TD>
		</TR>	
						
		<tr><td colspan="2" class="line"></td></tr>
				
		<tr><td colspan="2" style="padding-left:8px">
	
	      <cfoutput>
			  <table cellspacing="0" cellpadding="0">
			  <tr>
			  
			       <cf_tl id="Verify Record" var="verify">
				  
				  <td align="center" id="savemode">	 		   		 
					 <input class="button10g"  onclick="validate()" style="font-size:13px;height:29;width:140px" type="submit" name="Submit" value="#Verify#">	
				  </td>
				   
				  <cf_tl id="Reset" var="reset">
					
				  <td style="padding-left:3px">	 
					<input class="button10g" type="reset" style="font-size:13px;height:29;width:80px"
					     onclick="validate()" name="Reset" value="#reset#">     
		 		  </td>
				  
			  </tr>
			  </table>
		  </cfoutput>
	   
	      </td>
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>	
		   
   </table>
   
   </td></tr>
         
   </table>      

   </td></tr>
	
   <tr><td id="submissionbox" class="xhide"></td></tr>	
	
</table>

</CFFORM>
