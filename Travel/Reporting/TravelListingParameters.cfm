<!--- 
	TravelListingParameters.cfm
	
	Parameter setup page for Travel Listing view

	Filter by: Name, Planned Deployment Date, Mission, Nationality, Category
	
	Calls: TravelListing.cfm
	
	Modification History:
	22dec04 - updated query code to use RM.MissionStatus =  1 to RM.Operational = 1
			- added today Operational column in Organization.Ref_Mission table
	15Jan05 - added code to handle new filters: LastName, FirstName, Expected Deployment, and Category			
--->

<HTML><HEAD><TITLE>Personnel On Travel Status - View Parameters</TITLE></HEAD>

<cfset CLIENT.Datasource = "AppsTravel">

<!---- 1. Build temp table of personnel categories user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedCateg">

<cfquery name="AuthorizedCateg" datasource="#CLIENT.Datasource#"
 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT RC.Category
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCateg
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   RC.Hybrid_ind = 0
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'	
	ORDER BY RC.Category
</cfquery>

<!---- 2. Check if use is allowed to access "All Missions" or particular missions --->
<cfquery name="Mission1" datasource="AppsTravel" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT AA.Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	ORDER BY AA.Mission
</cfquery>

<!---- 3. Delete temp table to hold field missions user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">

<!---- 3a. If user has access to all mission, read CURRENT missions from Document table (limit to req for person types user is authorized to access) --->
<cfif #Mission1.Mission# EQ "All Missions">

	<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#"
	 username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT D.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM  ActionAuthorization AA INNER JOIN 
		      FlowAction FA ON AA.ActionId = FA.ActionId INNER JOIN 
			  Ref_TravellerType RT ON FA.ActionClass = RT.TravellerTypeCode INNER JOIN 
			  Ref_Category C ON RT.TravellerType = C.TravellerType INNER JOIN
			  Document D ON C.Category = D.PersonCategory INNER JOIN 
			  ORGANIZATION.DBO.Ref_Mission RM ON D.Mission = RM.Mission
		WHERE AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		AND   D.Status = 0
		AND   RM.Operational = 1		
		ORDER BY D.Mission
	</cfquery>
	
<cfelse>

<!--- 3b. Else, read authorized mission from ActionAuthorization table (same rules as above) --->
	<cfquery name="AuthorizedMission" datasource="#CLIENT.Datasource#"
	 username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT DISTINCT AA.Mission
		INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
		FROM  ActionAuthorization AA INNER JOIN 
		      FlowAction FA ON AA.ActionId = FA.ActionId INNER JOIN 
			  Ref_TravellerType RT ON FA.ActionClass = RT.TravellerTypeCode INNER JOIN 
			  Ref_Category C ON RT.TravellerType = C.TravellerType INNER JOIN
			  Document D ON C.Category = D.PersonCategory INNER JOIN 
			  ORGANIZATION.DBO.Ref_Mission RM ON D.Mission = RM.Mission
		WHERE AA.AccessLevel <> '9'
		AND   AA.UserAccount = '#SESSION.acc#'
		AND   D.Status = 0		
		AND   RM.Operational = 1		
		ORDER BY AA.Mission
	</cfquery>

</cfif>

<!---- 4. Build temp table to nationality codes for which active candidates current exist --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_ActiveNat">

<cfquery name="ActiveNat" datasource="AppsTravel"
 username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT DISTINCT N.Code, N.Name 
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
    FROM Ref_Nationality N INNER JOIN 
		 EMPLOYEE.DBO.Person P ON N.Code = P.Nationality INNER JOIN
	     DocumentCandidate DC ON P.PersonNo = DC.PersonNo INNER JOIN
		 Ref_Category C ON P.Category = C.Category
	WHERE C.Hybrid_ind = 0
	AND   P.Category IN (SELECT Category FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCateg WHERE Category = P.Category)
	AND   DC.Status IN ('0','3')
	AND   N.Name > 'A'
	ORDER BY N.Name
</cfquery>

<!--- 5a. Read list of field missions for drop list --->
<cfquery name="Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
</cfquery>

<!--- 5b. Read list of nationalities for drop list --->
<cfquery name="Nation" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Code, Name 
	FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
</cfquery>

<!--- 5c. Read list of personnel categories for drop list --->
<cfquery name="Category" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCateg
</cfquery>

<!--- Search form --->
<p><font face="BondGothicLightFH"></p>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<cfform action="TravelListing.cfm" method="post">

<cfparam name="URL.FormName" default="Myform">
<cfparam name="URL.FieldName" default="MyField">

<cfoutput>
<input type="hidden" name="FormName"  value="#URL.FormName#">
<input type="hidden" name="FieldName" value="#URL.FieldName#">
</cfoutput>

<table width="100%" border="0" cellspacing="0" cellpadding="0>
  <tr>
  <td height="20" class="label">&nbsp;<b>Personnel On Travel Status - View Parameters</b></td>
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
<tr><td height="10"></td></tr>
  <tr><td><font size="1" face="Arial, Helvetica, sans-serif">&nbsp;&nbsp;Instructions:</font></td></tr>
  <tr><td><font size="1" face="Arial, Helvetica, sans-serif">
		&nbsp;&nbsp;1. Use this page to control records to display in the resulting list.</font>
  </td></tr>
  <tr><td><font size="1" face="Arial, Helvetica, sans-serif">
	  &nbsp;&nbsp;2. Click the <b>Incl.</b> radio button to include values in a selection box.</font>	  
  </td></tr>
  <tr><td><font size="1" face="Arial, Helvetica, sans-serif">
	  &nbsp;&nbsp;3. For multiple selection, click a list item while holding down the CTRL key.</font>
  </td></tr>
  <tr><td><font size="1" face="Arial, Helvetica, sans-serif">
	  &nbsp;&nbsp;4. Enter dates in dd/mm/yyyy format. For example, enter 01 Nov 2000 as 01/11/2000.</font>
  </td></tr>

