<!--- 
	RotationListingParemeters.cfm
	
	Parameter setup page for Rotation view

    NOTE: Authorized Mission, and Active Nationality temp tables are needed for cases
	when users clicks EXCL radio button when submitting page

	Filter by: Mission and Nationality
	
	Calls: RotationListing.cfm
	
	Modification History:
	041222 - updated query code to use RM.MissionStatus =  1 to RM.Operational = 1
		   - added today Operational column in Organization.Ref_Mission table
	050109 - added code to handle new filters: LastName, FirstName, Arrival, Expected Rotation, Departure, and TOD months
	050115 - added code to handle new filters: Person Category
	050726 - added new query field: Gender
	050727 - added new query field: Age		
--->

<HTML><HEAD><TITLE>Rotation Listing - View Parameters</TITLE></HEAD>

<cfset CLIENT.Datasource = "AppsTravel">
  
<!---- 1a. Build temp table of post types user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedPostType">

<cfquery name="AuthorizedPostType" datasource="#CLIENT.Datasource#" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT RT.TravellerType AS PostType
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
</cfquery>

<!---- 1b. Build temp table of personnel categories user is authorized to access --->
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
<cfquery name="Mission1" 
datasource="AppsTravel" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT DISTINCT Mission
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	GROUP BY AA.Mission
</cfquery>

<!---- 3. Delete temp table to hold field missions user is authorized to access --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_AuthorizedMiss">

<!---- 3a. If user has access to all missions, read all current missions from Position table (limit to post types user is authorized to access) --->
<cfif #Mission1.Mission# EQ "All Missions">

	<cfquery name="Mission" 
	datasource="#CLIENT.Datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT Upper(PO.Mission) as Mission
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
	FROM ActionAuthorization AA INNER JOIN
		FlowAction FA ON AA.ActionId = FA.ActionId INNER JOIN
		Ref_TravellerType RT ON FA.ActionClass = RT.TravellerTypeCode INNER JOIN
		Employee.dbo.Position PO ON RT.TravellerType = PO.PostType INNER JOIN
		ORGANIZATION.DBO.Ref_Mission RM ON PO.Mission = RM.Mission
	WHERE AA.AccessLevel <> '9' AND 
    	AA.UserAccount = '#SESSION.acc#' AND 
		RM.Operational LIKE '1'
	ORDER BY PO.Mission
	</cfquery>

<cfelse>

<!--- 3b. Else, get authorized missions from ActionAuthorization table (same rules as above) --->
	<cfquery name="Mission" 
	datasource="#CLIENT.Datasource#" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT Upper(AA.Mission) as Mission
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
	FROM ActionAuthorization AA INNER JOIN
		FlowAction FA ON AA.ActionId = FA.ActionId INNER JOIN
		Ref_TravellerType RT ON FA.ActionClass = RT.TravellerTypeCode INNER JOIN
		Employee.dbo.Position PO ON RT.TravellerType = PO.PostType INNER JOIN
		ORGANIZATION.DBO.Ref_Mission RM ON PO.Mission = RM.Mission
	WHERE AA.AccessLevel <> '9' AND 
    	AA.UserAccount = '#SESSION.acc#' AND 
		RM.Operational LIKE '1'
	ORDER BY AA.Mission
	</cfquery>
</cfif>

<!-- 4.  Build table of countries user is authorized to access and for which assignments exists; 2 queries for performance  -->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_ActiveNat">
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_IndexNo">

<cfquery name="ActiveNat1" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT PersonNo 
	INTO userQuery.dbo.tmp#SESSION.acc#pm_IndexNo
    FROM PersonAssignment PA, Position PO
	WHERE PA.PositionNo = PO.PositionNo
	AND   PO.PostType IN (SELECT PostType FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType)
</cfquery>

<cfquery name="ActiveNat2" 
 datasource="AppsEmployee" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT DISTINCT N.* 
	INTO  userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat	
    FROM Travel.dbo.Ref_Nationality N, Person P, userQuery.dbo.tmp#SESSION.acc#pm_IndexNo G
	WHERE N.Code = P.Nationality
	AND G.PersonNo = P.PersonNo
	AND   N.Name > 'A'
	ORDER BY N.Name
</cfquery>

<!--- 5a. Read list of field missions for drop list --->
<cfquery name="Mission" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Mission
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss
	ORDER BY Mission
</cfquery>

<!--- 5b. Read list of nationalities for drop list --->
<cfquery name="Nation" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Code, Name 
	FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat
	ORDER BY Name
</cfquery>

<!--- 5c. Read list of personnel categories for drop list --->
<cfquery name="Category" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT Category
	FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCateg
</cfquery>

<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_IndexNo">

<!--- Search form --->
<p><font face="BondGothicLightFH"></p>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">
<body class="main" onload="window.focus()" top="0", bottom="0">

<cfform action="RotationListing.cfm" method="post">

<cfparam name="URL.FormName" default="Myform">
<cfparam name="URL.FieldName" default="MyField">

