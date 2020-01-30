<!---
	PersonAssignmentEdit.cfm  (formerly PersonDepartureEdit.cfm
	
	Edit page for Person Assignments
	
	Calls:
	PersonAssignmentEditSubmit.cfm
	
	Modification history:
	27Apr04 - added code to allow update of	FunctionNo, FunctionDescription field
	15May04 - added code to limit edit to Arrival and Departure for users not in Militay and Civpol account group
	30Jun04 - added code to control access rights (VIEW, EDIT, LIMITED) to allow readonly, edit all fields except name, or edit only 
		      ActualArrival and ActualDeparture date fields , respectively.
			  Currently, only FGS and CIVPOL users have EDIT rights.  UNMIL-Military users have LIMITED rights.  All others have VIEW rights.
	08Sep04 - renamed module to PersonAssignmentEdit.cfm
	        - added Person No, Request No, Source, Processed On, Processed By
	04Oct04 - added left join to travel.dbo.document to retrieve PlannedDeployment date column to be used in the Planned Deployment Date
			  field on this page.  This will now be a read-only field.  Note that if there is no matching Document record, the PlannedDeployment date
			  will be null.  This modification was requested by FM today, and approved by JS.
--->	
<HTML><HEAD><TITLE>Assignment Details</TITLE></HEAD>

<body bgcolor="#FFFFFF" onLoad="window.focus()">
<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<script language="Javascript">
function closing() {
   window.close()
   opener.location.reload()
}
</script>

<!--- Get authorized PostType that current user is allowed to access --->
<cfquery name="AuthorizedPostType" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT RC.TravellerType AS PostType
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	ORDER BY RC.TravellerType
</cfquery>
 
<cfquery name="UserAccountGroup" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AccountGroup FROM SYSTEM.DBO.USERNAMES 
	WHERE Account LIKE '#SESSION.acc#'
</cfquery>

<cfquery name="FunctionNo" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT FunctionNo, FunctionDescription
    FROM  FunctionTitle
	WHERE FunctionClass IN ('Military', 'Civpol')
	ORDER BY FunctionDescription
</cfquery>

<!--- Assignment query modified 04Oct04 to add left join to travel.dbo.document table --->
<cfquery name="Assignment" datasource="AppsEmployee" maxrows=1 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT PO.Mission, PO.PostType, A.*, Upper(P.LastName) AS LastName, 
	       P.FirstName, P.IndexNo, F.FunctionDescription, D.PlannedDeployment,
		   (CASE WHEN (A.DateExpiration = PO.DateExpiration) THEN 
		   			NULL 
				 ELSE 
				 	A.DateExpiration END) AS ActualDeparture,
		   (CASE WHEN A1.AssignmentNo IS NULL THEN
			   		A.OfficerFirstName + ' ' + Upper(A.OfficerLastName)
		    	 ELSE 
	 		   		A1.OfficerFirstName + ' ' + Upper(A1.OfficerLastName) END) AS CreatedBy,
		   (CASE WHEN A1.AssignmentNo IS NULL THEN
			   		A.Created
		    	 ELSE 
	 		   		A1.Created END) AS CreatedOn					
    FROM  PersonAssignment A INNER JOIN 
		  Position PO ON A.PositionNo = PO.PositionNo INNER JOIN
	      Person P ON A.PersonNo = P.PersonNo LEFT JOIN
		  TRAVEL.DBO.Document D ON A.ParentId = D.DocumentNo LEFT JOIN 
		  APPLICANT.DBO.FunctionTitle F ON A.FunctionNo = F.FunctionNo LEFT JOIN
		  PersonAssignment A1 ON A.SourceId = A1.AssignmentNo
	WHERE A.AssignmentNo = #URL.ID#
</cfquery>

<!--- 29Oct04. Determine if user has permissions to edit assignment fields --->
<cfset AllowAssignEdit = "False">
<cfset sPassThrough = "disabled">	

<cfquery name="ChkUserAccess" datasource="AppsOrganization" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT Mission, AccessLevel 
	FROM OrganizationAuthorization 
	WHERE Mission = '#Assignment.Mission#'
	AND Role = 'PmAssignEditor'
	AND UserAccount = '#SESSION.acc#'	
	AND ClassParameter = '#Assignment.PostType#'
</cfquery>

<!--- Note: If no match is found by above query, rerun the same query but this time
    		look for a NULL in Mission column --->
<cfif #ChkUserAccess.RecordCount# EQ 0>
	<cfquery name="ChkUserAccess" datasource="AppsOrganization" 
	 username="#SESSION.login#" password="#SESSION.dbpw#">
	    SELECT DISTINCT Mission, AccessLevel 
		FROM OrganizationAuthorization 
		WHERE Mission IS NULL
		AND Role = 'PmAssignEditor'
		AND UserAccount = '#SESSION.acc#'	
		AND ClassParameter = '#Assignment.PostType#'
	</cfquery>
</cfif>

<cfif #ChkUserAccess.RecordCount# GT 0>
	<!--- If match is found and accesslevel value is 2, allow EDIT access to this document --->
	<cfif #ChkUserAccess.AccessLevel# EQ 1>
		<cfset AllowAssignEdit = "True">
		<cfset sPassThrough = "">
	</cfif>
</cfif>
 
<cfform action="PersonAssignmentEditSubmit.cfm" method="POST" name="PersonAssignmentEdit">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Assignment Details</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<cfif #AllowAssignEdit#>	
		<input type="submit" class="input.button1" name="Save" value=" Submit ">
	</cfif>
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">	>
	&nbsp;
	</td>
</tr> 	
	
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">	

  <cfif #AllowAssignEdit#>
	<tr><td class="header" height="10" colspan="2"></td></tr>  
	<tr><td class="header" height="10" colspan="2">&nbsp;<font color="red">Instructions:</font></td></tr>
	<tr><td class="header" height="10" colspan="2">&nbsp;</td>
  	<tr><td class="header" height="10" colspan="2">&nbsp;1. Use this page to modify an individual's assignment details.  Date fields require valid date entries.</td></tr>
	<tr><td class="header" height="10" colspan="2">&nbsp;2. To specify a departure, input a valid date entry in the Actual Departure Date field, or delete an existing departure date to revoke the recorded departure.</td></tr>
	<tr><td class="header" height="10" colspan="2">&nbsp;3. If the Actual Arrival Date is <u>earlier or later</u> than the Planned Deployment Date, the Desk Officer must adjust the Expected Date of Rotation based on the TOD.</td></tr>
	<tr><td class="header" height="10" colspan="2">&nbsp;4. Please route requests for additions to the list of functions to the database focal point(s) in your service/section.</td></tr>   
	<tr><td class="header" height="10" colspan="2">&nbsp;5. An asterisk after the field label indicates a mandatory entry field.</td></tr>   
  </cfif>

  <tr><td class="header" height="5" colspan="1"></td></tr>

  <tr>
	  <td class="header">&nbsp;Person No:</td>
	  <td class="regular">&nbsp;
	  <cfinput type="Text" name="PersonNo" value="#Assignment.PersonNo#" required="No" size="20" class="regular" passThrough="disabled">
	  </td>
  </tr>
 
  <tr><td height="4" colspan="1" class="header"></td></tr>
  
  <tr>
	  <td class="header">&nbsp;Person Name:</td>
	  <td class="regular">&nbsp;
	  <cfinput type="Text" name="PersonName" value="#Assignment.FirstName# #Assignment.LastName#" required="No" size="50" class="regular" passThrough="disabled">
	  </td>
  </tr>
 
  <tr><td height="4" colspan="1" class="header"></td></tr>

  <cfoutput>	
  <input type="hidden" name="AssignNo" value="#Assignment.AssignmentNo#" class="disabled" size="10" maxlength="10" readonly>	
  <input type="hidden" name="AllowAssignEditFlag" value="#AllowAssignEdit#" class="disabled" size="5" maxlength="5" readonly>	  
  </cfoutput>

  <tr>
	  <td class="header">&nbsp;Assignment No:</td>
	  <td class="regular">&nbsp;
	  <cfinput type="Text" name="AssignmentNo" value="#Assignment.AssignmentNo#" required="No" size="10" class="regular" passThrough="disabled">
	  </td>
  </tr>
 
  <tr><td height="4" colspan="1" class="header"></td></tr>

  <tr>
	  <td class="header">&nbsp;Source:</td>
	  <td class="regular">&nbsp;
	  <cfinput type="Text" name="Source" value="#Assignment.Parent#" required="No" size="20" class="regular" passThrough="disabled">
	  </td>
  </tr>
			
  <tr><td height="4" colspan="1" class="header"></td></tr>

  <tr>
	  <td class="header">&nbsp;Request No:</td>
	  <td class="regular">&nbsp;
	  <cfinput type="Text" name="SourceId" value="#Assignment.ParentId#" required="No" size="10" class="regular" passThrough="disabled">
	  </td>
  </tr>
			
  <tr><td height="4" colspan="1" class="header"></td></tr>

  <tr>
	  <td class="header">&nbsp;Processed By:</td>
	  <td class="regular">&nbsp;
	  <cfinput type="Text" name="CreatedBy" value="#Assignment.CreatedBy#" required="No" size="50" class="regular" passThrough="disabled">
	  </td>
  </tr>
			
  <tr><td height="4" colspan="1" class="header"></td></tr>

  <tr>
	  <td class="header">&nbsp;Processed On:</td>
	  <td class="regular">&nbsp;
	    <cfinput type="Text" name="Created" value="#Dateformat(Assignment.CreatedOn, CLIENT.DateFormatShow)#" 
		 size="12" class="regular" style="text-align: center" passThrough="disabled">
	  </td>
  </tr>
			
  <tr><td height="4" colspan="1" class="header"></td></tr>
  	
  <tr>
	<td class="header">&nbsp;Function*:</td>
	<td class="regular">&nbsp;
	<cfif #AllowAssignEdit#>
	  	<cfselect name="FunctionNo" required="Yes">
	  	<cfoutput query="FunctionNo">
	  	<option value="#FunctionNo.FunctionNo#" <cfif #FunctionNo.FunctionNo# eq #Assignment.FunctionNo#> selected </cfif>>#FunctionNo.FunctionDescription#</option>
		</cfoutput>
		</cfselect>	
	<cfelse>
	    <cfinput type="Text" name="FunctionDescription" value="#Assignment.FunctionDescription#" size="50" class="regular" passThrough="disabled">
	</cfif>
	</td>
  </tr>
  
  <tr><td height="4" colspan="1" class="header"></td></tr>
  	  
  <tr> 
	<td class="header">&nbsp;Planned Deployment Date (dd/mm/yyyy):</td>
	<td class="regular">&nbsp;
	<!--- next block modified 04Oct04; old incorrect code deleted --->
	<cfoutput>
    <cfinput type="Text" name="PlannedDeployment" value="#Dateformat(Assignment.PlannedDeployment, CLIENT.DateFormatShow)#" 
	 size="12" class="regular" style="text-align: center" passThrough="disabled">
	</cfoutput>
	</td>
  </tr>

  <tr><td height="4" colspan="1" class="header"></td></tr>

  <tr> 
	<td class="header">&nbsp;Actual Arrival Date (dd/mm/yyyy)*:</td>
	<td class="regular">&nbsp;
	<cfif #AllowAssignEdit#>
	    <cf_intelliCalendarDate
		FormName="PersonDepartureEdit"
		FieldName="DateArrival"
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Assignment.DateArrival, CLIENT.DateFormatShow)#"
		AllowBlank="False">
	<cfelse>
		<cfoutput>
	    <cfinput type="Text" name="DateArrival" value="#Dateformat(Assignment.DateArrival, CLIENT.DateFormatShow)#" size="12" style="text-align: center" class="regular" passThrough="disabled">
		</cfoutput>
	</cfif>	
	</td>
  </tr>
	
  <tr><td height="4" colspan="1" class="header"></td></tr>	
  
  <tr>
    <td class="header">&nbsp;Expected Date of Rotation (dd/mm/yyyy)*:</td>
    <td class="regular">&nbsp;	
	<cfif #AllowAssignEdit#>