<tr bgcolor="white" valign="top">
	<td>&nbsp;
	
	<table>
	
	<!--- Field: LastName --->
	<input type="hidden" name="Crit1_FieldName" value="P.LastName">	
	<input type="hidden" name="Crit1_FieldType" value="CHAR">
	<tr>
	<td width="5"></td>
	<td align="left">    
      <font size="1" face="Tahoma" color="#6688AA"><b>Last Name:</b></font>
    </td>
	<td colspan="5"><font color="#000000">
		<select name="Crit1_Operator">
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after
		</select></font>
		<font color="#6688AA">&nbsp;</font>
		<font color="#000000"><input type="text" name="Crit1_Value" size="20"></font>	
	</td>
	</tr>

	<!--- Field: FirstName --->
	<input type="hidden" name="Crit2_FieldName" value="P.FirstName">	
	<input type="hidden" name="Crit2_FieldType" value="CHAR">
	<tr>
	<td></td>
	<td align="left">
       <font color="#6688AA" size="1" face="Tahoma"><b>First Name:</b></font>
    </td>
	<td colspan="5"><font color="#000000">
		<select name="Crit2_Operator">		
			<option value="BEGINS_WITH">begins with
			<option value="ENDS_WITH">ends with
			<option value="CONTAINS">contains
			<option value="EQUAL">is
			<option value="NOT_EQUAL">is not
			<option value="SMALLER_THAN">before
			<option value="GREATER_THAN">after		
		</select>
		</font>
		<font color="#6688AA">&nbsp; </font>
		<font color="#000000">		
		<input type="text" name="Crit2_Value" size="20">
		</font>	
	</td>
	</tr>

    <tr><td height="5"> </td></tr>
			
	<!--- Expected Deployment Date --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>Expected Deployment:&nbsp;&nbsp;&nbsp;</b></font></td>
		<td valign="top" class="regular" colspan="5"><font color="#6688AA" size="1" face="Tahoma"><b>From:</b></font>&nbsp;&nbsp;
   	   		<cf_intelliCalendarDate
			FieldName="DeploymentFrom" 
			Default=""
			AllowBlank="True">
			
			<font color="#6688AA" size="1" face="Tahoma"><b>To:</b></font>&nbsp;&nbsp;
			
   	   		<cf_intelliCalendarDate
			FieldName="DeploymentTo" 
			Default=""
			AllowBlank="True">
	</tr>
			
    <tr><td height="5"> </td></tr>
	
	<!--- Field: Field Mission --->
	<tr>
	<td></td>	
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA"><b>Field Mission:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="inclMission" value="1" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="inclMission" value="0"></font><font face="Tahoma" size="1" color="#6688AA">Excl.&nbsp;&nbsp;
      </font>  	
	</td>
   	
	<td>
	  <font color="#000000">
    	<select name="Mission">
	    <cfoutput query="Mission">		
			<option value="'#Mission#'"selected>#Mission#</option>
		</cfoutput>
	    </select></font>
	</td>
		
    <!--- Field: Nationality --->
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA">&nbsp;&nbsp;<b>Nationality:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="inclNation" value="1" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="inclNation" value="0"></font><font face="Tahoma" size="1" color="#6688AA">Excl.&nbsp;&nbsp;
      </font>  	
	</td>
	
	<td>
    	<font color="#000000">
    	<select name="Nationality">
	    <cfoutput query="Nation">		
			<option value="'#Code#'"selected>#Name#</option>
		</cfoutput>
	    </select></font>
	</td>

    <!--- Field: Personnel Category --->
	<td align="left" valign="top">
      <font size="1" face="Tahoma" color="#6688AA">&nbsp;&nbsp;<b>Category:</b></font><P>
      <font color="#000000" face="Tahoma" size="1">	
		<input type="radio" name="inclCategory" value="1" checked></font><font face="Tahoma" size="1" color="#6688AA">Incl.
      </font>
      <font color="#000000" face="Tahoma" size="1">
    	<input type="radio" name="inclCategory" value="0"></font><font face="Tahoma" size="1" color="#6688AA">Excl.&nbsp;&nbsp;
      </font>  	
	</td>
   	
	<td>
	  <font color="#000000">
    	<select name="Category">
	    <cfoutput query="Category">		
			<option value="'#Category#'"selected>#Category#</option>
		</cfoutput>
	    </select></font>
	</td>

	</tr>

    <tr><td height="5"> </td></tr>
	
	</table>	 
</table>	

</td></tr>	

<tr>
	<td colspan="5" align="center">
 		<input type="submit" 
	    name="search"  
		id="search"
		value="Submit" 
		style="width:100px;height:25" 
		class="button10s">
	</td>
</tr>


</table>
	
</cfform>
</body>
</div>
</html>