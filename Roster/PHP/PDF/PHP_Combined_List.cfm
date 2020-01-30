<!--- Query returning detail information for selected item --->

<TITLE>Personal History Profile Composition</TITLE>

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="URL.ID1"   default = "Galaxy">
<cfparam name="URL.check" default = "Yes">

<cfset UN_English = "U&nbsp;N&nbsp;I&nbsp;T&nbsp;E&nbsp;D&nbsp;&nbsp;&nbsp;&nbsp;N&nbsp;A&nbsp;T&nbsp;I&nbsp;O&nbsp;N&nbsp;S&nbsp;&nbsp;&nbsp;">
<cfset UN_French = "&nbsp;&nbsp;&nbsp;N&nbsp;A&nbsp;T&nbsp;I&nbsp;O&nbsp;N&nbsp;S&nbsp;&nbsp;&nbsp;&nbsp;U&nbsp;N&nbsp;I&nbsp;E&nbsp;S">

<!--- get current roster list from temporary table  with at least one field, PersonNo --->

<cfparam name="PHP_Roster_List" default="">
<cfparam name="url.RosterQueryID" default="">
<cfparam name="url.IDFunction" default="">

<cfquery name="Parameter" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT PHPSource 
	FROM   Parameter
</cfquery>	
	
<cfif Len(URL.IDFunction) gt 16>
	<cfset prefix="Function">	

	<cfquery name="qFunction"
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT *
		 FROM   FunctionOrganization
		 WHERE  FunctionId = '#URL.IDFunction#'
	 </cfquery>



<cfelse>
	<cfset prefix="">
</cfif>



<cfif URL.RosterQueryID neq "">	
	
	<cfquery name="URLQuery"
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		 SELECT A.PersonNo, 
		        A.LastName, 
				A.FirstName, 
				A.IndexNo, 
				A.DOB, 
		        A.Gender, 
				A.Nationality, 
				A.eMailAddress, 
				S.ApplicantNo,
				S.Source
		 FROM   RosterSearchResult R 
		 		INNER JOIN Applicant A	ON A.PersonNo = R.PersonNo 
				INNER JOIN  ApplicantSubmission S ON A.PersonNo = S.PersonNo AND (S.SourceOrigin = '#Parameter.PHPSource#' or S.Source = '#Parameter.PHPSource#')
				INNER JOIN Ref_SubmissionEdition RS ON S.SubmissionEdition=RS.SubmissionEdition		
		 WHERE  R.SearchId = '#URL.RosterQueryID#'  
		 AND    R.Status = '1' 
		 ORDER BY A.LastName, A.FirstName  
	 </cfquery>




	<cfset batch = 1>
	 
<cfelse>

	<cfset batch = 0>

	<!--- check --->	
	
	<cfquery name="isSubmission"
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#"> 
		 SELECT *
		 FROM   ApplicantSubmission 
		 WHERE  
			 	<cfif prefix neq "">
			 	    PersonNo IN ('#PHP_Roster_List#')   
			 	<cfelse>
			 		ApplicantNo IN ('#PHP_Roster_List#')    
			 	</cfif>
	 </cfquery>	 



	 <cfif isSubmission.recordcount gte "1">
	 
	 	<cfquery name="URLQuery"
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#"> 
			 SELECT   A.PersonNo, 
			          A.LastName, 
					  A.FirstName, 
					  A.IndexNo, 
					  A.DOB, 
			          A.Gender, 
					  A.Nationality, 
					  A.eMailAddress, 
					  S.ApplicantNo
			 FROM     Applicant A INNER JOIN ApplicantSubmission S ON A.PersonNo = S.PersonNo
			 WHERE
			 	<cfif prefix neq "">
			 	    S.PersonNo IN ('#PHP_Roster_List#')   
			 	<cfelse>
			 		S.ApplicantNo IN ('#PHP_Roster_List#')    
			 	</cfif>
			 ORDER BY A.LastName, A.FirstName 			 
		 </cfquery>	 	 
	 
	 <cfelse>

		<cfquery name="URLQuery"
	     datasource="AppsSelection" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#"> 
			 SELECT A.PersonNo, 
			        A.LastName, 
					A.FirstName, 
					A.IndexNo, 
					A.DOB, 
			        A.Gender, 
					A.Nationality, 
					A.eMailAddress, 
					S.ApplicantNo
			 FROM   Applicant A INNER JOIN ApplicantSubmission S
				ON A.PersonNo = S.PersonNo and (S.SourceOrigin = '#Parameter.PHPSource#' or S.Source = '#Parameter.PHPSource#')
	
			 WHERE    A.PersonNo in ('#PHP_Roster_List#')   
			 ORDER BY A.LastName, A.FirstName 
			 
		 </cfquery>	 
	 
	 </cfif>
	 
</cfif>