<!--- 31Oct04
	   <cf_intelliCalendarDate
		FormName="PersonDepartureEdit"		
		FieldName="DateExpiration" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Assignment.DateExpiration, CLIENT.DateFormatShow)#"
		AllowBlank="False">
--->						
	   <cf_intelliCalendarDate
		FormName="PersonDepartureEdit"		
		FieldName="DateDeparture" 		
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Assignment.DateDeparture, CLIENT.DateFormatShow)#"
		AllowBlank="False">
	<cfelse>
<!--- 31Oct04	
	    <cfinput type="Text" name="DateExpiration" value="#Dateformat(Assignment.DateExpiration, CLIENT.DateFormatShow)#" size="12" style="text-align: center" class="regular" passThrough="disabled">
--->
	    <cfinput type="Text" name="DateDeparture" value="#Dateformat(Assignment.DateDeparture, CLIENT.DateFormatShow)#" size="12" style="text-align: center" class="regular" passThrough="disabled">				
	</cfif>
	</td>
  </tr>
	
  <tr><td height="4" colspan="1" class="header"></td></tr>
	
  <tr>
    <td class="header">&nbsp;Actual Departure Date (dd/mm/yyyy):</td>
    <td class="regular">&nbsp;	
	<cfif #AllowAssignEdit#>
