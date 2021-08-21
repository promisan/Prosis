<!--- Create Criteria string for query from data entered thru search form --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_wait1>

<CFSET Criteria = ''>
	
<cfparam name="Form.Crit3_FieldName" default="">

<cfif form.Crit3_FieldName neq "">
	
	<CF_Search_AppendCriteria
	    FieldName="#Form.Crit3_FieldName#"
	    FieldType="#Form.Crit3_FieldType#"
	    Operator="CONTAINS"
	    Value="#Form.Crit3_Value#">
	
</cfif>	

<cfparam name="Form.Flow"            default="All">		
<cfparam name="Form.Mission"         default="All">
<cfparam name="Form.Function"        default="All">
<cfparam name="Form.PostGrade"       default="All">
<cfparam name="Form.Class"           default="All">
<cfparam name="Form.CandidateStatus" default="">
<cfparam name="Form.Name"            default="">
<cfparam name="Form.ReferenceNo"  	 default="">
<cfparam name="Form.Operational"     default="">

<cfoutput>

<cfparam name="Form.Start" default="01/01/1900">
<cfset dateValue = "">
<CF_DateConvert Value="#Form.Start#">
<cfset dtes = #dateValue#>

<cfparam name="Form.End" default="01/01/2099">
<cfset dateValue = "">
<CF_DateConvert Value="#Form.End#">
<cfset dtee = #dateValue#>

<CFSET Criteria = #Criteria#&" AND (V.DueDate <= "&#dtee#&")"> 
<CFSET Criteria = #Criteria#&" AND (V.DueDate >= "&#dtes#&")"> 

<cfif Form.Mission IS NOT 'All'>
     <CFSET Criteria = "#Criteria# AND V.Mission IN ( #PreserveSingleQuotes(Form.Mission)# )">
</cfif> 

<CFSET Name = Replace( form.Name, "'", "''", "ALL" )>

<cfif Name IS NOT ''>
     <CFSET Criteria = "#Criteria# AND (C.LastName LIKE  '%#PreserveSingleQuotes(Name)#%' OR C.FirstName LIKE  '%#PreserveSingleQuotes(Name)#%')">
</cfif>

<cfif FORM.Post neq "">
	<CFSET Criteria = "#Criteria# AND (V.PositionNo LIKE ('%#Form.Post#%') OR V.PositionNO IN ( SELECT PositionNo FROM Employee.dbo.Position WHERE SourcePostNumber LIKE ('%#Form.Post#%') ))">
</cfif>

<cfif Form.Class IS NOT 'All'>
     <CFSET Criteria = "#Criteria# AND V.ActionClass IN ( #PreserveSingleQuotes(Form.Class)# )">
</cfif> 

<cfif Form.Function IS NOT 'All'>
     <CFSET Criteria = "#Criteria# AND (V.FunctionNo IN (#PreserveSingleQuotes(Form.Function)#) OR V.FunctionNO IN (SELECT FunctionNo FROM Applicant.dbo.FunctionTitle WHERE OccupationalGroup IN (#PreserveSingleQuotes(Form.Function)#)))">
</cfif> 

<cfif Form.SubmissionEdition IS NOT ''>
     <CFSET Criteria = "#Criteria# AND V.DocumentNo IN (SELECT DocumentNo FROM Applicant.dbo.FunctionOrganization WHERE DocumentNo = V.DocumentNo and SubmissionEdition = '#Form.SubmissionEdition#')">
</cfif> 

<cfif Form.PostGrade IS NOT 'All'>
     <CFSET Criteria = "#Criteria# AND V.PostGrade IN ( #PreserveSingleQuotes(Form.PostGrade)# )">
</cfif>  

<cfif Form.CandidateStatus IS NOT ''>
     <CFSET Criteria = "#Criteria# AND C.Status IN ( #PreserveSingleQuotes(Form.CandidateStatus)# )">
</cfif>  

<cfif Form.ReferenceNo neq "">
	<CFSET Criteria = "#Criteria# AND V.DocumentNo IN (SELECT DocumentNo FROM Applicant.dbo.FunctionOrganization WHERE ReferenceNo like '%#PreserveSingleQuotes(Form.ReferenceNo)#%')">
</cfif>

