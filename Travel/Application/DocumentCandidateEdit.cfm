<!--- Prosis template framework --->
<cfsilent>
 <proUsr>administrator</proUsr>
 <proOwn>Hanno van Pelt</proOwn>
 <proDes>Generic Logon</proDes>
21sep07 - removed call to CF_DialogHeaderSub.  Created single button with call to window.print(); changed input button to use class="input.button1".
 <proCom>Changed release no</proCom>
</cfsilent>
<!--- End Prosis template framework --->

<!-- 
	Travel/Application/DocumentCandidateEdit.cfm
	
	Display candidate edit page
	
	Calls: CandidateEntrySubmit.cfm
    Includes: Travel/Application/Template/DocumentCandidateEdit_Lines.cfm
	
	Modification history:
	23Oct03 - added code to, for UNMO requests, display droplist of persons rotating 
			  out of the field mission			  
	17Feb04 - added new query GetPassport to handle retrieval of passport data from PersonDocument table
	10Aug04 - changed Planned Deployment Date field label to Expected Deployment Date
	21sep07 - removed call to CF_DialogHeaderSub.  Created single button with call to window.print().
		- changed input button to use class="input.button1".
	14Oct09 - MM: edited test to establish if current user has access to edit the candidate fields. this
		  is in consideration of using the Authorization Role user interface to give PMSTARS 
		  role CPDSuper Global access permissions

-->

<HTML><HEAD><TITLE>Nominee - Edit</TITLE></HEAD>

<body background="../Images/background.gif" class="dialog">
<link rel="stylesheet" type="text/css" href="../../<cfoutput>#client.style#</cfoutput>"> 

<cf_preventCache>

<SCRIPT LANGUAGE = "JavaScript">
function history(vacno,actid) {
	window.open("Template/DocumentActionHistory.cfm?ID=" + vacno + "&ID1=" + actid, "documenthistory", "width=500, height=330, toolbar=no, scrollbars=no, resizable=no");
}

function closing() {
	window.close();
	opener.location.reload()
}

function ask() {
	if (confirm("Do you want to submit the updated information ?")) {	
		return true 
	}	
	return false	
}	

function reinstate(vacno,persno) {
	if (confirm("Do you want to reinstate this candidate ?")) {
		window.open("Template/DocumentCandidateReinstateSubmit.cfm?ID=" + vacno + "&ID1=" + persno, "actionsubmit", "width=200, height=200, toolbar=no, scrollbars=no, resizable=no");
	}	
	return false	
}	
</SCRIPT>

<cfinclude template="Dialog.cfm">
<cfparam name="URL.IDArea" default="All">

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter 
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="Get" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT D.*, C.TravellerType FROM Document D, Ref_Category C	
	WHERE D.DocumentNo = '#URL.ID#'
	AND   D.PersonCategory = C.Category
</cfquery>

<cfquery name="P_Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT PermanentMissionId, Description FROM Ref_PermanentMission
	WHERE PermanentMissionId = #get.PermanentMissionId#
</cfquery>

<cfquery name="Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission FROM Ref_Mission ORDER BY Mission
</cfquery>

<cfquery name="Category" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category FROM Ref_Category
	WHERE Hybrid_ind = 0
	ORDER BY Category
</cfquery>

<cfquery name="Class" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM  FlowClass
	WHERE ActionClass = #get.ActionClass#
</cfquery>

<cfquery name="Rank" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Ref_Rank
	ORDER BY Description
</cfquery>

<cfquery name="Nation" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT CODE, NAME FROM Ref_Nationality
	WHERE Operational = '1'
	ORDER BY NAME
</cfquery>

<cfquery name="GetCandidate" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT P.*, P.FirstName + ' ' + Upper(P.LastName) AS PersonName, DRP.PersonNo AS RotatingPerson,
			PN.Name AS PresentNationalityName, BN.Name AS BirthNationalityName, R.Description AS RankDesc
    FROM  EMPLOYEE.DBO.Person P LEFT OUTER JOIN 
		  DocumentRotatingPerson DRP ON P.PersonNo = DRP.ReplacementPersonNo LEFT OUTER JOIN
		  Ref_Nationality PN ON P.Nationality = PN.Code LEFT OUTER JOIN
		  Ref_Nationality BN ON P.BirthNationality = BN.Code LEFT OUTER JOIN
		  Ref_Rank R ON P.Rank = R.Rank
	WHERE P.PersonNo = '#URL.ID1#'
	ORDER BY Rotatingperson DESc
