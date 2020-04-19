
<cfparam name="url.scope" default="standard">

<cfif url.scope neq "embed">	
	<cf_screentop label="Please select one or more roster editions" jquery="yes" html="No" height="100%" scroll="Yes">
</cfif>

<cfparam name="URL.ID"      default="0">
<cfparam name="URL.DocNo"   default="">
<cfparam name="url.wparam"  default="ALL">

<cfset occ = "">
<cfset param = "">

<cfif url.mode eq "vacancy">

	<!--- roster search from vactrack --->
	
	<cfquery name="DefineOcc" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT F.OccupationalGroup
	    FROM FunctionTitle F, Vacancy.dbo.Document D
		WHERE F.FunctionNo = D.FunctionNo
		AND   D.DocumentNo = '#URL.DocNo#' 
	</cfquery>

	<cfset Occ = DefineOcc.OccupationalGroup>
	
	<cfquery name="Group" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   OrganizationObject O, Ref_EntityClass R
		WHERE  ObjectKeyValue1 = '#URL.DocNo#' 
		AND    O.EntityCode    = R.EntityCode
		AND    O.EntityClass   = R.EntityClass
		AND    O.EntityCode    = 'VacDocument'		
	</cfquery>
	
	<cfset param = Group.EntityParameter>
	
</cfif>

<cfquery name="ShowEdition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT R.*, (SELECT count(*) 
	             FROM FunctionOrganization 
				 WHERE SubmissionEdition = R.SubmissionEdition) as Buckets
    FROM   Ref_SubmissionEdition R, 
	       Ref_ExerciseClass C
	WHERE  C.ExcerciseClass   = R.ExerciseClass
	AND    C.Roster           = 1 
	AND    R.Owner            = '#URL.Owner#' 
	<cfif param neq "">
	AND   (R.PostType = '#param#' or R.PostType is NULL)
	</cfif>
	AND    R.Operational      = 1
	AND    R.RosterSearchMode != '0'
	AND   ((R.DateExpiration >= getDate() 
	          OR R.DateExpiration is NULL 
			  OR R.DateExpiration = ''))  			  
</cfquery>

<cfset ed = "">
<cfloop query="showedition">
	<cfif ed eq "">
	   <cfset ed = "'#SubmissionEdition#'">
	<cfelse>
	   <cfset ed = "#ed#,'#SubmissionEdition#'">   
	</cfif>
</cfloop>

<cfif ed eq "">

	<cf_message message="Problem, no roster edition with your access was found for <cfoutput>#URL.Owner#</cfoutput>. Please contact your administrator" return="no">
	<cfabort>

</cfif>

<cfif ShowEdition.recordcount eq "0">

<body>

<cfelse>

<body leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript: reset()">

</cfif>