<!--- 31Oct04
 	  <cf_intelliCalendarDate
		FormName="PersonDepartureEdit"
		FieldName="DateDeparture" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Assignment.DateDeparture, CLIENT.DateFormatShow)#"
		AllowBlank="True">				
--->	
 	  <cf_intelliCalendarDate
		FormName="PersonDepartureEdit"
		FieldName="_tsDateActualDeparture" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(Assignment._tsDateActualDeparture, CLIENT.DateFormatShow)#"
		AllowBlank="True">
	<cfelse>
		<cfoutput>
<!--- 31Oct04		
	    <cfinput type="Text" name="DateDeparture" value="#Dateformat(Assignment.DateDeparture, CLIENT.DateFormatShow)#" size="12" style="text-align: center" class="regular" passThrough="disabled">		
--->
	    <cfinput type="Text" name="DateExpiration" value="#Dateformat(Assignment._tsDateActualDeparture, CLIENT.DateFormatShow)#" size="12" style="text-align: center" class="regular" passThrough="disabled">
		</cfoutput>
	</cfif>	
	</td>
  </tr>
   	
  <tr><td height="4" colspan="1" class="header"></td></tr>
	
  <tr>
    <td class="header">&nbsp;Remarks (100 chars max):</td>
    <TD class="regular">&nbsp;
	<cfif #AllowAssignEdit#>
		<textarea cols="50" class="regular" rows="2" name="Remarks"><cfoutput>#Assignment.Remarks#</cfoutput></textarea> </TD>
	<cfelse>
		<textarea cols="50" class="regular" rows="2" name="Remarks" disabled="yes"><cfoutput>#Assignment.Remarks#</cfoutput></textarea> </TD>	  
	</cfif>
  </tr>	
			
  <tr><td height="4" colspan="1" class="header"></td></tr>
  
</table>
</td>
</tr>
</table>

<table width="100%" bgcolor="#FFFFFF">
	<td align="right" class="regular">
	<td align="right" height="30" valign="middle">
	<cfif #AllowAssignEdit#>
		<input type="submit" class="input.button1" name="Save" value=" Submit ">
	</cfif>
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
     </td>
</table>

</CFFORM>
</BODY></HTML>