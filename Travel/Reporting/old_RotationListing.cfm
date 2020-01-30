<!--- 
	RotationListing.CFM

	View all UNMO/CIVPOL personnel that are CURRENTLY deployed in a field mission.
	
	Modification History:
	031001 - created by MM
	040404 - changed the Category droplist to filter via PersonCategory rather than post type
	040602 - added "AND (DOC.Status IS NULL OR DOC.Status = '0' OR DOC.Status = '1')" to WHERE CLAUSE
			- to prevent duplications in the Rotation View as a result of joining DocumentRotatingPerson (DRR) with Document (DOC).
			- negating DRR+DOC linking for cancelled DOCs prevents persons from being duplicated as links to cancelled docs are ignored.
	040625 - added code to prevent listing of Assignment Record twice as a result of being in the "DocumentRotatingPerson" more than one
			  active document 
			- solution was to create new view vwRotatingPersonMaxNo on assumption that valid RotatingPerson record is on the
			  latter Document record; if this is not the case, the duplicate rotation record should be manually deleted OR
			  the Document record itself should be cancelled
    040625 - added code to check if user has access only to MILITARY or CIVPOL records; control columns to display as appropriate
	041005 - added LEFT JOIN to DocumentNo to prevent list of Assignment Record twice as a result of having multiple replacements 
	         (nominees); this happens normally when a rotating person is matched with the same replacements on multiple requests,
			 for example, when there is one pending and multiple cancelled requests.
	041031 - DateDeparture will now mean expected date of rotation
		   - DateExpiration will now be the end of mandate/actual departure date
		   - removed DateEffective in the Group Heading cases in the listing section as this is not a grouping/sorting option anyway
	050109 - added code to handle new filters: LastName, FirstName, Arrival, Expected Rotation, Departure, and TOD months
	050115 - added code to handle new filters: Personnel Category; also tuned main query	
	050726 - added code to handle new query field: Gender
	050727 - added code to handle new query field: Age			
--->
<HTML><HEAD><TITLE>Mission Rotation Plan</TITLE></HEAD>

<style>
TD.regular { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 15px; 
	color : black;
	} 

TD.regular_ital { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 15px; 
	color : black;
	font-style : italic;	
	} 

TD.regular_red { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 15px; 
	color : red;
	font-style : italic;
	} 
</style>

<cfset CLIENT.DataSource = "AppsTravel">

<cf_PreventCache>

<script language="JavaScript">
function reloadForm(nat,group,page,mission,categ,crit) {
    window.location="RotationListing.cfm?IDNationality=" + nat + "&IDCategory=" + categ + "&IDSorting=" + group + "&Page=" + page + "&IDMission=" + mission + "&IDCriteria=" + crit;
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld) {
     if (ie) {
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     } else {
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
	 }
	 	 		 	
	 if (fld != false) {
		 itm.className = "highLight2";
	 } else {
	     itm.className = "regular";		
	 }
 }

function markall(chk,val) {
	var count=1;
	var itm = new Array();
	while (count < 99)      
   	{		 
		itm2  = 'select_'+count
		var fld = document.getElementsByName(itm2)
		var itm = document.getElementsByName(itm2)
	 
	 	if (val == true) {
			fld[0].checked = true;
		} else {
		 	fld[0].checked = false;
		}
				
     	if (ie) {
	      	itm1=itm[0].parentElement; 
		  	itm1=itm1.parentElement; 
		} else {
          	itm1=itm[0].parentElement; 
		  	itm1=itm1.parentElement; 
	 	}
	
	 	if (val == true) {
			itm1.className = "highLight2";
	 	}
	 		 
	 	if (val == false) {
			itm1.className = "regular";
	 	}
    	count++;
   	}	
}
//function my_alert() {
//	alert("Window to display details of this Personnel Request forthcoming.");
//}
</script>	

<!--- tools : make available javascript for quick reference to dialog screens  --->
<cfinclude template="../Application/Dialog.cfm">

<cfparam name="URL.IDSorting" 		default="PersonName">
<cfparam name="URL.IDMission" 		default="ALL">
<cfparam name="URL.IDNationality" 	default="ALL">
<cfparam name="URL.IDCategory" 		default="ALL">
<cfparam name="URL.IDCriteria" 		default="">

