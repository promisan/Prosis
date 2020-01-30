<!--
 	PersonEntry.cfm
	
	Generic Person entry form.
	
	Calls: PersonEnteredTodayList.cfm
	
	Modification History:
	15Oct03 - created by MM
-->
<HTML><HEAD><TITLE>Person - Entry</TITLE></HEAD>


<cfset CLIENT.Datasource = "AppsTravel">

<cfparam name="URL.CutOff" default="#Dateformat(now(), CLIENT.DateFormatShow)#">

<cfinclude template="Dialog.cfm">

<SCRIPT LANGUAGE = "JavaScript">
function reloadForm(my_dt)
{
    window.location="PersonEntry.cfm?CutOff=" + my_dt;
}

function closing()
{
 	opener.location.reload()
	window.close()
}
</SCRIPT>

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter
	WHERE Identifier = 'A'
</cfquery>

<cfquery name="Class" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT *
	FROM  FlowClass
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

<cfquery name="Nationality" datasource="AppsSelection" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Code, Name FROM Ref_Nationality
	WHERE Operational = '1'
	AND Code <> '-'
	ORDER BY Name
</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onLoad="javascript:document.forms.personentry.lastname.focus();" top="0", bottom="0">

<cfform action="PersonEntrySubmit.cfm" method="POST" target="Listing" enablecab="No" name="personentry">

<!-- Start of main table -->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
<tr>
	<td align="left" bgcolor="002350" class="bannerN" height="30" valign="middle">
	<font face="Tahoma" size="2" color="#FFFFFF"><strong>&nbsp;&nbsp;Person Entry</strong></font>
	</td>
	<td align="right" bgcolor="002350" class="bannerN" height="30" valign="middle">
	&nbsp;
	</td>
</tr> 	
  
<!-- Start data entry block -->   
<tr>
<td width="100%" colspan="2">
<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	<!-- space row -->
	<tr><td class="header" height="10"></td></tr>
	<!-- Last Name -->
	<tr>
	  <td class="header">&nbsp;Last name*:</td>
	  <td>
	  <cfinput type="Text" name="lastname" value="" message="Please enter person last name" required="Yes" size="40" maxlength="40" class="regular">
	  </td>
	</tr>	
	<!-- First Name -->
	<tr>
	  <td class="header">&nbsp;First name*:</td>
	  <td>
	  <cfinput type="Text" name="firstname" value="" message="Please enter person first name" required="Yes" size="30" maxlength="30" class="regular">
	  </td>
	</tr>
	<!-- Middle Name -->
	<tr>
	  <td class="header">&nbsp;Middle name:</td>
	  <td>
	  <cfinput type="Text" name="middlename" value="" message="Please enter person middle name" required="No" size="25" maxlength="25" class="regular">
	  </td>
	</tr>	
	<!--- BirthDate --->
	<tr>
	  <td class = "Header">&nbsp;Date of birth (dd/mm/yyyy):</td>
	  <td class = "regular">
		<cf_intelliCalendarDate
		 FormName="personentry"
		 FieldName="BirthDate" 
		 DateFormat="#CLIENT.DateFormatShow#"
		 Default=""
		 AllowBlank="True">
	  </td>
	</tr>	
	<!--- Gender --->
	<tr>
	  <td class="header">&nbsp;Gender*:</td>
	  <td class="regular">		
	  <INPUT type="radio" name="Gender" value="M" checked> Male
	  <INPUT type="radio" name="Gender" value="F"> Female		
	  </td>
	</tr>
	<!--- PresentNationality --->
	<tr>
	  <td class="header">&nbsp;Present nationality*:</td>
	  <td width="25%" class="regular">	
	  <cfselect name="Nationality" required="Yes">
	  <cfoutput query="Nationality">
	    <option value="#Code#">#Name#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<!--- Field: Rank --->
	<tr>
	  <td class="header">&nbsp;Rank*:</td>
	  <td>	
	  <cfselect name="Rank" required="Yes">
	  <cfoutput query="Rank">
	  <option value="#Rank#">#Description#</option>
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<!--- Field: Category --->
	<tr>
	<td class="header">&nbsp;Category*:</td>
	<td>	
	  <cfselect name="Category" required="Yes">
	  <cfoutput query="Category">
	  <option value="#Category#">#Category#</option>
	  </cfoutput>
	  </cfselect>	
	</td>
	</tr>
	<!-- Add person button -->
	<tr>
  	  <td class="header">
	  &nbsp;
   	  <input type="submit" class="input.button1" name="Submit" value="  Add person  ">
	  </td>
	  <td colspan="2">
	  &nbsp;
	  <font face="tahoma" color="#000000" size="1.5">Note: An asterisk (*) after the field label indicates a mandatory field.</font>
	  </td>
	</tr>
	<!-- spacer row -->
	<tr class="header" bgcolor="#FFFFFF"><td height="5" colspan="2"></td></tr>	
</table>
<!-- End of data entry block -->
</table>
<!-- End of main table -->

<!--- Start of Persons Entered Today table at the lower half of page --->
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">

  <tr>
	<td height="18" align="left" valign="middle" bgcolor="002350">
	<font face="Tahoma" size="1.5" color="FFFFFF">		&nbsp;<b>Persons Entered Today</b>
	
	<!---
		&nbsp;<b>Persons Entered since (dd/mm/yyyy)*: </b>&nbsp;&nbsp;
	
 	  	<cfset cutoff = DateAdd("m",  -1,  now())> 
   	  	<cf_intelliCalendarDate
		 FormName="personentry"
		 FieldName="cutoffdate" 
		 DateFormat="#CLIENT.DateFormatShow#"
		 Default="#Dateformat(cutoff, CLIENT.DateFormatShow)#">
	
	</font>	
	
 	&nbsp;&nbsp;
   	<input type="button" class="button1" name="Requery" value=" Requery database " onClick="javascript:reloadForm(cutoffdate.value)">
	--->
    <tr>
	<td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#111111" style="border-collapse: collapse">
	  <tr>
		<td>
 		<cfinclude template="PersonEnteredTodayList.cfm"> 
		</td>
	  </tr>	  
	</table>
    </td>
    </tr>
  </tr>	
  <tr><td height="5" colspan="2"></td></tr>	
</table>
<!--- End of Persons Entered Today table --->

</CFFORM>
</body>
</div>
</html>