<cfset PHPList = "">
	 
    <!--- index --->
		
	  <cfdocument name="index"
          format="PDF"
          pagetype="letter"
          margintop="0.1"
          marginbottom="0.5"
          marginright="0.05"
          marginleft="0.05"
          orientation="portrait"
          unit="in"
          encryption="none"
          fontembed="Yes"
          scale="70"
          backgroundvisible="No"
          bookmark="True"
          localurl="No">
		  		  
		    <cfdocumentsection
			    name="Index"
				margintop = "0.4"   
				marginbottom = "0.4">		
					  
					  
				<cfinclude template="PHP_Report_Cover.cfm">
				
				
			</cfdocumentsection>	
	
	 </cfdocument>

	 
 
	 

  
	 <cfloop query="URLQuery">

		<cfif batch  eq 1>

			<cfset PHP_Roster_List = URLQuery.ApplicantNo>
		</cfif>
	 
	 	<!--- main person data taken from Applicant --->
		<cfquery name="Applicant" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  A.*, S.ApplicantNo,S.Source as SubmissionSource,SourceOrigin
			FROM    Applicant A, 
			        ApplicantSubmission S
		    WHERE   
			 	<cfif prefix neq "">
			 	    S.PersonNo IN ('#PHP_Roster_List#')   
			 	<cfelse>
			 		S.ApplicantNo IN ('#PHP_Roster_List#')    
			 	</cfif>
			 	AND A.PersonNo = S.PersonNo
		</cfquery>
		
		<!--- temp provision --->		  


		<cftry>
	
		<!--- galapplicant -- information not available yet in table structure  13/jun/06  --->
		
			<cfquery name="Test" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT TOP 1 *
				FROM GALApplicant 
			</cfquery>		
			
			<cfset UN = "1">					

			<cfcatch>
			     <cfset UN = "0">	 
			</cfcatch>	
	
		</cftry>					   


				
		<cfif Applicant.RecordCount neq "0">
		
			<cfif PHPList neq "">
				<cfset PHPList = "#PHPList#,#PersonNo#">
			<cfelse>
			    <cfset PHPList = "#PersonNo#">
			</cfif>		
				
			<cfdocument name="#personNo#"
			          format="PDF"
			          pagetype="letter"
			          margintop="2.5"
			          marginbottom="0.5"
			          marginright="0.01"
			          marginleft="0.01"
			          orientation="portrait"
			          unit="in"
			          encryption="none"
			          fontembed="Yes"
			          scale="70"
			          backgroundvisible="No"
			          bookmark="True"
			          localurl="No">							  
					 
					<cfset PHPPersonNo = PersonNo>
						


																			
					<cfquery name="Experience" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT   A.*
						FROM     
						<cfif prefix eq "">ApplicantBackGround A<cfelse>ApplicantFunctionSubmission A</cfif>
						WHERE    A.ApplicantNo = '#ApplicantNo#' 
						AND      A.Status < '9'
						<cfif prefix neq ""> AND FunctionId = '#URL.IDFunction#'</cfif>		

						ORDER BY ExperienceCategory, ExperienceStart DESC 
					</cfquery>
					
				

					<cfdocumentsection
					    name="#Applicant.firstName# #Applicant.LastName#"
						margintop = "1"   
						marginbottom = "0.4">		
							

						
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<style type="text/css">
	
		body {
			width:100%;
		}

		hr {
		    display: block;
	    	height: 1px;
	    	border: 0;
	    	border-top: 1px solid #ccc;
    		margin: 1em 0;
    		padding: 0;
		}

		table { 
			width:95%; 
			border:0px solid #D9D5BE; 
			margin:10px; 
			background:white; 
			border-collapse:collapse; 
		
		}		

		td {
			font-family:"Verdana",Times,serif;
			font-size : 11pt;
			text-align:justify;
		}

		td.title {
			font-family:"Verdana",Times,serif;
			font-size : 14pt;
			text-align:left;
			font-weight: bold;
		}

		td.header {
			font-family:"Verdana",Times,serif;
			font-size : 14pt;
			text-align:center;
			font-weight: bold;
		}				
		
		td.footer {
			font-size : 7pt;
		}
	</style>
	
</head>
					    <cfdocumentitem type="header">	
							<cfinclude template="PHP_Header.cfm"> 
						</cfdocumentitem>								


						
						<cfinclude template="PHP_Sec_General.cfm">
						<!--- galapplicant
						<cfinclude template="PHP_Sec_Relations.cfm">
						--->
						
						<cfinclude template="PHP_Sec_Education.cfm">
						<!--- galapplicant
						<cfinclude template="PHP_Sec_Professional_Societies.cfm">
						--->
						
						
						<cfinclude template="PHP_Sec_Employment.cfm">
						<cfinclude template="PHP_Sec_Language.cfm">
						<cfinclude template="PHP_Sec_Address.cfm">

						
						<cfinclude template="PHP_Sec_References.cfm">  

					    <cfdocumentitem type="footer">	
						    <cfinclude template="PHP_Footer.cfm">
						</cfdocumentitem>		

					</cfdocumentsection>
							
		</cfdocument>	
	
		</cfif>		
	
	</cfloop>
	

	
	
	<cfparam name="wfentity" default = "">
	
	<cfif wfentity neq "">	
		<cftry>
		    <cfdirectory action="CREATE" directory="#SESSION.rootdocumentpath#\#wfentity#\#actionid#">
		<cfcatch></cfcatch>
		</cftry>		
		<cfset dest = "#SESSION.rootdocumentpath#\#wfentity#\#actionid#\php_profile.pdf">	
		
	<cfelse>	
		<cfset dest = "#SESSION.rootpath#\cfrstage\user\#SESSION.acc#\php_#fileno#.pdf">		
	</cfif>
		
	<cfpdf action     = "MERGE"
	     destination  = "#dest#"
	     overwrite    = "Yes"
	     keepbookmark = "Yes">
		  
			<cfpdfparam source="index">
			#dest#				
			<cfloop index="itm" list="#PHPList#" delimiters=",">
				<cfpdfparam source="#itm#">
			</cfloop>
	
	</cfpdf>