<cfset Criteria = #URL.IDCriteria#> 		<!--- URL.IDCriteria will be blank before first postback --->
	
<cfif ParameterExists(Form.Crit1_Value)>
	<!--- 1. Build criteria string based on user input in calling form --->
	<cfif #Form.Crit1_Value# IS NOT "">	
		<CF_Search_AppendCriteria
	    FieldName="#Form.Crit1_FieldName#"
    	FieldType="#Form.Crit1_FieldType#"
	    Operator="#Form.Crit1_Operator#"
    	Value="#Form.Crit1_Value#">
	</cfif>
</cfif>	

<cfif ParameterExists(Form.Crit2_Value)>
	<cfif #Form.Crit2_Value# IS NOT "">	
		<CF_Search_AppendCriteria
    	FieldName="#Form.Crit2_FieldName#"
	    FieldType="#Form.Crit2_FieldType#"
    	Operator="#Form.Crit2_Operator#"
	    Value="#Form.Crit2_Value#">
	</cfif>	
</cfif>	

<cfif ParameterExists(Form.ArrivalFrom)>
	<cfset dateValue = "">
	<cfif #Form.ArrivalFrom# NEQ "">
 		<CF_DateConvert Value="#Form.ArrivalFrom#">
		<cfset a1Date = #dateValue#>
		<cfif #Criteria# EQ ""><cfset #Criteria# = "PA.DateArrival >= #a1Date#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND PA.DateArrival >= #a1Date#">
		</cfif>
	</cfif> 
</cfif> 
<cfif ParameterExists(Form.ArrivalTo)>
	<cfset dateValue = "">
	<cfif #Form.ArrivalTo# NEQ "">
 		<CF_DateConvert Value="#Form.ArrivalTo#">
		<cfset a2Date = #dateValue#>
		<cfif #Criteria# EQ ""><cfset #Criteria# = "PA.DateArrival <= #a2Date#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND PA.DateArrival <= #a2Date#">
		</cfif>
	</cfif>
</cfif> 

<cfif ParameterExists(Form.RotationFrom)>
	<cfset dateValue = "">
	<cfif #Form.RotationFrom# NEQ "">
	 	<CF_DateConvert Value="#Form.RotationFrom#">
		<cfset r1Date = #dateValue#>
		<cfif #Criteria# EQ ""><cfset #Criteria# = "PA.DateDeparture >= #r1Date#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND PA.DateDeparture >= #r1Date#">
		</cfif>
	</cfif>	
</cfif>
<cfif ParameterExists(Form.RotationTo)>
	<cfset dateValue = "">
	<cfif #Form.RotationTo# NEQ "">
 		<CF_DateConvert Value="#Form.RotationTo#">
		<cfset r2Date = #dateValue#>
		<cfif #Criteria# EQ ""><cfset #Criteria# = "PA.DateDeparture <= #r2Date#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND PA.DateDeparture <= #r2Date#">
		</cfif>
	</cfif>
</cfif> 

<cfif ParameterExists(Form.TodFrom)>
	<cfif #Form.TodFrom# NEQ "">
		<cfif #Criteria# EQ ""><cfset #Criteria# = "CONVERT(int,(DATEDIFF(dd,PA.DateArrival,PA.DateDeparture)/30)) >= #Form.TodFrom#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND CONVERT(int,(DATEDIFF(dd,PA.DateArrival,PA.DateDeparture)/30)) >= #Form.TodFrom#">
		</cfif>
	</cfif>
</cfif>
<cfif ParameterExists(Form.TodTo)>
	<cfif #Form.TodTo# NEQ "">
		<cfif #Criteria# EQ ""><cfset #Criteria# = "CONVERT(int,(DATEDIFF(dd,PA.DateArrival,PA.DateDeparture)/30)) <= #Form.TodTo#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND CONVERT(int,(DATEDIFF(dd,PA.DateArrival,PA.DateDeparture)/30)) <= #Form.TodTo#">
		</cfif>
	</cfif>
