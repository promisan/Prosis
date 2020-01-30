<!--- 
	TravelListing.CFM

	View all UNMO/CIVPOL personnel that have completed the 'Complete Travel Authorization' 
	but not the 'Milestone: Traveller arrive...' step
	
	Modification History:
	19May04 - added filter to SearchResult to exclude: stalled (6) or revoked (9) candidates
	15Jan05 - added code to handle new filters: LastName, FirstName, Expected Deployment, and Category	
	21Jan05 - added code to Dialog.cfm_showdocument() function whenever the entry under ReqNo is clicked.
		    - ShowDocument() opens the Personnel Request Details page for the req number selected
    08Jun05 - added code to check if user has Global Role FmPmstarsUser; if so, display IndexNo in lieu of ReqNo				
	        - added DocumentNo field in join between DocumentCandidate and DocumentCandidateAction to prevent dups	
--->
<HTML><HEAD><TITLE>Personnel On Travel Status</TITLE></HEAD>

<style>
TD.regular { 
	font-family : tahoma; 
	font-size : 8pt; 
	height : 15px; 
	color : black;
	} 
</style>

<cfset CLIENT.DataSource = "AppsTravel">

<cf_PreventCache>

<cfoutput>
<script language="JavaScript">
//function my_alert() {
//	alert("Feature to display details of the Request Document forthcoming.");
//}

function reloadForm(nat,group,page,mission,categ,crit)
{
    window.location="TravelListing.cfm?IDNationality=" + nat + "&IDCategory=" + categ + "&IDSorting=" + group + "&Page=" + page + "&IDMission=" + mission + "&IDCriteria=" + crit;
}
</script>	
</cfoutput>

<!--- tools : make available javascript for quick reference to dialog screens --->
<cfinclude template="../Application/Dialog.cfm">

<cfparam name="URL.IDSorting" 		default="PersonName">
<cfparam name="URL.IDMission" 		default="ALL">
<cfparam name="URL.IDNationality" 	default="ALL">
<cfparam name="URL.IDCategory" 		default="ALL">
<cfparam name="URL.IDCriteria" 		default="">

<!--- added 050608 to check if current user has role FmPmstarsUser (field mission Civilian Personnel Section user) --->
<cffunction name="IsFmPmstarsUser">
	<cfargument name="dummyArg">
	<cfquery name="ChkIsPmstarsUser" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT TOP 1 * FROM OrganizationAuthorization WHERE UserAccount = '#SESSION.acc#' And Role = 'FmPmstarsUser'
	</cfquery>
	<cfreturn "#ChkIsPmstarsUser.RecordCount#">
</cffunction>

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

<cfif ParameterExists(Form.DeploymentFrom)>
	<cfset dateValue = "">
	<cfif #Form.DeploymentFrom# NEQ "">
 		<CF_DateConvert Value="#Form.DeploymentFrom#">
		<cfset a1Date = #dateValue#>
		<cfif #Criteria# EQ ""><cfset #Criteria# = "DC.PlannedDeployment >= #a1Date#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND DC.PlannedDeployment >= #a1Date#">
		</cfif>
	</cfif> 
</cfif> 
<cfif ParameterExists(Form.DeploymentTo)>
	<cfset dateValue = "">
	<cfif #Form.DeploymentTo# NEQ "">
 		<CF_DateConvert Value="#Form.DeploymentTo#">
		<cfset a2Date = #dateValue#>
		<cfif #Criteria# EQ ""><cfset #Criteria# = "DC.PlannedDeployment <= #a2Date#">
		<cfelse><cfset #Criteria# = #Criteria#&" AND DC.PlannedDeployment <= #a2Date#">
		</cfif>
	</cfif>
</cfif> 

<!--- Default authorized post type for initializing URL.IDCategory variable --->
<cfquery name="DeFPDtType" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT TOP 1 RC.TravellerType AS Category
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	ORDER BY RC.TravellerType
</cfquery>