</cfquery>

<cfquery name="GetPassport" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM EMPLOYEE.DBO.PersonDocument D
	WHERE D.PersonNo = '#URL.ID1#'
	AND   D.DocumentType = 'Passport'
<!---	AND   D.DocumentId = (SELECT Max(D1.DocumentId)
						  FROM EMPLOYEE.DBO.PersonDocument D1
	                      WHERE D1.PersonNo = D.PersonNo
						  AND   D1.DocumentType = D.DocumentType)  --->
</cfquery>

<cfquery name="GetCandidateStatus" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM DocumentCandidate	WHERE PersonNo = '#URL.ID1#'
	AND DocumentNo = '#URL.ID#'
</cfquery>

<cfquery name="GetRotatingPerson" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DRP.*, Upper(P.LastName) + ', ' + P.FirstName AS LastFirstName, P.FirstName + ' ' + Upper(P.LastName) AS FirstLastName
    FROM DocumentRotatingPerson DRP INNER JOIN EMPLOYEE.DBO.Person P ON DRP.PersonNo = P.PersonNo
	WHERE DocumentNo = '#URL.ID#'
	ORDER BY P.LastName, P.FirstName
</cfquery>

<cfset AllowEditIndex = "False">
<cfset AllowEditAll = "False">

<cfquery name="ChkUserAccess" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT Mission, AccessLevel 
	FROM OrganizationAuthorization 
	WHERE Mission = '#Get.Mission#'
	AND UserAccount = '#SESSION.acc#'	
	AND Role = 'DeskOfficer'
	AND ClassParameter = '#Get.TravellerType#' 
</cfquery>

<!--- Note: If no match is found by above query, rerun the same query but this time
    		look for a NULL in Mission column --->
<cfif #ChkUserAccess.RecordCount# EQ 0>
	<cfquery name="ChkUserAccess" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
	    SELECT DISTINCT Mission, AccessLevel 
		FROM OrganizationAuthorization 
		WHERE Mission IS NULL
		AND UserAccount = '#SESSION.acc#'	
		AND Role IN ('FgsDo','FgsRc','FgsSuper','CpdDo','CpdAa','CpdSuper')
		AND ClassParameter = '#Get.TravellerType#'
	</cfquery>
</cfif>