</cfif>

<cfif ParameterExists(Form.AgeFrom)>
	<cfif #Form.AgeFrom# NEQ "">
		<cfif #Criteria# EQ ""><cfset #Criteria# = "CONVERT(int,(DATEDIFF(yy,P.BirthDate,getdate()))) >= #Form.AgeFrom#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND CONVERT(int,(DATEDIFF(yy,P.BirthDate,getdate()))) >= #Form.AgeFrom#">
		</cfif>
	</cfif>
</cfif>
<cfif ParameterExists(Form.AgeTo)>
	<cfif #Form.AgeTo# NEQ "">
		<cfif #Criteria# EQ ""><cfset #Criteria# = "CONVERT(int,(DATEDIFF(yy,P.BirthDate,getdate()))) <= #Form.AgeTo#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND CONVERT(int,(DATEDIFF(yy,P.BirthDate,getdate()))) <= #Form.AgeTo#">
		</cfif>
	</cfif>
</cfif>

<cfif ParameterExists(Form.Gender)>
	<cfif #Form.Gender# NEQ "B">
		<cfif #Criteria# EQ ""><cfset #Criteria# = "P.Gender = '#Form.Gender#'">
		<cfelse><cfset #Criteria# = #Criteria#&" AND P.Gender = '#Form.Gender#'">
		</cfif>
	</cfif>
</cfif>

