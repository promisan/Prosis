<!-- 
	Application/CandidateEntryList.cfm
	
	The purpose of this query is to display a list of persons having the same
	lastname, firstname, dob, and nationality as entered in the Candidate data entry form
	
	Called by: CandidateEntry.cfm
	Calls: CandidateEntryListSubmit.cfm

	Modification History:
	27Apr04 - added Category and Rank columns to the Person Matching list 
			- modified searchresults block to first try and match using IndexNumber entered
			- added PassportNo, PassportIssue and PassportExpiry to params list of SelectCandidate()	
-->	
<HTML><HEAD><TITLE>Person Match</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>">

<!--- Create Criteria string for query from data entered thru search form --->
<cfparam name="PersonNo" default="0">
<cfset CLIENT.nat = "#FORM.Nationality#"> 
<cfset CLIENT.birthnat = "#FORM.BirthNationality#"> 
<cfset CLIENT.rank = "#FORM.Rank#"> 

<script language="JavaScript">
function selectcandidate(docno,persno,last,first,categ,deploy,remk,rnk,passno,passiss,passexp,joindt,satdt)
{
 	window.open("CandidateEntryListSubmit.cfm?ID=" + docno + "&ID1=" + persno + "&ID2=" + last + "&ID3=" + first + "&ID4=" + categ + "&ID5=" + deploy + "&ID6=" + remk + "&ID7=" + rnk + "&ID8=" + passno + "&ID9=" + passiss + "&ID10=" + passexp + "&ID11=" + joindt + "&ID12=" + satdt, "Listing", "width=600, height=600, toolbar=no, scrollbars=yes, resizable=no");
}
</script>

<!--- assign BirthDate to local var --->
<cfif #Form.BirthDate# NEQ "">
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.BirthDate#">
	<cfset BirthDay = #dateValue#>
</cfif>