<cfif Left(Criteria, 4) neq " AND">
    <cfset Criteria = " AND #Criteria#">
</cfif> 

<cfset CriteriaList = ReplaceNoCase("#Criteria#", "AND AND ","AND","ALL")>

</cfoutput>

<cfif Form.Name neq "" or form.class neq "All" or Form.CandidateStatus neq "">
     <cfset join1 = "INNER JOIN">
	 
<cfelse>
	 <cfset join1 = "LEFT OUTER JOIN">
	 
</cfif>

<cfif Form.Post neq "">
     <cfset join2 = "INNER JOIN">
<cfelse>
	 <cfset join2 = "LEFT OUTER JOIN">
</cfif>

<cfset join2 = "LEFT OUTER JOIN">

<cfset FileNo = round(Rand()*10)>

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#DocumentT#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#Document#FileNo#">
<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#DocumentPost#FileNo#">

<cfif Form.Flow IS NOT "All">
				
		<!--- Query returning search results --->
		<cfquery name="SearchResult"
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT      DISTINCT V.DocumentNo, 
		            V.Mission, 
					V.ActionClass, 
					V.PostNumber as PostNumberTrigger, 
					V.FunctionalTitle,
		            V.PostGrade, 
					V.Duedate, 
					C.PersonNo,
					C.Status,
					V.Status as DocumentStatus,
					(C.FirstName + ' '+ C.LastName) as Name
		INTO       userQuery.dbo.#SESSION.acc#DocumentT#FileNo#
		FROM       Document V #join1#
                   DocumentCandidate C ON V.DocumentNo = C.DocumentNo 
			   
		WHERE 1=1 
		<cfif Form.Operational eq "1">
		AND  V.Status != '9'		
		</cfif>
		<cfif getAdministrator("*") eq "0">
		AND       V.Mission IN (SELECT Mission 
	                            FROM   Organization.dbo.OrganizationAuthorization 
							    WHERE  UserAccount = '#SESSION.acc#'
								AND    Mission = V.Mission
							    AND    Role in ( 'VacOfficer', 'VacProcess')
							 )							 
		</cfif>
		#PreserveSingleQuotes(CriteriaList)# 	
						
		</cfquery>

		<cfquery name="SearchResult"
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  D.* 
			INTO    userQuery.dbo.#SESSION.acc#Document#FileNo#
			FROM    userQuery.dbo.#SESSION.acc#DocumentT#FileNo# D,
			        Organization.dbo.OrganizationObject V
			WHERE   V.ObjectKeyValue1 = D.DocumentNo
			AND     V.ObjectKeyValue2 = D.PersonNo
			AND     V.EntityClass     = '#form.flow#' 
			AND     V.EntityCode      = 'VacCandidate'			
		</cfquery>
	
	
	
<cfelse>
	
	<!--- Query returning search results --->
	<cfquery name="SearchResult"
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
	
		SELECT      DISTINCT V.DocumentNo, 
		            V.Mission, 
					V.ActionClass, 
					V.PostNumber as PostNumberTrigger, 
					V.FunctionalTitle,
		            V.PostGrade, 
					V.Duedate, 
					C.PersonNo,
					C.Status,
					V.Status as DocumentStatus,
					(C.FirstName + ' '+ C.LastName) as Name
					
		INTO       userQuery.dbo.#SESSION.acc#Document#FileNo#
		FROM       Document V #join1#
	               DocumentCandidate C ON V.DocumentNo = C.DocumentNo
				
		WHERE 1=1
		<cfif Form.Operational eq "1">
		AND  V.Status != '9'		
		</cfif>
		<cfif getAdministrator("*") eq "0">
		AND    V.Mission IN (    
		                         SELECT  Mission 
		                         FROM    Organization.dbo.OrganizationAuthorization 
								 WHERE   UserAccount = '#SESSION.acc#'
								 AND     Mission = V.Mission
								 AND     Role in ('VacOfficer','VacProcess')
							)
								 
		</cfif>
		#PreserveSingleQuotes(CriteriaList)# 					
	
	</cfquery>
		
</cfif>  

<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#DocumentT#FileNo#">

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   
<cflocation url="InquiryResult.cfm?fileno=#fileno#&mid=#mid#">