<cfparam name="URL.IDCategory" 	default="#DeFPDtType.Category#">

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
			<cfquery name="MakeTempNationality" datasource="AppsTravel" 
			 username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT DISTINCT Code, Name
				INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat
				FROM  Ref_Nationality
				WHERE Code IN ( #PreserveSingleQuotes(Form.Nationality)# )
				ORDER BY Code
			</cfquery>			
		</cfif>	
	<cfelse>
		<cfquery name="MakeTempNationality" datasource="AppsTravel" 
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
			 <cfset #Criteria# = "D.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )">
		 <cfelse>
			 <cfset #Criteria# = #Criteria#&" AND D.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )" >
    	 </cfif>
	  </cfif> 
	</cfif>
	
	<CF_DropTable dbName="AppsQuery" tblName="tmp#SESSION.acc#pm_SelectedMiss">

	<cfif #Form.inclMission# EQ "1">
		<cfif #Form.Mission# NEQ "">
			<cfquery name="MakeTempMission" datasource="AppsOrganization" 
			 username="#SESSION.login#" password="#SESSION.dbpw#">
				SELECT DISTINCT Mission
				INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss
				FROM  Ref_Mission
				WHERE Mission IN ( #PreserveSingleQuotes(Form.Mission)# )
				ORDER BY Mission
			</cfquery>			
		</cfif>
	<cfelse>
		<cfquery name="MakeTempMission" datasource="AppsOrganization" 
		 username="#SESSION.login#" password="#SESSION.dbpw#">
			SELECT DISTINCT Mission
			INTO  userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss
			FROM  Ref_Mission
			WHERE Mission IN (SELECT Mission FROM userQuery.dbo.tmp#SESSION.acc#pm_AuthorizedMiss)
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

<!--- Query returning search results --->
<cfquery name="SearchResult" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
SELECT 	P.PersonNo, P.IndexNo, DC.LastName, DC.FirstName, DC.LastName + ', ' + DC.FirstName AS PersonName, DC.PlannedDeployment, 
	P.Category, P.Nationality, P.Birthdate,	N.Name AS CountryName, R.ShortDesc AS Rank, 
	D.DocumentNo AS DocNo, D.Mission, D.RequestDate, D.DutyLength,	
	P1.FirstName + ' ' + P1.LastName AS PersonRotating
FROM  
	DocumentCandidate DC INNER JOIN	
	EMPLOYEE.DBO.Person P ON DC.PersonNo = P.PersonNo INNER JOIN
	userQuery.dbo.tmp#SESSION.acc#pm_SelectedNat SN ON P.Nationality = SN.Code INNER JOIN
	APPLICANT.DBO.Ref_Nationality N ON P.Nationality = N.Code INNER JOIN
	DocumentCandidateAction DCA ON (DC.DocumentNo = DCA.DocumentNo AND DC.PersonNo = DCA.PersonNo) INNER JOIN
	FlowActionView FA ON DCA.ActionId = FA.ActionId INNER JOIN
	Document D ON DC.DocumentNo = D.DocumentNo INNER JOIN
	userQuery.dbo.tmp#SESSION.acc#pm_SelectedMiss SM ON D.Mission = SM.Mission LEFT JOIN
	Ref_Rank R ON P.Rank = R.Rank LEFT JOIN
	DocumentRotatingPerson DRR ON (DC.DocumentNo = DRR.DocumentNo AND DC.PersonNo = DRR.ReplacementPersonNo) LEFT JOIN
	EMPLOYEE.DBO.Person P1 ON DRR.PersonNo = P1.PersonNo
WHERE  	
	DCA.ActionStatus IN ('1','7','8') AND			<!--- where candidate has completed, bypassed, or N/A --->
	FA.ConditionForView LIKE 'TravelStatus' AND	    <!---  and all steps of type 'TravelStatus', i.e., Complete TA --->
	D.Status = '0' AND						    	<!---  and document is still pending (otherwise, candidate is no longer in on Travel Status --->
	DC.PersonNo NOT IN ( SELECT CA.PersonNo FROM DocumentCandidateAction CA, FlowActionView FV
	 		            WHERE  CA.ActionId = FV.ActionId
	 			        AND    CA.ActionStatus = '1'			     			<!--- candidate completed the Milestone: Traveller arrived in FM step --->
				        AND    FV.ConditionForView LIKE 'ArriveInMission' ) AND <!--- for action IDs that correspond to the Milestone step --->
	DC.Status IN ('0','3')
	<cfif #URL.IDNationality# NEQ "All"> AND P.Nationality = '#URL.IDNationality#'</cfif>
	<cfif #URL.IDMission# NEQ "All"> AND D.Mission = '#URL.IDMission#'</cfif>
	<cfif #URL.IDCategory# NEQ "All"> AND P.Category = '#URL.IDCategory#'</cfif>	
	<cfif #PreserveSingleQuotes(Criteria)# NEQ ""> AND #PreserveSingleQuotes(Criteria)#</cfif>
ORDER BY 
	<cfswitch expression = #URL.IDSorting#>
		<cfcase value="Nationality">P.Nationality + P.Lastname + P.FirstName</cfcase>
	    <cfcase value="Mission">D.Mission + P.Lastname + P.FirstName</cfcase>
    	<cfcase value="PersonName">P.LastName + P.FirstName</cfcase>
	    <cfcase value="RequestDate">D.RequestDate, P.Lastname + P.FirstName</cfcase>
    	<cfcase value="PlannedDeployment">DC.PlannedDeployment, P.Lastname + P.FirstName</cfcase>
	</cfswitch>
</cfquery>

<link rel="stylesheet" type="text/css" href="<cfoutput>#client.root#/#client.style#</cfoutput>"> 
<div class="screen">

<body class="main" onload="window.focus()">

<form name="result" id="result">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
  <tr bgcolor="#002350" height="20" valign="middle">
    <td colspan="4"><font face="Tahoma" size="2" color="#FFFFFF"><b>&nbsp;PERSONNEL ON TRAVEL STATUS</b></font>
	</td>
  </tr>
  <tr bgcolor="#002350" height="15" valign="middle">
    <td colspan="4"><font face="Tahoma" size="1" color="#FFFFFF">
	&nbsp;&nbsp;&nbsp;This view lists all <u>undeployed</u> personnel who are pending the <b>Milestone: Traveller Arrives in FM</b> step. Personnel still on Travel Status after Planned Deployment shown in <i>italics</i>.
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
	<cfif #nationality.recordcount# GT 1>
		 <OPTION value="Nationality" <cfif #URL.IDSorting# eq "Nationality">selected</cfif>>Group by Country of Nationality
	</cfif>
	<cfif #Mission.recordcount# GT 1>
		 <OPTION value="Mission" <cfif #URL.IDSorting# eq "Mission">selected</cfif>>Group by Field Mission
	</cfif>
   	<OPTION value="RequestDate" <cfif #URL.IDSorting# eq "RequestDate">selected</cfif>>Group by Request Date
    <OPTION value="PlannedDeployment" <cfif #URL.IDSorting# eq "PlannedDeployment">selected</cfif>>Group by Planned Deployment
	<OPTION value="PersonName" <cfif #URL.IDSorting# eq "PersonName">selected</cfif>>Sort by Person Name
	</select> 
	</td>

	<td class="BannerN" align="right">
	  	<cfinclude template="../../Tools/PageCount.cfm">
		<select name="page" size="1" style="background: #C9D3DE;" 
		onChange="javascript:reloadForm(nat.value,group.value,this.value,mission.value,categ.value,criter.value)">
			<cfloop index="Item" from="1" to="#pages#" step="1">
    			<cfoutput><option value="#Item#"<cfif #URL.page# eq "#Item#">selected</cfif>>Page #Item# of #pages#</option></cfoutput>
			</cfloop>	 
		</select>	 
	</td>
</tr>
<!-- End RECORD GROUPER -->

<!--- Detail column headers --->
<table width="100%" border="0" cellspacing="0" cellpadding="1" align="center" rules="rows">

<tr>
    <td width="1%">&nbsp;</td>
    <td width="1%">&nbsp;</td>	
    <td width="6%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Mission</font></td>
	<td width="3%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Nat</font></td>
	<td width="5%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Rank</font></td>
	<td width="11%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">First Name</font></td>	
	<td width="12%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Last Name</font></td>
	<td width="8%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Birth Date</font></td>
	<td width="6%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Cat</font></td>
	<!--- modified 050608 to display person index no when user is a civilian HR practitioner in the field mission --->
	<cfif IsFmPmstarsUser(1)>
		<td width="5%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">IndexNo</font></td>
	<cfelse>
		<td width="5%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Req No</font></td>
	</cfif>
	<!--- end of modification --->
	<td width="6%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">TOD</font></td>
	<td width="8%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Req Date</font></td>
    <td width="8%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Planned Dep</font></td>	
    <td width="20%" align="left"><font size="-2" face="Arial, Helvetica, sans-serif">Person Rotating</font></td>	
</tr>

<cfset vac     = "0">
<cfset action  = "9999">
<cfset amtT    = 0>

<cfoutput query="SearchResult" group=#URL.IDSorting# startrow=#first# maxrows=#No#>

<cfset amt  = 0>
    
<!--- Display ROW containing record group headers --->
<tr bgcolor="f6f6f6">
<cfswitch expression = #URL.IDSorting#>
     <cfcase value = "PlannedDeployment">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "RequestDate">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Dateformat(RequestDate, "#CLIENT.dateformatshow#")#</b></font></td>
     </cfcase>
     <cfcase value = "Nationality">
	 <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#CountryName#</b></font></td>
     </cfcase>
     <cfcase value = "Mission">
     <td colspan="14"><font face="Tahoma" size="2"><b>&nbsp;#Mission#</b></font></td> 
     </cfcase>	
</cfswitch>   
</tr>

<!--- DETAIL RECORD SECTION --->     
<tr bgcolor="C0C0C0"><td height="1" colspan="14" class="top2"></td></tr>
	
<!--- Record detail row --->
<cfoutput>
<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
<!---		
<td rowspan="1" align="left"></td>	
    CREATE A POP-UP PERSON EDIT PAGE --->
<td rowspan="1" align="left">&nbsp;
<!---	<a href="javascript:pm_editperson('#PersonNo#')"> 
	<img src="../../Images/function.jpg" alt="" width="15" height="12" border="0"></a>--->	
</td>

<!--- If Planned Deployment date is past, display in Italics --->
<cfif #PlannedDeployment# LT DateAdd("d", -1, Now())>
  <td class="regular"><font color="black"><i>#CurrentRow#.</i></font></td>
  <td class="regular"><font color="black"><i>#Mission#</i></font></td>
  <td class="regular"><font color="black"><i>#Nationality#</i></font></td>
  <td class="regular"><font color="black"><i>#Rank#</i></font></td>
  <td class="regular"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to edit person record. An asterisk on Last Name indicates person travelled via PM STARS."><i>#FirstName#</i></a></td>
  <td class="regular"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to edit person record. An asterisk on Last Name indicates person travelled via PM STARS."><i>#LastName#</i></a></td>
  <td class="regular"><font color="black"><i>#DateFormat(BirthDate, "#CLIENT.dateformatshow#")#</i></font></td>
  <td class="regular"><font color="black"><i>#Category#</i></font></td>  
  <!--- modified 050608 to display person index no when user is a civilian HR practitioner in the field mission --->
  <cfif IsFmPmstarsUser(1)>
    <td class="regular"><font color="black"><i>#IndexNo#</i></font></td>
  <cfelse>
	  <td class="regular"><a href="javascript:showdocument('#DocNo#','ZoomIn')" title="Click to display details of personnel request.">#DocNo#</a></td>
  </cfif>
  <!--- end of modification --->  
  <td class="regular"><font color="black"><i>#DutyLength#</i></font></td>
  <td class="regular"><font color="black"><i>#Dateformat(RequestDate, "#CLIENT.dateformatshow#")#</i></font></td>	
  <td class="regular"><font color="black"><i>#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</i></font></td>	
  <td class="regular"><font color="black"><i>#PersonRotating#</i></font></td>
<cfelse>
  <td class="regular"><font color="black">#CurrentRow#.</font></td>
  <td class="regular"><font color="black">#Mission#</font></td>
  <td class="regular"><font color="black">#Nationality#</font></td>
  <td class="regular"><font color="black">#Rank#</font></td>
  <td class="regular"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to edit person record. An asterisk on Last Name indicates person travelled via PM STARS.">#FirstName#</a></td>
  <td class="regular"><a href="javascript:pm_editperson('#PersonNo#')" title="Click to edit person record. An asterisk on Last Name indicates person travelled via PM STARS.">#LastName#</a></td>
  <td class="regular"><font color="black">#DateFormat(BirthDate, "#CLIENT.dateformatshow#")#</font></td>
  <td class="regular"><font color="black">#Category#</font></td>  
  <!--- modified 050608 to display person index no when user is a civilian HR practitioner in the field mission --->
  <cfif IsFmPmstarsUser(1)>
    <td class="regular"><font color="black">#IndexNo#</font></td>
  <cfelse>
	<td class="regular"><a href="javascript:showdocument('#DocNo#','ZoomIn')" title="Click to display details of personnel request.">#DocNo#</a></td>
  </cfif>
  <!--- end of modification --->
  <td class="regular"><font color="black">#DutyLength#</font></td>
  <td class="regular"><font color="black">#Dateformat(RequestDate, "#CLIENT.dateformatshow#")#</font></td>	
  <td class="regular"><font color="black">#Dateformat(PlannedDeployment, "#CLIENT.dateformatshow#")#</font></td>	
  <td class="regular"><font color="black">#PersonRotating#</font></td>
</cfif>
</tr>

<tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
<td></td>
<cfset Amt = Amt + 1>
<cfset AmtT = AmtT + 1>
</cfoutput>

<!---If record groups are being used, display the group counter section --->
<cfif #URL.IDSorting# neq "PersonName">
<tr>
	<td colspan="13" align="center">
	<td align="right"><hr></td>	
</tr>
   
<tr>
	<td colspan="13" align="center">
	<td align="right"><font size="1" face="Tahoma"><b>#NumberFormat(Amt,'_____,__')#&nbsp;</b></font></td>	
</tr>

<tr><td height="10" colspan="14"></td></tr>
</cfif>

</cfoutput>

</table>
	<tr><td height="10" colspan="14" bgcolor="#002350"></td></tr>		<!--- Print a dark blue border --->
</table>
 
</table>

<hr><p align="center"><font face="Tahoma" size="1"><cfoutput>#SESSION.Welcome#</cfoutput></font></p>

</form>

</BODY></HTML>