<!--- 27Apr04 - find Person table match using Index Number --->
<cfif #Form.IndexNo# NEQ "">
	<cfquery name="FindPersonViaIndex" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">	
		SELECT PersonNo FROM Person WHERE IndexNo = '#FORM.IndexNo#'
	</cfquery>

	<cfif #FindPersonViaIndex.recordCount# NEQ 0>
		<cfquery name="SearchResult" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT P.PersonNo, P.IndexNo, P.FirstName, P.LastName, P.MiddleName, P.Nationality, P.Gender, P.BirthDate, P.Category, R.ShortDesc AS Rank
			FROM Person P LEFT JOIN TRAVEL.DBO.Ref_Rank R ON P.Rank = R.Rank
		    WHERE P.IndexNo = '#FORM.IndexNo#'
	    	ORDER BY P.LastName, P.FirstName
		</cfquery>	
	<cfelse>
		<cfquery name="SearchResult" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT P.PersonNo, P.IndexNo, P.FirstName, P.LastName, P.MiddleName, P.Nationality, P.Gender, P.BirthDate, P.Category, R.ShortDesc AS Rank
			FROM Person P LEFT JOIN TRAVEL.DBO.Ref_Rank R ON P.Rank = R.Rank
		    WHERE P.LastName LIKE '%#FORM.LastName#%'
			AND   P.Nationality = '#FORM.Nationality#'
			<cfif len(trim(#FORM.FirstName#)) GT 0> AND P.FirstName LIKE '%#FORM.FirstName#%'</cfif>
			<cfif len(trim(#FORM.BirthDate#)) GT 0> AND P.BirthDate = #BirthDay#</cfif>
	    	ORDER BY P.LastName, P.FirstName
		</cfquery>	
	</cfif>
<cfelse>
	<cfquery name="SearchResult" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT P.PersonNo, P.IndexNo, P.FirstName, P.LastName, P.MiddleName, P.Nationality, P.Gender, P.BirthDate, P.Category, R.ShortDesc AS Rank
		FROM Person P LEFT JOIN TRAVEL.DBO.Ref_Rank R ON P.Rank = R.Rank
	    WHERE P.LastName LIKE '%#FORM.LastName#%'
		AND   P.Nationality = '#FORM.Nationality#'
		<cfif len(trim(#FORM.FirstName#)) GT 0> AND P.FirstName LIKE '%#FORM.FirstName#%'</cfif>
		<cfif len(trim(#FORM.BirthDate#)) GT 0> AND P.BirthDate = #BirthDay#</cfif>
    	ORDER BY P.LastName, P.FirstName
	</cfquery>	
</cfif>
		
<!-- If no match is found (using WHERE clause) in the Person table for the Nominee ... -->
<cfif #SearchResult.recordCount# EQ 0>

	<!-- if DOB field is empty -->
	<cfif len(trim(#FORM.BirthDate#)) EQ 0>
		<!-- Flash message window telling user to input DOB --->
		<script language="JavaScript">		
		   alert("No matching record located. Input a valid date value in Date of Birth field to proceed.")
		   window.close()
		</script>	
	<cfelse>
		<!-- Write data in Candidate Entry form into the database -->
  		<cfinclude template="CandidateEntrySubmit.cfm">
	</cfif>
	
<cfelse>	

<!-- ...Else, display list and process user's selection. -->
<body class="dialog" onLoad="window.focus()">

<CFFORM action="CandidateEntryListSubmit.cfm?ID=#URL.ID#" method="POST" target="Listing" enablecab="No" name="CandidateEntryList" onSubmit="javascript:listing()">
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr bgcolor="#002350">
    <td height="30" class="BannerN">&nbsp;<b>Matching entries in Person table</b></td>  
    <td align="right" class="BannerN">
	<!---
	  <CF_DialogHeaderSub MailSubject="Employee" MailTo="" MailAttachment="" ExcelFile=""	CloseButton="Yes">
	 --->
		<input type="button" class="input.button1" name="Print" value="  Print  " title="Print the contents of the window" 
		onClick="javascript:window.print()">
		<input type="button" class="input.button1" name="Close" value=" Close " onClick="javascript:closing()">	
    </td>  
  </tr>
  
  <tr>
  <td colspan="2">  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
	
	<!-- Column titles -->
	<tr bgcolor="#6688aa">
   	<td class="topN"></td>
   	<td class="topN">&nbsp;IndexNo</td>
   	<td class="topN">LastName</td>
   	<td class="topN">FirstName</td>
   	<td class="topN">Nat.</td>
   	<td class="topN">Gender</td>
   	<td class="topN">DOB</td>    
   	<td class="topN">Categ</td>    
   	<td class="topN">Rank</td>    		
	</tr>

	<!-- Display list of matching persons retrieved in Person table -->
	<cfoutput query="SearchResult">
	<tr bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('D6DEE4'))#">
   	<td class="regular">&nbsp;
		<cfif IsDefined("Form.ServiceJoinDate")>
	    	<a href ="javascript:selectcandidate('#Form.DocumentNo#',
											 '#SearchResult.PersonNo#',
											 '#SearchResult.LastName#',
	    	                          		 '#SearchResult.FirstName#',
											 '#Form.Category#',
											 '#Form.PlannedDeployment#',
											 '#Form.Remarks#',
											 '#Form.Rank#',
											 '#Form.PassportNo#',
											 '#Form.PassportIssue#',
											 '#Form.PassportExpiry#',
											 '#Form.ServiceJoinDate#',
											 '#Form.SatDate#')">
<!---											 
   	    	 <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
--->			 
	    	 <img src="../../Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
	        </a>
		<cfelse>
	    	<a href ="javascript:selectcandidate('#Form.DocumentNo#',
											 '#SearchResult.PersonNo#',
											 '#SearchResult.LastName#',
	    	                          		 '#SearchResult.FirstName#',
											 '#Form.Category#',
											 '#Form.PlannedDeployment#',
											 '#Form.Remarks#',
											 '#Form.Rank#',
											 '#Form.PassportNo#',
											 '#Form.PassportIssue#',
											 '#Form.PassportExpiry#',
											 '',
											 '')">
<!---											 
   	    	 <img src="#CLIENT.Root#/Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
--->  			 
			<img src="../../Images/button.jpg" alt="" name="img0_#PersonNo#"  width="14" height="14" border="0" align="middle">
	        </a>
		</cfif>		
		&nbsp;
	</td>
	<td class="regular"><A HREF ="javascript:ShowPerson('#SearchResult.PersonNo#')">#SearchResult.IndexNo#</A></td>
	<td class="regular">#SearchResult.LastName#</td>
	<td class="regular">#SearchResult.FirstName#</td>
	<td class="regular">#SearchResult.Nationality#</td>
	<td class="regular">#SearchResult.Gender#</td>
	<td class="regular">#DateFormat(SearchResult.BirthDate, CLIENT.DateFormatShow)#</td>
	<td class="regular">#SearchResult.Category#</td>
	<td class="regular">#SearchResult.Rank#</td>	
	</tr>
	</cfoutput>

  </table>
  </td>
  </tr>	
</table>
</cfform>

<!--- queries for the dropdowns in the next form below --->
<cfquery name="Rank" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Ref_Rank 
	ORDER BY RankSort
</cfquery>

<cfquery name="Nationality" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT CODE, NAME FROM Ref_Nationality 
	WHERE Operational = '1'
	ORDER BY NAME
</cfquery>

<cfquery name="Category" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category FROM Ref_Category
	WHERE Hybrid_ind = 0
	ORDER BY Category
</cfquery>

<CFFORM action="CandidateEntrySubmit.cfm?ID=#URL.ID#" method="POST" target="Listing" enablecab="No" name="CandidateEntryList" onSubmit="javascript:listing()">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  
  <tr>
  <td colspan="2" height="20" align="center" bgcolor="#6699AA" class="top">Make a selection from above list OR accept new entry below.</td>	
  </tr> 	

  <tr>
  <td width="100%" colspan="2"> <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
  <cfoutput> 
  <input type="hidden" name="documentno" value="#Form.DocumentNo#">  
  </cfoutput>   
  	<tr> 
  	<td colspan="2">&nbsp;&nbsp;<font face="tahoma" size="1" >Note: An asterisk (*) after the field label indicates a mandatory field.</font></td>
  	</tr>
  
  	<tr>
  	<td width="50%" height="5"></td>
	</tr>

	<cfset sLastName = UCase(#FORM.LastName#)>
	<tr> 
	<td class="header">&nbsp;Last name*:</td>
	<td> <cfinput type="Text" name="lastname" value="#sLastName#" message="Please enter candidate last name in upper case" required="Yes" size="40" maxlength="40" class="regular"></td>
	</tr>

	<tr> 
	<td class="header">&nbsp;First name*:</td>
	<td><cfinput type="Text" name="firstname" value="#FORM.FirstName#" message="Please enter candidate first name in proper case" required="Yes" size="30" maxlength="30" class="regular"></td>
	</tr>

	<tr>
	<td class="header">&nbsp;Middle name:</td>
	<td><cfinput type="Text" name="middlename" value="#FORM.MiddleName#" message="Please enter candidate middle name in proper case" required="No" size="25" maxlength="25" class="regular"></td>
	</tr>

	<tr>
	<td class="header">&nbsp;IndexNo:&nbsp;<font color="red"><strong>NEW!</strong></font></td>
	<td><cfinput type="Text" name="IndexNo" value="#FORM.IndexNo#" message="Please enter IMIS number if known" required="No" size="10" maxlength="10" class="regular"></td>
	</tr> 
	
	<tr> 
	<td class = "header">&nbsp;Date of birth (dd/mm/yy)*:</td>
	<td class = "regular"> 
	<cfif #CLIENT.DateFormatShow# is "EU">
		<cfinput class="regular" type="Text" value="#FORM.BirthDate#" name="BirthDate" message="Date of birth: Please enter a correct date format" validate="eurodate" required="Yes" size="12" maxlength="16">
	<cfelse>
		<cfinput class="regular" type="Text" value="#FORM.BirthDate#" name="BirthDate" message="Date of birth: Please enter a correct date format" validate="date" required="Yes" size="12" maxlength="16">
	</cfif>
	</td>
	</tr>
	<!--- Field: Gender --->
	<tr> 
	<td class="header">&nbsp;Gender*:</td>
	<td class="regular"> 
	<input type="radio" name="Gender" value="M" <cfif #FORM.Gender# eq "M">checked</cfif> male> 
	<input type="radio" name="Gender" value="F" <cfif #FORM.Gender# eq "F">checked</cfif> female> 
	</td>
	</tr>
	<!-- Present nationality  -->
	<tr> 
	<td class="header">&nbsp;Present nationality*:</td>
	<td width="50%" class="regular"> 
	<cfselect name="Nationality" required="Yes">
	<cfoutput query="Nationality"> 
	<option value="#Code#"<cfif #Code# eq #FORM.Nationality#> selected </cfif>>#Name#</option>
	</cfoutput> </cfselect></td>
	</tr>
	<!-- Nationality at birth -->
	<tr> 
	<td class="header">&nbsp;Nationality at birth*:</td>
	<td width="50%" class="regular"> 
	<cfselect name="BirthNationality" required="Yes">
	<cfoutput query="Nationality"> 
	<option value="#Code#" <cfif #Code# eq #FORM.BirthNationality#> selected </cfif>>#Name#</option>
	</cfoutput> </cfselect></td>
	</tr>
	<!--- Field: Rank --->
	<tr> 
	<td class="header">&nbsp;Rank*:</td>
	<td width="50%" class="regular"> 
	<cfselect name="Rank" required="Yes">
	<cfoutput query="Rank"> 
	<option value="#Rank#" <cfif #FORM.Rank# eq #Rank#>selected</cfif>>#Description#</option>
	</cfoutput> </cfselect></td>
	</tr>
	<!--- Field: Category --->
	<tr>
	<td class="header">&nbsp;Category*:</td>
	<td width="50%" class="regular"> 
	<cfselect name="Category" required="Yes">
	<cfoutput query="Category">
	<option value="#Category#" <cfif #FORM.Category# EQ #Category#>selected</cfif>>#Category#</option>
	</cfoutput></cfselect></td>
	</tr>
	
	<!--- Field: PlannedDeployment --->
	<tr>
	<td class = "Header">&nbsp;Planned deployment date(dd/mm/yy)*:</td>
	<td width="50%" class = "regular">
	<cfif #CLIENT.DateFormatShow# is "EU">
		<cfinput class="regular" type="Text" name="PlannedDeployment" value="#FORM.PlannedDeployment#" message="Date Available for Deployment: Please enter a correct date format" required="Yes" validate="eurodate" size="12" maxlength="16">
	<cfelse>
		<cfinput class="regular" type="Text" name="PlannedDeployment" value="#FORM.PlannedDeployment#" message="Date Available for Deployment: Please enter a correct date format" required="Yes" validate="date" size="12" maxlength="16">
	</cfif>	</td>
	</tr>
	<!--- Field: Date Joined Police --->
	<cfif IsDefined("FORM.ServiceJoinDate")>
	<tr> 
	<td class = "header">&nbsp;Date Joined Service (dd/mm/yy): <font color="red"><b>NEW!</b></font></td>
	<td width="50%" class="regular"> 
	<cfif #CLIENT.DateFormatShow# is "EU">
		<cfinput class="regular" type="Text" value="#FORM.ServiceJoinDate#" name="ServiceJoinDate" message="Date joined police: Please enter a correct date format" validate="eurodate" required="No" size="12" maxlength="16">
	<cfelse>
		<cfinput class="regular" type="Text" value="#FORM.ServiceJoinDate#" name="ServiceJoinDate" message="Date joined police: Please enter a correct date format" validate="date" required="No" size="12" maxlength="16">
	</cfif>
	</td>
	</tr>
	</cfif>
    <!--- Field: SAT Date 10May04 --->
	<cfif IsDefined("FORM.SatDate")>
	<tr> 
   	<td class = "header">&nbsp;SAT date (dd/mm/yy): <font color="red"><b>NEW!</b></font></td>
	<td width="50%" class="regular"> 
    <cfif #CLIENT.DateFormatShow# is "EU">
   	    <cfinput class="regular" type="Text" name="SatDate" value="#Form.SatDate#" message="SAT Date: Please enter a correct date format" required="no" validate="eurodate" size="12" maxlength="16">
    <cfelse>
   	    <cfinput class="regular" type="Text" name="SatDate"  value="#Form.SatDate#" message="SAT Date: Please enter a correct date format" required="no" validate="date" size="12" maxlength="16">
	</cfif>
	</td>
    </tr>
    </cfif>  
	
	<!--- Field: PassportNumber --->
	<cfset sPassportNo = Ucase(#FORM.PassportNo#)>
	<tr> 
	<td class="header">&nbsp;Passport Number:</td>
	<td> <cfinput type="Text" name="PassportNo" value="#sPassportNo#" message="Please enter a valid passport number" size="20" maxlength="20" class="regular"> </td>
	</tr>
	<!-- Passport issue date -->
	<tr> 
	<td class = "Header">&nbsp;Passport issue (dd/mm/yy):</td>
	<td width="50%" class = "regular"> 
	<cfif #CLIENT.DateFormatShow# is "EU">
		<cfinput class="regular" type="Text" name="PassportIssue" value="#FORM.PassportIssue#" message="Passport Issue Date: Please enter a correct date format" validate="eurodate" size="12" maxlength="16">
	<cfelse>
		<cfinput class="regular" type="Text" name="PassportIssue" value="#FORM.PassportIssue#" message="Passport Issue Date: Please enter a correct date format" validate="date" size="12" maxlength="16">
	</cfif>
	</td>
	</tr>
	<!-- Passport expiry date -->
	<tr> 
	<td class = "Header">&nbsp;Passport expiry(dd/mm/yy):</td>
	<td width="50%" class = "regular"> 
	<cfif #CLIENT.DateFormatShow# is "EU">
		<cfinput class="regular" type="Text" name="PassportExpiry" value="#FORM.PassportExpiry#" message="Passport Expiry Date: Please enter a correct date format" validate="eurodate" size="12" maxlength="16">
	<cfelse>
		<cfinput class="regular" type="Text" name="PassportExpiry" value="#FORM.PassportExpiry#" message="Passport Expiry Date: Please enter a correct date format" validate="date" size="12" maxlength="16">
	</cfif> </td>
	</tr>
	<!-- Remarks -->
	<tr>
	<td class="header">&nbsp;Remarks:<p></td>
	<td><textarea cols="60" rows="2" class="regular" name="Remarks"><cfoutput>#FORM.Remarks#</cfoutput></textarea></td>
	</tr>

	<tr> <td width="50%" height="5"></td> </tr>  <!-- extra line -->

	<!-- Add button -->
	<tr bgcolor="#FFFFFF"> 
	<td height="7" colspan="2"> <input class="input.button1" type="submit" name="select2" value="Add New Person"></td>
	</tr>	
	
	<tr bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>		<!-- extra line -->
  </table>
</table>
</cfform>

</body></cfif>
</HTML>