<cfoutput>
	
	<script language="JavaScript">
	
		ie = document.all?1:0
		ns4 = document.layers?1:0
		
		function hl(itm,fld){
		
		     if (ie){
		          while (itm.tagName!="TR")
		          {itm=itm.parentElement;}
		     }else{
		          while (itm.tagName!="TR")
		          {itm=itm.parentNode;}
		     }
			 
			 	 		 	
			 if (fld != false){		
			 itm.className = "highLight2";
			 }else{		
		     itm.className = "regular";		
			 }
		  }
		  
		function reset() {
		
		ie = document.all?1:0
		ns4 = document.layers?1:0
		
		var count=0;
		
		while (count < 15) {    
		   
		     itm  = window.document.search1.submissionedition[count]
			 
			 if (itm) {
		
		     if (ie){
		          while (itm.tagName!="TR")
		          {itm=itm.parentElement;}
		     }else{
		          while (itm.tagName!="TR")
		          {itm=itm.parentNode;}
		     }		
			 
			 se = window.document.search1.submissionedition[count]
			 
			 if (se) {
			 if (se.checked == true) {
			  itm.className = "highLight2";
			 }
			 }
			 }
				
		    count++;
		   }	
		   
		}   		
		
		w = 0
		h = 0
		if (screen) {
		w = #CLIENT.width# - 60
		h = #CLIENT.height# - 140
		}
		
		function loadform(name, tpe, grd, occ) {
		 	window.open(name + "?PostType=" + tpe + "&PostGrade=" + grd + "&OccGroup=" + occ,  "mandate", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=yes, status=yes, scrollbars=yes, resizable=no");
		}
		
	</script>

</cfoutput>

<cfif URL.Mode neq "Limited">
	
	<table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		
	<tr><td valign="top">
	  
	<cfif URL.mode eq "ssa" or url.mode eq "Vacancy">
		
		<cfif url.scope neq "embed">
			<cf_menuscript>
		</cfif>		
		 
	 	<table width="100%" height="100%" border="0" align="center">
		
		<tr><td height="20">
			 <table width="100%" cellspacing="0" cellpadding="0">
			 <tr>
					 
			 	<cfset ht = "64">
				<cfset wd = "64">
				
				<cfset tabNo = 0>
				
				<cfset tabNo = tabNo + 1>
				<cfset tabClass = "highlight1">
				
				<cf_menutab item       = "#tabNo#" 
				            iconsrc    = "Logos/Roster/Candidate.png" 
							iconwidth  = "#wd#" 
							iconheight = "#ht#" 
							class      = "#tabClass#"
							name       = "Pick a candidate">	
				
				<cfquery name="CheckEdition" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   FunctionOrganization
					WHERE  SubmissionEdition IN (#preservesingleQuotes(ed)#)
				</cfquery>
								
				<cfif CheckEdition.recordcount gt 0>				
				
					<cfset tabNo = tabNo + 1>
								 		
					<cf_menutab item       = "#tabNo#" 
					            iconsrc    = "Logos/Roster/Search-Roster.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "regular"
								iframe     = "rosteradd"
								source     = "iframe:Search1Roster.cfm?#cgi.query_string#"
								name       = "Search full roster">									
					
					<cfset tabClass = "">
				
				</cfif>		
				
				<cfif url.mode eq "Vacancy">
				
					<cfquery name="Doc" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM   Document D
						WHERE  D.DocumentNo = #URL.DocNo# 
					</cfquery>	
					
					<cfset owner = "">
	
					<cfif doc.owner eq "">
					
						<cfquery name="Owner" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM Ref_ParameterOwner D
							WHERE D.Owner IN (SELECT MissionOwner 
							                  FROM   Organization.dbo.Ref_Mission 
											  WHERE  Mission = '#Doc.Mission#')
						</cfquery>
					
						<cfset own = owner.owner>
					
					<cfelse>
					
						<cfquery name="Owner" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   Ref_ParameterOwner D
							WHERE  D.Owner = '#doc.owner#'
						</cfquery>
					
					    <cfset own = owner.owner>
					
					</cfif>
					
					<cfquery name="Shortlist" 
					 datasource="AppsSelection" 
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
						SELECT   F1.*
						FROM     FunctionTitle F, 
						         FunctionOrganization F1, 
								 Ref_SubmissionEdition R,
								 ApplicantFunction F2
						WHERE    F1.SubmissionEdition   = R.SubmissionEdition
						AND      F.FunctionNo           = F1.FunctionNo
						AND      R.EnableAsRoster       = 1
						AND      (F1.GradeDeployment    = '#Doc.PostGrade#' OR F1.GradeDeployment = '#Doc.GradeDeployment#')
						AND      F.OccupationalGroup    = '#Doc.OccupationalGroup#' 
						AND      F.FunctionClass        = '#Owner.FunctionClassSelect#' 
						AND      F2.FunctionId          = F1.FunctionId
					</cfquery>	
					
					<cfif shortList.recordcount gte "1">
					
					<cfset tabNo = tabNo + 1>
					
					<cf_menutab item       = "#tabNo#" 
					            iconsrc    = "Logos/Roster/Candidates.png" 
								iconwidth  = "#wd#" 
								iconheight = "#ht#" 
								class      = "#tabClass#"
								iframe     = "quickadd"
								source     = "iframe:DirectRosterSearch.cfm?#cgi.query_string#"
								name       = "Bucket Search">						
					
					</cfif>		
				
				</cfif>						
											
				<cfif url.wparam neq "ROSTER">			
				
					<cfset tabNo = tabNo + 1>
						
					<cf_menutab item       = "#tabNo#" 
					    iconsrc    = "Logos/Roster/CandidateAdd.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						name       = "Add and pick a candidate"
						iframe     = "candidateadd"
						source     = "iframe:../../Candidate/Details/Applicant/ApplicantEntry.cfm?header=0&next=#url.mode#&id=#url.docno#">											
							
				</cfif>			
							 
			 </tr>
			 </table>
						
		</td></tr>
		
				
		<tr><td height="95%" valign="top">
		
		<table width="100%" height="100%" border="0">
		
		<cfset tabNo = 0>
				
		<cfset tabNo = tabNo + 1>
				
		<cf_menucontainer item="#tabNo#" class="regular">
		
			 <cfset URL.Scope = "Roster">			
			 <cfinclude template="../CandidateSearch.cfm">		
			 
		</cf_menucontainer>	 
				
		<cfif CheckEdition.recordcount gt 0>
		
			<cfset tabNo = tabNo + 1>
			<cf_menucontainer item="#tabNo#" class="hide" iframe="rosteradd"/>					
			
					
		</cfif>
		
		<cfparam name="shortlist.recordcount" default="0">
		
		<cfif url.mode eq "Vacancy">
		
			<cfif shortList.recordcount gte "1">
			
				<cfset tabNo = tabNo + 1>
						
				<cf_menucontainer item="#tabNo#" class="hide" iframe="quickadd"/>					 
				
			</cfif>
		
		</cfif>
				
		<cfset tabNo = tabNo + 1>
		
		<cf_menucontainer item="#tabNo#" class="hide" iframe="candidateadd">
							
		</table>
		
		</td></tr>			 
						 
		</table>	 
		 
	<cfelse>
	
		<table width="100%" height="100%" cellspacing="0" cellpadding="0">
		
			 <tr><td colspan="2" height="100%" valign="top">	
				 
			 <cfinclude template="Search1Roster.cfm">			 
			 </td></tr>
			 
		 </table>		  
					 
	 </cfif>
	 
	 </td></tr>
	 
	 </table>
	 	 	 
<cfelse>

	 
	<!--- Search form --->
	<form action="<cfoutput>Search1Submit.cfm?mode=#URL.Mode#&Owner=#URL.Owner#&Status=#URL.Status#&DocNo=#URL.DocNo#</cfoutput>" method="post" name="search1">
	
		<script language="JavaScript">
		  	document.search1.submit()
		</script>
	
	</form>

</cfif>

<cf_screenbottom html="No">