<cfoutput>
<input type="hidden" name="FormName"  value="#URL.FormName#">
<input type="hidden" name="FieldName" value="#URL.FieldName#">
</cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">
  <tr>
  <td height="20" class="labelit">Rotation Plan - View Parameters</td>
  </tr>
  
  <tr><td>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#8EA4BB" style="border-collapse: collapse">
  <tr bgcolor="6688aa"><td height="10"></td></tr>
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
	
    <td></td>
	<!--- Field: LastName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit1_FieldName" value="P.LastName">	
	<input type="hidden" name="Crit1_FieldType" value="CHAR">
	<tr height="20">
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

	<!--- Field: FirstName=CHAR;40;FALSE --->
	<input type="hidden" name="Crit2_FieldName" value="P.FirstName">	
	<input type="hidden" name="Crit2_FieldType" value="CHAR">
	<tr height="20">
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
	
	<!--- Date of arrival --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>Arrival:</b></font></td>
		<td valign="top" class="regular" colspan="5"><font color="#6688AA" size="1" face="Tahoma"><b>From:</b></font>&nbsp;&nbsp;
   	   		<cf_intelliCalendarDate
			FieldName="ArrivalFrom" 
			Default=""
			AllowBlank="True">

			<font color="#6688AA" size="1" face="Tahoma"><b>To:</b></font>&nbsp;&nbsp;

   	   		<cf_intelliCalendarDate
			FieldName="ArrivalTo" 
			Default=""
			AllowBlank="True">
		</td>
	</tr>

	<!--- Expected Rotation Date --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>Expected Rotation:&nbsp;&nbsp;&nbsp;</b></font></td>
		<td valign="top" class="regular" colspan="5"><font color="#6688AA" size="1" face="Tahoma"><b>From:</b></font>&nbsp;&nbsp;
   	   		<cf_intelliCalendarDate
			FieldName="RotationFrom" 
			Default=""
			AllowBlank="True">
			
			<font color="#6688AA" size="1" face="Tahoma"><b>To:</b></font>&nbsp;&nbsp;
			
   	   		<cf_intelliCalendarDate
			FieldName="RotationTo" 
			Default=""
			AllowBlank="True">
		</td>
	</tr>
			
	<!--- Departure Date --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>Departure:</b></font></td>
		<td valign="top" class="regular" colspan="5"><font color="#6688AA" size="1" face="Tahoma"><b>From:</b></font>&nbsp;&nbsp;
   	   		<cf_intelliCalendarDate
			FieldName="DepartureFrom" 
			Default=""
			AllowBlank="True">
			
			<font color="#6688AA" size="1" face="Tahoma"><b>To:</b></font>&nbsp;&nbsp;
			
   	   		<cf_intelliCalendarDate
			FieldName="DepartureTo" 
			Default=""
			AllowBlank="True">
		</td>
	</tr>			
			
	<!--- TOD months --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>TOD (mos):</b></font></td>
		<td valign="top" class="regular" colspan="5"><font color="#6688AA" size="1" face="Tahoma"><b>From:</b></font>&nbsp;&nbsp;
			<cfinput type="text" class="regular" width="2" name="TodFrom" size="2" maxlength="2" validate="integer">			

			<font color="#6688AA" size="1" face="Tahoma"><b>To:</b></font>&nbsp;&nbsp;			

			<cfinput type="text" class="regular" width="2" name="TodTo" size="2" maxlength="2" validate="integer">
		</td>
	</tr>
	
	<!--- AGE years --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>AGE (years):</b></font></td>
		<td valign="top" class="regular" colspan="5"><font color="#6688AA" size="1" face="Tahoma"><b>From:</b></font>&nbsp;&nbsp;
			<cfinput type="text" class="regular" width="2" name="AgeFrom" size="2" maxlength="2" validate="integer">			

			<font color="#6688AA" size="1" face="Tahoma"><b>To:</b></font>&nbsp;&nbsp;			

			<cfinput type="text" class="regular" width="2" name="AgeTo" size="2" maxlength="2" validate="integer">
		</td>
	</tr>

    <!--- Gender --->
	<tr>
		<td></td>
		<td><font color="#6688AA" size="1" face="Tahoma"><b>Gender:</b></font></td>
		<td align="left" valign="top">
	      <font color="#000000" face="Tahoma" size="1">	
			<input type="radio" name="Gender" value="M"><font color="#6688AA" size="1" face="Tahoma"><b>Male</b></font>
	      </font>
    	  <font color="#000000" face="Tahoma" size="1">
    		<input type="radio" name="Gender" value="F"><font color="#6688AA" size="1" face="Tahoma"><b>Female</b></font>
	      </font>  	
    	  <font color="#000000" face="Tahoma" size="1">
    		<input type="radio" name="Gender" value="B" checked><font color="#6688AA" size="1" face="Tahoma"><b>Both</b></font>
	      </font>  	
		</td>
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
      <font color="#000000" face="Tahoma" size="0">
    	<input type="radio" name="inclMission" value="0"></font><font face="Tahoma" size="1" color="#6688AA">Excl.&nbsp;&nbsp;
      </font>  	
	</td>
   	
	<td>
	  <font color="#000000">
    	<select name="Mission" class="regular">
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
    	<select name="Nationality" class="regular">
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
    	<select name="Category" class="regular">
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