<!--- build temp table to hold selected Nationalities --->
<cfif ParameterExists(Form.Nationality) AND ParameterExists(Form.inclNation)>
	
	<!--- build Nationality entry in Criteria string --->
	<cfif #Form.inclNation# EQ "1">
	  <cfif #Form.Nationality# NEQ "">
	     <cfif #Criteria# EQ "">
			 <cfset #Criteria# = "P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )">
		 <cfelse>
			 <cfset #Criteria# = #Criteria#&" AND P.Nationality IN ( #PreserveSingleQuotes(Form.Nationality)# )" >
    	 </cfif>
	  </cfif> 
	</cfif>	

	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_SelectedNat">
	
	<cfif #Form.inclNation# EQ "1">
		<cfif #Form.Nationality# NEQ "">
			<cfquery name="MakeTempNationality" datasource="AppsSelection" 
			 username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT DISTINCT Code, Name
				INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat
				FROM  Ref_Nationality
				WHERE Code IN ( #PreserveSingleQuotes(Form.Nationality)# )
				ORDER BY Code
			</cfquery>			
		</cfif>	
	<cfelse>
		<cfquery name="MakeTempNationality" datasource="AppsSelection" 
		 username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT DISTINCT Code, Name
			INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat
			FROM  Ref_Nationality
			WHERE Code IN (SELECT Code FROM userQuery.dbo.tmp#SESSION.acc#pm_ActiveNat)
			ORDER BY Code
		</cfquery>				
	</cfif>		
</cfif>	

<!--- build temp table to hold selected field missions --->
<cfif ParameterExists(Form.Mission) AND ParameterExists(Form.inclMission)>

	<!--- build Mission entry in Criteria string --->
	<cfif #Form.inclMission# EQ "1">
	  <cfif #Form.Mission# NEQ "">
	     <cfif #Criteria# EQ "">
			 <cfset #Criteria# = "PO.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )">
		 <cfelse>
			 <cfset #Criteria# = #Criteria#&" AND PO.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )" >
    	 </cfif>
	  </cfif> 
	</cfif>	

	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_SelectedMiss">

	<cfif #Form.inclMission# EQ "1">
		<cfif #Form.Mission# NEQ "">
			<cfquery name="MakeTempMission" datasource="AppsTravel" 
			 username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT DISTINCT Mission, MandateNo
				INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss
				FROM  Ref_TVL_Mandate
				WHERE Mission IN ( #PreserveSingleQuotes(Form.Mission)# )
				AND   MandateDefault = 1
				ORDER BY Mission
			</cfquery>			
		</cfif>
	<cfelse>
		<cfquery name="MakeTempMission" datasource="AppsTravel" 
		 username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT DISTINCT Mission, MandateNo
			INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss
			FROM  Ref_TVL_Mandate
			WHERE Mission IN (SELECT Mission FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss)
		    AND   MandateDefault = 1			
			ORDER BY Mission
		</cfquery>
	</cfif>		
</cfif>	

<!--- build temp table to hold selected categories --->
<cfif ParameterExists(Form.Category) AND ParameterExists(Form.inclCategory)>

	<!--- build Category entry in Criteria string --->
	<cfif #Form.inclCategory# EQ "1">
	  <cfif #Form.Category# NEQ "">
	     <cfif #Criteria# EQ "">
			 <cfset #Criteria# = "P.Category IN ( #PreserveSingleQuotes(Form.Category)# )">
		 <cfelse>
			 <cfset #Criteria# = #Criteria#&" AND P.Category IN ( #PreserveSingleQuotes(Form.Category)# )" >
    	 </cfif>
	  </cfif> 
	</cfif>
	
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_SelectedCateg">

	<cfif #Form.inclCategory# EQ "1">
		<cfif #Form.Category# NEQ "">
			<cfquery name="MakeTempMission" datasource="AppsEmployee" 
			 username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT Category
				INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedCateg
				FROM  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCateg
				WHERE Category IN ( #PreserveSingleQuotes(Form.Category)# )
				ORDER BY Category
			</cfquery>			
		</cfif>
	<cfelse>
		<cfquery name="MakeTempMission" datasource="AppsEmployee" 
		 username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT Category
			INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedCateg
			FROM  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedCateg
			ORDER BY Category
		</cfquery>
	</cfif>		
</cfif>	

<!--- get latest latest assignment for person --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_MaxAssignmentNo">

<cfquery name="MaxAssignmentNo" datasource="AppsEmployee" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT A.PersonNo, Max(A.AssignmentNo) AS MaxAssignmentNo
	INTO userQuery.dbo.tmp#SESSION.acc#pm_MaxAssignmentNo
	FROM PersonAssignment A INNER JOIN 
		Position PO ON A.PositionNo = PO.PositionNo INNER JOIN
		Person P ON A.PersonNo = P.PersonNo INNER JOIN
		userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss SM ON PO.Mission = SM.Mission INNER JOIN
		userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat SN ON P.Nationality = SN.Code 
		INNER JOIN userQuery.dbo.tmp#SESSION.acc#pm_SelectedCateg SC ON P.Category = SC.Category 	
	WHERE A.OfficerUserID not in ('fodnyrd77')
	GROUP BY A.PersonNo
</cfquery>

<!--- get latest req# of each rotating person; limit to active reqs only --->
<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_MaxDrrReqNo">

<cfquery name="MaxDrrReqNo" datasource="AppsTravel" 
 username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT drp.PersonNo, max(drp.DocumentNo) AS MaxDocNo
	INTO userQuery.dbo.tmp#SESSION.acc#pm_MaxDrrReqNo
	FROM   Document d INNER JOIN
           DocumentRotatingPerson drp ON d.DocumentNo = drp.DocumentNo
<!---	WHERE  d.Status = '0' OR d.Status = '1' --->
	WHERE  d.Status IN ('0','1')
	GROUP BY drp.PersonNo
</cfquery>

<!--- dropdown select mission for view --->
<cfquery name="nationality" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Code, Name FROM userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat
	ORDER BY Name
</cfquery>

<!--- dropdown select mission for view --->
<cfquery name="mission" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Mission FROM userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss
	ORDER BY Mission
</cfquery>

<!--- dropdown select category for view --->
<cfquery name="category" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT Category FROM userQuery.dbo.tmp#SESSION.acc#pm_SelectedCateg
	ORDER BY Category
</cfquery>

<!--- check if this user is authorized to view Military personnel assignments --->
<cfquery name="AuthorizedForMilitary" datasource="AppsQuery" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT PostType FROM  userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedPostType
	WHERE PostType = 'MILITARY'
</cfquery>

<!--- Query returning search results --->
<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT PO.Mission, P.PersonNo, R.ShortDesc AS Rank, N.Name as CountryName,
	P.FirstName, P.LastName + ', ' + P.FirstName AS PersonName, P.Nationality, P.Birthdate, P.Category,
	PA.DateArrival, PA.DateEffective, PA.DateExpiration, PA.DateDeparture, PA.AssignmentNo,
	PA._tsDateActualDeparture AS ActualDeparture,
	PA.DateDeparture AS DOR, PA.DateDeparture AS SortDOR,
    (CASE WHEN (PA.Parent='PM Travel') THEN Upper(P.LastName) + '*' ELSE Upper(P.LastName) END) AS LastName, 
	(CASE WHEN (PA.PersonNo IS NULL) THEN 1 ELSE 0 END) AS ALLOW_DEL, 
	(CASE WHEN lower(PA.FunctionDescription) = 'undefined' THEN '' ELSE PA.FunctionDescription END) AS FunctionDesc, 
	(CASE WHEN (PA.DateDeparture IS NULL OR PA.DateArrival IS NULL) THEN NULL ELSE CONVERT(int,(DATEDIFF(dd,PA.DateArrival,PA.DateDeparture)/30)) END) AS TOD,
	RPD.MaxDocNo AS DocNo, DC.FirstName + ' ' + DC.LastName AS Replacement, DC.PlannedDeployment
FROM  
	EMPLOYEE.DBO.Person P INNER JOIN 
	EMPLOYEE.DBO.PersonAssignment PA ON P.PersonNo = PA.PersonNo INNER JOIN 
	userQuery.dbo.tmp#SESSION.acc#pm_MaxAssignmentNo MA
		ON (PA.PersonNo = MA.PersonNo AND PA.AssignmentNo = MA.MaxAssignmentNo) INNER JOIN
	EMPLOYEE.DBO.Position PO ON PA.PositionNo = PO.PositionNo INNER JOIN 
    userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat SN ON P.Nationality = SN.Code INNER JOIN 
	userQuery.dbo.tmp#SESSION.acc#pm_SelectedCateg SC ON P.Category = SC.Category INNER JOIN	
	userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss SM ON PO.Mission = SM.Mission INNER JOIN
	APPLICANT.DBO.Ref_Nationality N ON P.Nationality = N.Code INNER JOIN
	Ref_Rank R ON P.Rank = R.Rank LEFT JOIN
	<!--- get latest req# of each rotating person; limit to active reqs only --->
	userQuery.dbo.tmp#SESSION.acc#pm_MaxDrrReqNo RPD ON P.PersonNo = RPD.PersonNo LEFT JOIN
	<!--- get document rotating person record using latest req# and person# values from previous line --->
	DocumentRotatingPerson DRR ON (RPD.PersonNo = DRR.PersonNo AND RPD.MaxDocNo = DRR.DocumentNo) LEFT JOIN
	<!--- using document rotating person record's ReplacementPersonNo value to get record of Nominated Replacement (if any) --->	
	DocumentCandidate DC ON DRR.ReplacementPersonNo = DC.PersonNo LEFT JOIN 
	<!--- if Nominated Replacement exists, get the number of the Request sent to the PM --->		
	Document D ON DC.DocumentNo = D.DocumentNo
WHERE 
	( PA._tsDateActualDeparture > DateAdd(day, -1, GetDate()) OR PA._tsDateActualDeparture IS NULL ) AND
	( D.DocumentNo IS NULL OR D.Status IN ('0','1') ) AND
	PO.PostType IN ('Military','Civpol')
	<cfif #URL.IDNationality# NEQ "All"> AND P.Nationality = '#URL.IDNationality#'</cfif>
	<cfif #URL.IDCategory# NEQ "All"> AND P.Category = '#URL.IDCategory#'</cfif>	
	<cfif #URL.IDMission# NEQ "All"> AND PO.Mission = '#URL.IDMission#'</cfif>
	<cfif #PreserveSingleQuotes(Criteria)# NEQ ""> AND #PreserveSingleQuotes(Criteria)#</cfif>
ORDER BY 
	<cfswitch expression = #URL.IDSorting#>
		<cfcase value="Nationality">N.Name, PA.DateDeparture, P.Lastname, P.FirstName</cfcase>
    	<cfcase value="Mission">PO.Mission + P.Lastname + P.FirstName</cfcase>
	    <cfcase value="DOR">PA.DateDeparture, P.Lastname + P.FirstName</cfcase>
    	<cfcase value="SortDOR">PA.DateDeparture, P.Lastname + P.FirstName</cfcase>
	    <cfdefaultcase>P.LastName + P.FirstName</cfdefaultcase>
	</cfswitch>

</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">

<body class="main" onload="window.focus()" top="0", bottom="0">

<cfform action="RotationPlanSubmit.cfm" method="POST" name="RotationPlan" id="RotationPlan">

<cfoutput> 
<input type="hidden" name="no" value="#SearchResult.recordCount#">
</cfoutput> 
  
<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350" height="20" valign="middle">
    <td colspan="4"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;ROTATION PLAN</b></font>
	</td>
  </tr>
  <tr bgcolor="#002350" height="15" valign="middle">
    <td colspan="4"><font face="Tahoma" size="1" color="#FFFFFF">
	&nbsp;&nbsp;&nbsp;This view lists all personnel who are <u>currently</u> deployed
	in a field mission.  An asterisk after the LastName indicates those deployed via PM STARS. Expired assignments shown in italics.
	</td>
  </tr>

  <tr bgcolor="#002350" height="30" valign="middle">

	<!--- save value of Criteria into hidden field that can be referenced as a param for call the reloadForm() function --->
	<cfoutput><input type="hidden" name="criter"  value="#Criteria#"></cfoutput>
  
	<!-- Nationality -->
    <td><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;SHOW:&nbsp;&nbsp;Nationality:&nbsp;</b></font>
    <select name="nat" style="background: #C9D3DE;" accesskey="P" title="Select Country of Nationality" 
	onChange="javascript:reloadForm(this.value,group.value,page.value,mission.value,categ.value,criter.value)">
		<cfif #nationality.recordcount# GT 1>
			<option value="ALL"><font face="Tahoma" size="3">All</font>
		</cfif>
	    <cfoutput query="nationality">
			<option value="#Code#" <cfif #Code# is '#URL.IDNationality#'>selected</cfif>><font face="Tahoma" size="3">#Name#</font></option>
		</cfoutput>
    </select>
    </td>

	<!-- Field Mission -->
    <td><font face="Tahoma" size="1" color="#FFFFFF"><b>Field Mission:</b></font>&nbsp;
    <select name="mission" style="background: #C9D3DE;" accesskey="P" title="Select Field Mission" 
	onChange="javascript:reloadForm(nat.value,group.value,page.value,this.value,categ.value,criter.value)">
		<cfif #mission.recordcount# GT 1>
			<option value="ALL"><font face="Tahoma" size="3">All</font>
		</cfif>
    	<cfoutput query="Mission">
			<option value="#Mission#" <cfif #Mission# is '#URL.IDMission#'>selected</cfif>><font face="Tahoma" size="3">#Mission#</font></option>
		</cfoutput>
    </select>
    </td>

	<!-- Category -->
    <td><font face="Tahoma" size="1" color="#FFFFFF"><b>Category:</b></font>&nbsp;
	<select name="categ" style="background: #C9D3DE;" accesskey="P" title="Category Selection" 
	onChange="javascript:reloadForm(nat.value,group.value,page.value,mission.value,this.value,criter.value)">
		<cfif #category.recordcount# GT 1>
			<option value="ALL"><font face="Tahoma" size="3">All</font>
		</cfif>
	    <cfoutput query="Category">
			<option value="#Category#" <cfif #Category# is '#URL.IDCategory#'>selected</cfif>><font face="Tahoma" size="1">#Category#</font></option>
		</cfoutput>
	</select>	
	</td>
	
	<!-- Print button -->
	<td align="right">
		<input type="button" class="input.button1" name="Print" value="  Print  " title="Print the contents of the window" 
		onClick="javascript:window.print()">
	</td>
</tr> 	
<!-- End RECORD FILTERS -->

<!-- RECORD  GROUPER -->  
<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#6688aa" rules="cols" style="border-collapse: collapse">
   <tr bgcolor="#6688AA" height="30" valign="middle">
   
   	<td class="BannerN" colspan="2"><font face="Tahoma" size="1" color="#FFFFFF"><b>&nbsp;GROUP/SORT BY:</b></font>&nbsp;&nbsp;
	<!--- drop down for record grouping and sorting  --->	
	<select name="group" size="1" style="background: #C9D3DE;" 
	onChange="javascript:reloadForm(nat.value,this.value,page.value,mission.value,categ.value,criter.value)">
	<cfif #Nationality.recordcount# GT 1>
		 <OPTION value="Nationality" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Country of Nationality
	</cfif>
	<cfif #Mission.recordcount# GT 1>
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
	</cfif>
    <OPTION value="DOR" <cfif #URL.IDSorting# eq "DOR">selected</cfif>>Group by Expected DOR
    <OPTION value="SortDOR" <cfif #URL.IDSorting# eq "SortDOR">selected</cfif>>Sort by Expected DOR	
	<OPTION value="PersonName" <cfif #URL.IDSorting# eq "PersonName">selected</cfif>>Sort by Person Name
	</select> 
	</td>

	<td class="BannerN" align="right">
	  	<cfinclude template="../../Tools/PageCount.cfm">
		<select name="page" size="1" style="background: #C9D3DE;" 
		onChange="javascript:reloadForm(nat.value,group.value,this.value,mission.value,categ.value,criter.value)">
			<cfloop index="Item" from="1" to="#pages#" step="1">
    			<cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>#Item# of #pages#</option></cfoutput>
			</cfloop>	 
		</select>	 
	</td>
</tr>

<!--- DETAIL SECTION --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">
<!--- Detail column headers --->
<tr>
	<td width="1%" class="topN" height="10">&nbsp;
<!--- 		<input class="regular" type="checkbox" name="ShowSelect" value="All" 
		 onClick="javascript:markall('document.RotationPlan.assignmentno_',this.checked);"> 
 --->	</td>
	<!---td width="1%" class="topN"></td--->
	<td width="2%"></td>
	<td width="6%"><font size="-2" face="Arial, Helvetica, sans-serif">Mission</font></td>
	<td width="3%"><font size="-2" face="Arial, Helvetica, sans-serif">Nat</font></td>
	<td width="5%"><font size="-2" face="Arial, Helvetica, sans-serif">Rank</font></td>
	<td width="10%"><font size="-2" face="Arial, Helvetica, sans-serif">First Name</font></td>	
	<td width="10%"><font size="-2" face="Arial, Helvetica, sans-serif">Last Name</font></td>
	<td width="5%"><font size="-2" face="Arial, Helvetica, sans-serif">Cat</font></td>	
	<td width="11%"><font size="-2" face="Arial, Helvetica, sans-serif">Functional Title</font></td>
	<td width="3%"><font size="-2" face="Arial, Helvetica, sans-serif">TOD</font></td>
	<td width="6%"><font size="-2" face="Arial, Helvetica, sans-serif">Arrival</font></td>
	<td width="7%"><font size="-2" face="Arial, Helvetica, sans-serif">Rotation</font></td>

	<!--- if current user has access to military records --->
	<cfif #AuthorizedForMilitary.Recordcount# GT 0>
		<td width="4%"><font size="-2" face="Arial, Helvetica, sans-serif">Req#</font></td>	
    	<td width="11%"><font size="-2" face="Arial, Helvetica, sans-serif">Replacement</font></td>
		<td width="6%"><font size="-2" face="Arial, Helvetica, sans-serif">PDOA</font></td>
	<cfelse>
		<td width="4%"><font size="-2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
		<td width="11%"><font size="-2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>
		<td width="*"><font size="-2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>				
	</cfif>	
</tr>
  
<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

<cfset amt  = 0>

<!--- Display group headers --->
<tr bgcolor="f6f6f6">
<cfswitch expression = #URL.IDSorting#>
     <cfcase value = "DOR">
     <td colspan="16"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(DateDeparture, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "Nationality">
	 <td colspan="16"><font face="Tahoma" size="2"><b>&nbsp;#CountryName#</b></font></td>
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="16"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     </cfcase>	
</cfswitch>   
</tr>
<tr bgcolor="C0C0C0"><td height="1" colspan="15" class="top2"></td></tr>

<!--- Detail records --->

<cfset no = "0">
<cfoutput>
<cfset no = #no# + 1>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#" >
  	<td rowspan="1" align="center" class="regular">
		<input type="checkbox" name="select_#no#" value="1" onClick="hl(this,this.checked)">
		<input name="assignmentno_#no#" type="hidden" value="#AssignmentNo#">
	</td>

	<!--- if rotation date is past, display record in italics --->
  	<cfif #DateDeparture# LT DateAdd("d", -1, Now()) OR #DateDeparture# EQ ''>
		<cfset fmtstring = "regular_ital">
	<cfelse>
		<cfset fmtstring = "regular">
	</cfif>

  	<td class="#fmtstring#">#CurrentRow#.</td>
	<td class="#fmtstring#">#Mission#</td>
  	<td class="#fmtstring#">#Nationality#</td>
	<td class="#fmtstring#">#Rank#</td>
	<td class="#fmtstring#"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to view/edit person record. An asterisk on Last Name indicates person travelled via PM STARS.">#FirstName#</a></td>
	<td class="#fmtstring#"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to view/edit person record. An asterisk on Last Name indicates person travelled via PM STARS.">#LastName#</a></td>
  	<td class="#fmtstring#">#Category#</td>
  	<td class="#fmtstring#">#FunctionDesc#</td>
	<td class="#fmtstring#">#TOD#</td>
  	<td class="#fmtstring#"><a href="javascript:pm_editassigndates('#AssignmentNo#')" title="Click to view/edit assignment details.">#DateFormat(DateArrival, "#CLIENT.dateformatshow#")#</a></td>
	<td class="#fmtstring#"><a href="javascript:pm_editassigndates('#AssignmentNo#')" title="Click to view/edit assignment details.">#DateFormat(DateDeparture, "#CLIENT.dateformatshow#")#</a></td>

	<!--- if current user has access to military records --->
	<cfif #AuthorizedForMilitary.Recordcount# GT 0>
<!--  	  	<td class="#fmtstring#"><a href="javascript:my_alert()" title="Click to display details of personnel request.">#DocNo#</a></td>
 -->
   	  	<td class="#fmtstring#"><a href="javascript:showdocument('#DocNo#','ZoomIn')" title="Click to display details of personnel request.">#DocNo#</a></td>
	  	<td class="#fmtstring#">#Replacement#</td>		
		<td class="#fmtstring#">#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</td>
	<cfelse>
		<td colspan="3">&nbsp;</td>
	</cfif>
</tr>

<cfset Amt = Amt + 1>
<cfset AmtT = AmtT + 1>
</cfoutput>

<!---If record groups are being used, display the group counter section --->
<cfif #URL.IDSorting# NEQ "PersonName" AND #URL.IDSorting# NEQ "SortDOR">
	<tr>
		<td colspan="14" align="center"></td>
		<td align="right"><hr></td>	
	</tr>
   
	<tr>
		<td colspan="14" align="center"></td>
		<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
	</tr>

	<tr><td height="10" colspan="15"></td></tr>
</cfif>

</cfoutput>

<cfif #URL.IDSorting# NEQ "PersonName" AND #URL.IDSorting# NEQ "SortDOR">
	<tr bgcolor="f7f7f7">				<!--- Print a line before the total --->
		<td colspan="14" align="center"></td>
		<td align="right"><hr></td>	
	</tr>
 
	<tr bgcolor="f7f7f7">				<!--- Print the total --->		
		<td colspan="14" align="center"></td>
		<td align="right"><font size="1" face="Tahoma"><b><cfoutput>#NumberFormat(AmtT,'_____,__')#&nbsp;</cfoutput></b></font></td>	
	</tr>
</cfif>

</table>
	<tr>								<!--- Print a dark blue border --->
		<td height="10" colspan="15" bgcolor="#002350"></td>
	</tr>		
</table>
 
</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</cfform>

</BODY>
</div>
</HTML>