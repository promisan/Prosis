<!--- 
	DeploymentSummaryInquiry.cfm
	Page for searching for Deployment Summary Records to display in the List page.

	Search by: Nationality, Mission, Person Category, Selection Date
	
	Modification History:

--->
<cfset CLIENT.datasource = "AppsTravel">
<HTML><HEAD><TITLE>Deployment Summary Inquiry</TITLE></HEAD>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 
   
<body onLoad="window.focus()">


<cf_PreventCache>

<!---- 1. Check if use is allowed to access "All Missions" or particular missions --->

<cfquery name="Mission1" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT AA.Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY AA.Mission
</cfquery>

<!---- 2. Build temp table of person categories user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedCategory">

<cfquery name="AuthorizedCategory" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT RC.Category
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCategory
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY RC.Category
</cfquery>

<!---- 3. Delete temp table to hold field missions user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">

<!---- 3a. If user has access to all mission, read all current missions from DeploymentSummary table --->
<cfif #Mission1.Mission# EQ "All Missions">
	<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT DS.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC, DeploymentSummary DS,
			 userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCategory AC
		WHERE AA.ActionId = FA.ActionID
		AND   FA.ActionClass = RT.TravellerTypeCode
		AND   RT.TravellerType = RC.TravellerType
		AND   RC.Category = DS.Category
		AND   RC.Category = AC.Category
		AND   AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		ORDER BY DS.Mission
	</cfquery>
<cfelse>
<!--- 3b. Else, read authorized mission from ActionAuthorization table (same rules as above) --->
	<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT AA.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC, DeploymentSummary DS,
			 userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCategory AC
		WHERE AA.ActionId = FA.ActionID
		AND   FA.ActionClass = RT.TravellerTypeCode
		AND   RT.TravellerType = RC.TravellerType
		AND   RC.Category = DS.Category
		AND   RC.Category = AC.Category
		AND   AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		ORDER BY AA.Mission
	</cfquery>
</cfif>

<!---- 4. Build temp table of nationality (ie, name of Permanent Mission ) for which deployment summary records currently exist --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_ActiveNat">

<cfquery name="ActiveNat" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT DS.Nationality
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC, DeploymentSummary DS,
		 userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCategory AC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   RC.Category = DS.Category
	AND   RC.Category = AC.Category
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	ORDER BY DS.Nationality
</cfquery>

<!--- 5a. Read list of field missions for drop list --->
<cfquery name="Mission" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT M.Mission
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss M, DeploymentSummary DS
	WHERE M.Mission = DS.Mission
	ORDER BY M.Mission
</cfquery>

<!--- 5b. Read list of nationalities for drop list --->
<cfquery name="Nation" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT N.Nationality
	FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat N
	WHERE N.Nationality > 'A'
	ORDER BY N.Nationality
</cfquery>

<!--- 5c. Read list of person categories for drop list --->
<cfquery name="Category" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT C.Category
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCategory C
	ORDER BY C.Category
</cfquery>

<form action="DeploymentSummaryInquiryResult.cfm" method="post">

<cfparam name="URL.FormName" default="Myform">
<cfparam name="URL.FieldName" default="MyField">

<cfoutput>
<input type="hidden" name="FormName"  value="#URL.FormName#">
<input type="hidden" name="FieldName" value="#URL.FieldName#">
</cfoutput>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350">
  <td height="20" class="label">&nbsp;<b>Deployment Summary Inquiry</b></td>
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" rules="cols" style="border-collapse: collapse">
<tr bgcolor="6688aa"><td height="10"></td></tr>
<tr><td class="header">&nbsp;&nbsp;Instructions:</td></tr>
<tr><td class="header">&nbsp;&nbsp;1. Use this page to control records to display in the resulting list.</td></tr>
<tr><td class="header">&nbsp;&nbsp;2. Click the <b>Incl.</b> radio button to include values a selection box.</td></tr>
<tr><td class="header">&nbsp;&nbsp;3. For multiple selection, click a list item while holding down the CTRL key.</td></tr>

<tr bgcolor="white" valign="top">
	<td>&nbsp;
	
	<table>
	
    <!--- Field: Field Mission=CHAR;40;FALSE --->
	<tr><td height="5"> </td></tr>
	<tr><td></td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Field Mission:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="inclMission" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="inclMission" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
      </font>  	
	</td>
   	
	<td>
	  <font color="#000000">
    	<select name="Mission" size="15" multiple>
	    <cfoutput query="Mission">		
			<option value="'#Mission#'"selected>#Mission#</option>
		</cfoutput>
	    </select></font>
	</td>
		
    <!--- Field: Nationality (Permanent Mission) =CHAR;40;FALSE --->
	<td width="30"> </td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Permanent Mission:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="inclNation" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="inclNation" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
      </font>  	
	</td>
	
	<td>
    	<font color="#000000">
    	<select name="Nationality" size="15" multiple>
	    <cfoutput query="Nation">		
			<option value="'#Nationality#'"selected>#Nationality#</option>
		</cfoutput>
	    </select></font>
	</td>
	</tr>
	
    <!--- Field: Person Category =CHAR;40;FALSE --->
	<td width="30"> </td>
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Person Category:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="inclCategory" value="0" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="inclCategory" value="1"></font><font face="Tahoma" size="1" color="#6688AA">Excl.
      </font>  	
	</td>
	
	<td>
    	<font color="#000000">
    	<select name="Category" size="15" multiple>
	    <cfoutput query="Category">		
			<option value="'#Category#'"selected>#Category#</option>
		</cfoutput>
	    </select></font>
	</td>
	</tr>
		
	<tr><td>&nbsp;</td></tr>
	</table>
</table>	

</td></tr>	

<tr bgcolor="6688aa"><td height="10"></td></tr>

</table>

<hr>

<input class="input.button1" type="submit" name"Search" value="     Submit   ">

</FORM>
</BODY></HTML>