<cfif #ChkUserAccess.RecordCount# GT 0>
	<cfif #ChkUserAccess.AccessLevel# EQ 0>
		<cfset AllowEditIndex = "True">
	</cfif>
	<!---	MM 14/10/09 - edited line below to change test --->
	<!--- 	{cfif #ChkUserAccess.AccessLevel# EQ 1}	--->
	<cfif #ChkUserAccess.AccessLevel# GT 0>	  
		<cfset AllowEditAll = "True">	
	</cfif>	
</cfif>

<BODY onLoad="window.focus()">

<CFFORM action="DocumentCandidateEditSubmit.cfm" method="POST" name="documentcandidateedit">

<cfoutput>
<input type="hidden" name="AreaSelect" value="#URL.IDArea#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <cfset dep_date = DateFormat(#Get.PlannedDeployment#,"dd/mm/yy")>	
  <tr>
    <td height="30" align="left" valign="middle" bgcolor="#002350">
	<font face="Tahoma" size="2" color="#FFFFFF">
	<b>&nbsp;Req#: <font color="#33CCFF"><cfoutput>#Get.DocumentNo#</cfoutput></font>
	&nbsp;&nbsp;Permanent Mission: <font color="#33CCFF"><cfoutput>#p_mission.Description#</cfoutput></font>
	&nbsp;&nbsp;Field mission: <font color="#33CCFF"><cfoutput>#Get.Mission#</cfoutput></font>
	&nbsp;&nbsp;Planned Deployment: <font color="#33CCFF"><cfoutput>#dep_date#</cfoutput></font></b>
	</font>
	</td>
	
	<td height="30" align="right" valign="middle" bgcolor="002350">
	
	</font>
	
<!---   MM, 21/9/07
		This function no longer supported.
	<CF_DialogHeaderSub 
	MailSubject="Document Candidate" 
	MailTo="" 
	MailAttachment="" 
	ExcelFile=""
	CloseButton="No"> 

	replaced by next line
--->	
    <input type="button" class="input.button1" name="Print" value="  Print  " title="Print the contents of the window" onClick="javascript:window.print()">	

	<cfif (#AllowEditIndex# OR #AllowEditAll#) AND #Get.Status# is "0">
   		<input type="submit" class="input.button1" name="Submit" value=" Save ">
	</cfif>
   	<input type="button" class="input.button1" name="Close" value=" Close " onClick="javascript:closing()">	
		
    </td>			
  </tr> 	
  
  <tr>
    <td height="16" align="left" bgcolor="6688aa" class="topN">		
	&nbsp;&nbsp;&nbsp;Number and Type of personnel requested:&nbsp;<font color="#FFCC33"><cfoutput>#get.PersonCount#</cfoutput></font> - <font color="#FFCC33"><cfoutput>#get.PersonCategory#</cfoutput></font>
	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Workflow:&nbsp;<font color="#FFCC33"><cfoutput>#Class.Description#</cfoutput></font>
	</td>	
	<td align="right" class="topN" bgcolor="002350">	
	<cfoutput>	
	<cfswitch expression="#GetCandidateStatus.Status#">
	<cfcase value="0">	
		<input type="text" name="Status" value="In Process" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   			
	</cfcase>
	<cfcase value="3">
		<input type="text" name="Status" value="In Process" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   
	</cfcase>
    <cfcase value="6">
		<input type="text" name="Status" value="On hold" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   
		<input type="button" name="Select" value="Reinstate" class="input.button1" onClick="javascript:reinstate('#URL.ID#','#URL.ID1#')">   
	</cfcase>	
	<cfcase value="9">
		<input type="text" name="Status" value="Revoked" size="8" maxlength="8" readonly style="color: Black; text-align: center; border-bottom-style: solid; border-bottom-width: 1px;">   
		<input type="button" name="Select" value="Reinstate" class="input.button1" onClick="javascript:reinstate('#URL.ID#','#URL.ID1#')">	
	</cfcase>
	</cfswitch>
	</cfoutput>
	&nbsp;
	</td>
  </tr> 	
     
  <tr>
    <td width="100%" colspan="2">
    
<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse" bordercolor="#111111" width="100%">
  <tr> 
    <td width="25%" height="10" class="header"></td>
  </tr>
  <cfoutput> 
    <input type="hidden" name="personno" value="#URL.ID1#", size="20" maxlength="20" readonly>
    <input type="hidden" name="mission" value="#get.Mission#" size="30" maxlength="30" class="disabled" readonly>
    <input type="hidden" name="documentno" value="#Get.DocumentNo#">
    <input type="hidden" name="CanEditIndex" value="#AllowEditIndex#">
  </cfoutput> 

	<!-- If UNMO request, identify person being replaced -->
  <cfif #get.TravellerType# EQ 'MILITARY'>
  	<tr>
		<td class="header">&nbsp;Person being replaced<cfif #AllowEditAll#>*</cfif>:</td>
		<td colspan="3" class="regular">	
		<cfif #AllowEditAll#>
			<cfselect name="RotatingPersonNo" required="Yes">
				<option value=0<cfif '#GetCandidate.RotatingPerson#' eq "">selected</cfif>>
					<font face="Tahoma" size="3">Unknown</font>
	    		<cfoutput query="GetRotatingPerson">
				<option value="#GetRotatingPerson.PersonNo#" <cfif #GetRotatingPerson.PersonNo# is #GetCandidate.RotatingPerson#>selected</cfif>>
					<font face="Tahoma" size="3">#GetRotatingPerson.LastFirstName#</font>
				</option>
			</cfoutput>
			</cfselect>	
		<cfelse>
			<cfoutput> 
		    <input type="hidden" name="RotatingPersonNo" value="#GetRotatingPerson.PersonNo#" size="20">
			&nbsp;#GetRotatingPerson.FirstLastName#
			</cfoutput>
		</cfif>	
		</td>
	</tr>
  </cfif>	 
  
  <!-- Index No --->
  <tr>
    <td class="header">&nbsp;IndexNo:</td>
	<td colspan="3" class="regular">
	<cfoutput>
	<cfif #AllowEditIndex# OR #AllowEditAll#>
   		<input type="text" name="IndexNo" value="#GetCandidate.IndexNo#" size="10" maxlength="10" class="regular">		
      	<input class="input.button1" type="button" name="Search" value="..." 
		onClick="javascript:pm_findperson('documentcandidateedit','IndexNo',
		'#GetCandidate.LastName#','#Dateformat(GetCandidate.BirthDate, CLIENT.DateFormatShow)#','#GetCandidate.Nationality#')"> 
	<cfelse>
	    <input type="hidden" name="IndexNo" value="#GetCandidate.IndexNo#" size="10">
		&nbsp;#GetCandidate.IndexNo#
	</cfif>
	</cfoutput>
	</td>
  </tr> 
  
  <tr> 
    <td class="header">&nbsp;Last name<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular">
	<cfif #AllowEditAll#>		
		<cfinput type="Text" name="lastname" value="#GetCandidate.LastName#" message="Please enter candidate last name" required="Yes" size="40" maxlength="40" class="regular">
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="lastname" value="#GetCandidate.LastName#" size="30">	
		&nbsp;#GetCandidate.LastName#
		</cfoutput>
	</cfif>
	</td>
  </tr>
  
  <tr> 
    <td class="header">&nbsp;First name<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular">
	<cfif #AllowEditAll#>		
		<cfinput type="Text" name="firstname" value="#GetCandidate.FirstName#" message="Please enter candidate first name" required="Yes" size="30" maxlength="30" class="regular">
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="firstname" value="#GetCandidate.FirstName#" size="30">	
		&nbsp;#GetCandidate.FirstName#
		</cfoutput>
	</cfif>
	</td>
  </tr>
  
  <tr> 
    <td class="header">&nbsp;Middle name:</td>
    <td class="regular">
	<cfif #AllowEditAll#>
    	<cfinput type="Text" name="middlename" value="#GetCandidate.MiddleName#" message="Please enter candidate middle name" required="No" size="25" maxlength="25" class="regular">
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="middlename" value="#GetCandidate.MiddleName#" size="30">
		&nbsp;#GetCandidate.MiddleName#
		</cfoutput>
	</cfif>
	</td>
  </tr>  
  
  <tr> 
    <td class="header">&nbsp;Date of Birth (dd/mm/yy)<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular"> 
	<cfset disp_date = DateFormat(#GetCandidate.BirthDate#,"dd/mm/yy")> 
	<cfif #AllowEditAll#>	
      	<cfif #CLIENT.DateFormatShow# is "EU">
        	<cfinput class="regular" type="Text" name="BirthDate" value="#disp_date#" message="Date of birth: Please enter a correct date format" validate="eurodate" required="Yes" size="12" maxlength="16">
		<cfelse>
        	<cfinput class="regular" type="Text" name="BirthDate" value="#disp_date#" message="Date of birth: Please enter a correct date format" validate="date" required="Yes" size="12" maxlength="16">
      	</cfif> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="BirthDate" value="#disp_date#" size="8">
		&nbsp;#disp_date#
	    </cfoutput>
	</cfif>
	</td>
  </tr>

  <tr> 
    <td class="header">&nbsp;Gender<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular"> 
	<cfif #AllowEditAll#>
		<cfif #GetCandidate.Gender# eq "M">
    	    <INPUT type="radio" name="Gender" value="M" checked>Male 
        	<INPUT type="radio" name="Gender" value="F">Female 
        <cfelse>
	        <INPUT type="radio" name="Gender" value="M">Male 
	        <INPUT type="radio" name="Gender" value="F" checked>Female
		</cfif> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="Gender" value="#GetCandidate.Gender#" size="1">
		&nbsp;<cfif #GetCandidate.Gender# eq "M">Male<cfelse>Female</cfif>
		</cfoutput>		
	</cfif>		
	</td>
  </tr>
  <!-- PresentNationality -->
  <tr> 
    <td class="header">&nbsp;Present Nationality<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular">
	<cfif #AllowEditAll#>
	    <cfselect name="Nationality" required="Yes">
        <cfoutput query="Nation"> 
          <option value="#Code#" <cfif #Code# eq #GetCandidate.Nationality#> selected </cfif>>#Name#</option>
        </cfoutput>
		</cfselect> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="Nationality" value="#GetCandidate.Nationality#" size="3">	
		&nbsp;#GetCandidate.PresentNationalityName#
		</cfoutput>
	</cfif>
	</td>
  </tr>
  <!-- Nationality at birth -->
  <tr>
    <td class="header">&nbsp;Nationality at birth<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular">
	<cfif #AllowEditAll#>
  	    <cfselect name="BirthNationality" required="Yes">
        <cfoutput query="Nation"> 
          <option value="#Code#" <cfif #Code# eq #GetCandidate.BirthNationality#> selected </cfif>>#Name#</option>
        </cfoutput> 
		</cfselect> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="BirthNationality" value="#GetCandidate.BirthNationality#" size="3">	
		&nbsp;#GetCandidate.BirthNationalityName#
		</cfoutput>
	</cfif>
	</td>
  </tr> 

  <tr> 
    <td class="header">&nbsp;Rank<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular">
	<cfif #AllowEditAll#>
		<cfselect name="Rank" required="Yes">
        <cfoutput query="Rank"> 
          <option value="#Rank#" <cfif #Rank# eq #GetCandidate.Rank#> selected </cfif>>#Description#</option>
        </cfoutput> 
		</cfselect> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="Rank" value="#GetCandidate.Rank#" size="10">
		&nbsp;#GetCandidate.RankDesc#
		</cfoutput>
	</cfif>
	</td>
  </tr>
  <!--- Field: Category --->
  <tr>
  <td class="header">&nbsp;Category<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular">
	<cfif #AllowEditAll#>
		<cfselect name="Category" required="Yes">
		<cfoutput query="Category">
		<option value="#Category#" <cfif #Category# eq #GetCandidate.Category#> selected </cfif>>#Category#</option>
		</cfoutput>
		</cfselect>	
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="Category" value="#GetCandidate.Category#" size="10">	
		&nbsp;#GetCandidate.Category#
		</cfoutput>
	</cfif>
	</td>
  </tr>

  <tr> 
    <td class="header">&nbsp;Expected deployment date (dd/mm/yy)<cfif #AllowEditAll#>*</cfif>:</td>
    <td class="regular"> 
	<cfset disp_date = DateFormat(#GetCandidateStatus.PlannedDeployment#,"dd/mm/yy")> 
	<cfif #AllowEditAll#>	
      	<cfif #CLIENT.DateFormatShow# is "EU">
        	<cfinput class="regular" type="Text" name="PlannedDeployment" value="#disp_date#" message="Date available for deployment: Please enter a correct date format" required="yes" validate="eurodate" size="12" maxlength="16">
		<cfelse>
        	<cfinput class="regular" type="Text" name="PlannedDeployment" value="#disp_date#"  message="Date available for deployment: Please enter a correct date format" required="yes" validate="eurodate" size="12" maxlength="16">
      	</cfif> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="PlannedDeployment" value="#disp_date#" size="8">
		&nbsp;#disp_date#
		</cfoutput>
	</cfif>
	</td>
  </tr>
  
  <cfif #get.TravellerType# EQ "CIVPOL">
	<tr> 
	<td class="header">&nbsp;Date Joined Service (dd/mm/yy):</td>
	<td class="regular"> 
	<cfset disp_date = DateFormat(#GetCandidate.ServiceJoinDate#,"dd/mm/yy")> 	
	<cfif #AllowEditAll#>		
		<cfif #CLIENT.DateFormatShow# is "EU">
			<cfinput class="regular" type="Text" value="#disp_date#" name="ServiceJoinDate" message="Date joined service: Please enter a correct date format" required="No" size="12" maxlength="16">
		<cfelse>
			<cfinput class="regular" type="Text" value="#disp_date#" name="ServiceJoinDate" message="Date joined service: Please enter a correct date format" required="No" size="12" maxlength="16">
		</cfif>
		&nbsp;Four-digit year in field defaults to 31 Dec.
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="ServiceJoinDate" value="#disp_date#" size="8">	
		&nbsp;#disp_date#
		</cfoutput>
	</cfif>
	</td>
	</tr>
  
  	<tr> 
    <td class="header">&nbsp;SAT date (dd/mm/yy):</td>
    <td class="regular">
	<cfset disp_date = DateFormat(#GetCandidateStatus.SatDate#,"dd/mm/yy")> 
	<cfif #AllowEditAll#>		
	    <cfif #CLIENT.DateFormatShow# is "EU">
    	    <cfinput class="regular" type="Text" name="SatDate" value="#disp_date#" message="SAT Date: Please enter a correct date format" required="no" validate="eurodate" size="12" maxlength="16">
	    <cfelse>
    	    <cfinput class="regular" type="Text" name="SatDate"  value="#disp_date#" message="SAT Date: Please enter a correct date format" required="no" validate="date" size="12" maxlength="16">
	    </cfif>
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="SatDate" value="#disp_date#" size="8">
		&nbsp;#disp_date#
		</cfoutput>
	</cfif>
	</td>
	</tr>
  </cfif>  

  <tr> 
    <td class="header">&nbsp;Passport Number:</td>
    <td class="regular">
	<cfif #AllowEditAll#>		
		<cfinput type="Text" name="PassportNo" value="#GetPassport.DocumentReference#" message="Please enter a valid passport number" size="20" maxlength="20" class="regular"> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="PassportNo" value="#GetPassport.DocumentReference#" size="20">
		&nbsp;#GetPassport.DocumentReference#
		</cfoutput>
	</cfif>		
    </td>
  </tr>

  <tr> 
    <td class="header">&nbsp;Passport Issue Date (dd/mm/yy):</td>
    <td class="regular">
	<cfset disp_date = DateFormat(#GetPassport.DateEffective#,"dd/mm/yy")> 
	<cfif #AllowEditAll#>		
		<cfif #CLIENT.DateFormatShow# is "EU">
        	<cfinput class="regular" type="Text" value="#disp_date#" name="PassportIssue" message="Please enter a correct date format" validate="eurodate" size="12" maxlength="16">
        <cfelse>
	        <cfinput class="regular" type="Text" value="#disp_date#" name="PassportIssue" message="Please enter a correct date format" validate="date" size="12" maxlength="16">
    	</cfif> 
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="PassportIssue" value="#disp_date#" size="8">	
		&nbsp;#disp_date#
		</cfoutput>
	</cfif>
	</td>
  </tr>

  <tr>
    <td class="header">&nbsp;Passport Expiry Date (dd/mm/yy):</td>
    <td class="regular">
	<cfset disp_date = DateFormat(#GetPassport.DateExpiration#,"dd/mm/yy")> 
	<cfif #AllowEditAll#>		
    	<cfif #CLIENT.DateFormatShow# is "EU">
        	<cfinput class="regular" type="Text" value="#disp_date#" name="PassportExpiry" message="Please enter a correct date format" validate="eurodate" size="12" maxlength="16">
        <cfelse>
        	<cfinput class="regular" type="Text" value="#disp_date#" name="PassportExpiry" message="Please enter a correct date format" validate="date" size="12" maxlength="16">
		</cfif>
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="PassportExpiry" value="#disp_date#" size="8">		
		&nbsp;#disp_date#
		</cfoutput>
	</cfif>
	</td>
  </tr>

  <tr> 
    <td valign="top" class="header">&nbsp;Remarks</td>
    <td colspan="3" class="regular">
	<cfif #AllowEditAll#>		
		<textarea cols="50" rows="4" name="Remarks" value="#GetCandidateStatus.Remarks#" class="regular"></textarea>
	<cfelse>
		<cfoutput>
	    <input type="hidden" name="Remarks" value="#GetPassport.Remarks#" size="200">
		&nbsp;#GetCandidateStatus.Remarks#
		</cfoutput>
	</cfif>
	</td>
  </tr>

  <!-- Print row with comment on mandatory fields -->
  <cfif #AllowEditAll#>
    <tr>
	    <td class="header">&nbsp;</td>
    	<td colspan="3"><font face="tahoma" color="#000000" size="1">Note: An asterisk (*) after the field label indicates a mandatory field.</font></td>
	</tr>
  </cfif>

  <!-- Print column titles -->
  <tr> 
    <td colspan="4" align="center"></td>
    <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
      <tr bgcolor="#6688AA" bordercolor="#808080"> 
        <td class="topN">&nbsp;Status</td>
        <td class="topN">&nbsp;&nbsp;Activity</font></td>
        <td class="topN">Planning</font></td>
        <td class="topN">Started</font></td>
        <td class="topN">Completed</font></td>
        <td class="topN">Officer</font></td>
        <td class="topN">Date</font></td>
        <td class="topN">Action</font></td>
  </tr>
      <cfset element = 1>
      <cfset elementundo = 1>
      <cfset show = "1">
  <tr> 
      <td class="header" height="10" colspan="8"></td>
  </tr>
      <cfinclude template="../../Travel/Application/Template/DocumentCandidateEdit_Lines.cfm">
  </table></td>
  <tr> 
    <td height="10" colspan="4" class="topN"></td>
  </tr>
</table>

<hr>
&nbsp;
<cfif (#AllowEditIndex# OR #AllowEditAll#) AND #Get.Status# is "0">
   <input type="submit" class="input.button1" name="Submit" value="   Save   ">
</cfif>
<input type="button" class="input.button1" name="Close" value="  Close  " onClick="javascript:closing()">

</CFFORM>

</BODY></HTML>