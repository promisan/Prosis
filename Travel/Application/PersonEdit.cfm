<!--
 	PersonEdit.cfm
	
	Generic Person edir form.
	
	Called by: Dialog.cfm/pm_editperson(personno)
	Calls: PersonEditSubmit.cfm
	
	Modification History:
	15Oct03 - created by MM
	10Jun03 - added code to make page readonly if user not in "Military" user group
-->
<HTML><HEAD><TITLE>Person - Edit</TITLE></HEAD>
<body background="../Images/background.gif" bgcolor="#FFFFFF">

<link href="../../../../../<cfoutput>#client.style#</cfoutput>" rel="stylesheet" type="text/css">

<cf_preventCache>


<cfparam name="URL.ID" default="0">

<cfinclude template="Dialog.cfm">

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="Class" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT *  FROM  FlowClass
</cfquery>

<cfquery name="Category" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category FROM Ref_Category
	WHERE Hybrid_ind = 0
	ORDER BY Category
</cfquery>

<cfquery name="Rank" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM  Ref_Rank
	ORDER BY Description
</cfquery>

<cfquery name="Nationality" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Code, Name FROM Ref_Nationality
	WHERE Operational = '1'
<!---	AND Code <> '-' --->
	ORDER BY Name
</cfquery>

<cfquery name="GetPerson" datasource="AppsEmployee" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Person WHERE PersonNo = '#URL.ID#'
</cfquery>

<!--- 10Jun3 if Field Mission user, sets field to readonly --->
<cfquery name="UserAccountGroup" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AccountGroup FROM SYSTEM.DBO.USERNAMES 
	WHERE Account LIKE '#SESSION.acc#'
</cfquery>

<!--- 02Dec08 change block above with updated logic as UserNames.AccountGroup no longer usable --->
<cfquery name="UserAccountGroup" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT TT.TravellerType AS AccountGroup
	FROM ActionAuthorization AA
		INNER JOIN FlowAction FA ON AA.ActionId = FA.ActionId 
		INNER JOIN Ref_TravellerType TT ON FA.ActionClass = TT.TravellerTypeCode
	WHERE   AA.UserAccount LIKE '#SESSION.acc#' AND AA.AccessLevel IN ('0','1')
</cfquery>

<cfif #UserAccountGroup.AccountGroup# EQ "Military" OR #UserAccountGroup.AccountGroup# EQ "Civpol">
	<cfset AllowDocEdit = "True">
	<cfset sPassThrough = "">
<cfelse>
	<cfset AllowDocEdit = "False">
	<cfset sPassThrough = "disabled">	
</cfif>


<CFFORM action="PersonEditSubmit.cfm?PERSNO=#URL.ID#" method="POST" name="personedit">

<!--- Start of main table --->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" height="30" valign="middle" bgcolor="002350">
	&nbsp;<font face="Tahoma" size="2" color="#FFFFFF"><strong>Person Edit</strong></font>
	</td>
	<td align="right" height="30" valign="middle" bgcolor="002350">
	<cfif #AllowDocEdit#>
	    <input type="submit" class="input.button1" name="Submit" value="  Save  ">
	</cfif>
	<input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	&nbsp;
	</td>
</tr> 	
  
<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">

  	<tr><td class="header" height="10" colspan="2"></td></tr>  
	<cfif #AllowDocEdit#>	
	  	<tr><td class="header" height="10" colspan="2">&nbsp;NOTES:</td></tr>
  		<tr><td class="header" height="10" colspan="2">&nbsp;1. An asterisk (*) after the field label indicates a mandatory field.</td></tr>
		<tr><td class="header" height="10" colspan="2">&nbsp;</td></tr>  
	</cfif>
	
	<!-- Number -->
	<tr>
	  <td class="header">&nbsp;Person Number:</td>
	  <td>
	  <cfinput type="Text" name="personno" value="#GetPerson.PersonNo#" required="Yes" size="20" class="regular" passThrough="disabled">
	  </td>
	</tr>	
	<tr><td height="4" colspan="1" class="header"></td></tr>
	<!-- Last Name -->
	<tr>
	  <td class="header">&nbsp;Last name*:</td>
	  <td>
	  <cfinput type="Text" name="lastname" value="#GetPerson.LastName#" message="Please enter person last name" required="Yes" size="40" maxlength="40" class="regular" passThrough="#sPassThrough#">
	  </td>
	</tr>	
	<tr><td height="4" colspan="1" class="header"></td></tr>
	<!-- First Name -->
	<tr>
	  <td class="header">&nbsp;First name*:</td>
	  <td>
	  <cfinput type="Text" name="firstname" value="#GetPerson.FirstName#" message="Please enter person first name" required="Yes" size="30" maxlength="30" class="regular" passThrough="#sPassThrough#">
	  </td>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>	
	<!-- Middle Name -->
	<tr>
	  <td class="header">&nbsp;Middle name:</td>
	  <td>
	  <cfinput type="Text" name="middlename" value="#GetPerson.MiddleName#" message="Please enter person middle name" required="No" size="25" maxlength="25" class="regular" passThrough="#sPassThrough#">
	  </td>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>	
	<!-- Index No -->
	<tr>
	  <td class="header">&nbsp;Index No:</td>
	  <td>
	  <cfinput type="Text" name="indexno" value="#GetPerson.IndexNo#" message="Please enter person index no" required="No" size="20" maxlength="20" class="regular" passThrough="#sPassThrough#">
	  </td>
	</tr>	
	<tr><td height="4" colspan="1" class="header"></td></tr>
	<!--- BirthDate --->
	<tr> 
	<td class="header">&nbsp;Birth date (dd/mm/yy)*:</td>
	<td class="regular">
	<cfif #AllowDocEdit#>	
		<cf_intelliCalendarDate
		FormName="personedit"
		FieldName="birthdate" 
		DateFormat="#CLIENT.DateFormatShow#"
		Default="#Dateformat(GetPerson.BirthDate, CLIENT.DateFormatShow)#">	
	<cfelse>
		<cfset disp_date = DateFormat(#GetPerson.BirthDate#,"dd/mm/yyyy")>
		<cfinput name="birthdate" type="text" value="#disp_date#" 
		 class="regular" style="text-align: center" size="10" passThrough="#sPassThrough#">
	</cfif>
	</td>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>	
	<!--- Gender --->
	<tr>
	  <td class="header">&nbsp;Gender*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="Gender" value="M" <cfif #GetPerson.Gender# EQ "M"> checked</cfif>> Male
	  <INPUT type="radio" name="Gender" value="F" <cfif #GetPerson.Gender# EQ "F"> checked</cfif>> Female		
	  </td>
	</tr>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>	
	<!--- PresentNationality --->
	<tr>
	  <td class="header">&nbsp;Present nationality*:</td>
	  <td class="regular">	
	  <cfselect name="Nationality" required="Yes" passThrough="#sPassThrough#">
	  <cfoutput query="Nationality">
	    <option value="#Code#" <cfif #Code# EQ #GetPerson.Nationality#> selected</cfif>>#Name#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>	
	<!-- Birth nationality -->
	<tr>
	  <td class="header">&nbsp;Nationality at birth*:</td>
	  <td class="regular">	
	  <cfselect name="BirthNationality" required="Yes" passThrough="#sPassThrough#">
	  <cfoutput query="Nationality">
		<option value="#Code#" <cfif #Code# EQ #GetPerson.BirthNationality#> selected</cfif>>#Name#</option> 
	  </cfoutput>
	  </cfselect>		
	  </td>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>	
	<!--- Field: Rank --->
	<tr>
	  <td class="header">&nbsp;Rank*:</td>
	  <td class="regular">	
	  <cfselect name="Rank" required="Yes" passThrough="#sPassThrough#">
	  <cfoutput query="Rank">
	  <option value="#Rank#" <cfif #Rank# EQ #GetPerson.Rank#> selected</cfif>>#Description#</option>
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<tr><td height="4" colspan="1" class="header"></td></tr>
	<!--- Field: Category--->
	<tr>
	  <td class="header">&nbsp;Category*:</td>
	  <td class="regular">	
	  <cfselect name="Category" required="Yes" passThrough="#sPassThrough#">
	  <cfoutput query="Category">
	  <option value="#Category#" <cfif #Category# EQ #GetPerson.Category#> selected</cfif>>#Category#</option>
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	
	<tr><td colspan="2"><hr></td></tr>
	
	<tr>
  	  <td class="header" colspan="2" align="right">
	  <cfif #AllowDocEdit#>		  
	  	<input type="submit" class="input.button1" name="Submit" value="  Save  ">
	  </cfif>
	  <input type="button" class="input.button1" name="Close" value=" Close " onClick="window.close()">
	  </td>
	</tr>
	
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
	
</table>
<!-- End of data entry block -->
</table>
<!-- End of main table -->

	<tr><td height="5" colspan="2"></td></tr>	
	
</table>


</CFFORM>
</BODY>
</HTML>