<!--- Prosis template framework --->
<cfsilent>
	<proUsr>jmazariegos</proUsr>
	<proOwn>Jorge Mazariegos</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<cfparam name="URL.Owner"    default="">
<cfparam name="URL.Cache"    default="1">
<cfparam name="URL.Inquiry"  default="No">
<cfparam name="URL.Edition"  default="All">
<cfparam name="URL.Status"   default="2">
<cfparam name="URL.Mode"     default="Complete">
<cfparam name="URL.Ajax"     default="Yes">

<cfquery name="Edition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_SubmissionEdition
	WHERE   SubmissionEdition = '#URL.Edition#'
</cfquery>

<!--- added to get a busy effect when loading, not ideal yet --->
<!--- ------------------------------------------------------ --->

<cf_menuscript>
<cf_ListingScript>
<cf_dialogStaffing>	 
<cf_filelibraryscript>
<cf_dialogPosition>

<cf_screentop label="#Edition.EditionDescription# #URL.Owner#"
     band="no"  
	 height="100%" 	
	 line="no"
	 html="yes"
	 jQuery="Yes"
	 systemmodule="Roster"
	 busy="busy10.gif"
	 layout="webapp" 
	 banner="blue" 	 
	 bannerforce="yes"
	 scroll="Yes">	 

	 
<!-- provision to add acdess to general roster --->
<cfinclude template="RosterViewAccess.cfm">  

<cfset cache = url.cache>

<cfif URL.Edition neq "All">

	<cfquery name="Edition" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_SubmissionEdition
		WHERE  SubmissionEdition = '#URL.Edition#'
	</cfquery>
		
	<cfquery name="getBuckets" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  *
		FROM    FunctionOrganization
		WHERE   SubmissionEdition = '#URL.Edition#'
	</cfquery>
	
<cfelse>

	<cfparam name="getBuckets.recordcount" default="1">	
			
</cfif>

<cfdirectory action="LIST" 
	directory="#SESSION.rootPath#\CFReports\Cache\" 
	name="GetFiles" 
	filter="#SESSION.acc#Roster_#URL.Owner#_#url.edition#.htm">
			
<cfif getFiles.datelastModified neq "">
		
	<cfset diff  = datediff("d",getFiles.DateLastModified,now())>
	
<cfelse>

	<cfset diff = "2">
	
</cfif>	

<cfif diff gte "2">
	<cfset cache = "0">	
<cfelse>
	<cfset cache = "0">				
</cfif>

<cfinclude template="RosterViewScript.cfm">

<cfif cache eq "0"  

    or not FileExists("#SESSION.rootPath#/CFReports/Cache/#SESSION.acc#Roster_#URL.Owner#_#URL.ExerciseClass#_#url.edition#.htm")>
	
<cfset FileNo = round(Rand()*40)>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Resource#FileNo#"> 

<!--- grade view --->
 <cfquery name="ResourceInit" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     DISTINCT P.ViewOrder, 
	           P.Code, 
	           MIN(G.PostOrderBudget) as PostOrderBudget, 
			   G.PostGradeBudget
	INTO       userQuery.dbo.#SESSION.acc#Resource#FileNo#
	FROM       Ref_PostGradeBudget G, 
	           Ref_PostGradeParent P, 
			   Applicant.dbo.Ref_GradeDeployment GP,
			   Applicant.dbo.FunctionOrganization FO
	WHERE      FO.GradeDeployment = GP.GradeDeployment
	AND        GP.PostGradeParent = P.Code
	AND        GP.PostGradeBudget = G.PostGradeBudget
	AND        FO.SubmissionEdition IN (SELECT SubmissionEdition 
	                                    FROM   Applicant.dbo.Ref_SubmissionEdition 
										WHERE  Owner = '#URL.Owner#'
										<cfif url.exerciseclass neq "">
										AND ExerciseClass = '#url.exerciseclass#' 
										</cfif>)
	
	GROUP BY   P.ViewOrder, P.Code, G.PostGradeBudget 
	ORDER BY   P.ViewOrder, PostOrderBudget 
</cfquery>


<!--- process table --->
<cfquery name="ResourceInit" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	INSERT INTO dbo.#SESSION.acc#Resource#FileNo#
				(ViewOrder, Code, PostOrderBudget, PostGradeBudget)
	SELECT     P.ViewOrder, P.Code, '999999', 'Subtotal'
	FROM       Employee.dbo.Ref_PostGradeParent P
	WHERE      P.ViewTotal = '1'
	AND        Code IN (SELECT Code FROM #SESSION.acc#Resource#FileNo#)
</cfquery>

<!--- select resource --->
<cfquery name="Resource" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     userQuery.dbo.#SESSION.acc#Resource#FileNo#
	ORDER BY ViewOrder, PostOrderBudget   
</cfquery>

<!--- put rows in an array for quick reference later> --->
<cfloop query="Resource">
   <cfset column[currentRow]       = Resource.PostGradeBudget>
   <cfset columnParent[currentRow] = Resource.Code>
</cfloop>

<cfinclude template="RosterViewPrepare.cfm">

<cfset tblr  = 3+Resource.RecordCount>
<cfset subT = "">

	<table width="100%" height="100%">
	<tr>
	<td id="contentbox" align="center" valign="top" height="100%">
		
	<cfsavecontent variable="HTML">
	
		<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
				
		<tr><td height="20">		
			<cfinclude template="RosterViewLoopSubMenu.cfm">				
		</td></tr>
				
		<tr>
		
		<td style="padding-left:9x;padding-right:9px;height:100%" valign="top">		
		
		<table style="height:100%;width:100%">
				
			<cf_menucontainer item="1" class="<cfif getBuckets.recordcount gte '1' and getPositions.recordcount eq '0'>regular<cfelse>hide</cfif>">						
			
					<cfinclude template="RosterViewLoopContent.cfm">	
						 	
			<cf_menucontainer>	
			
						
			<cf_menucontainer item="2" class="hide">						
							   
				   <table width="100%"><tr><td>
						  			 			  
					<table width="700" border="0">					
					
					<tr><td height="8"></td></tr> 
					<tr class="labelit">
					    <td  style="padding-left:30px"><cf_tl id="Search for">:</b></td>
					    <td><input type="text" class="regularxl" name="search" id="search" size="30" maxlength="40"></td>
					    <td style="padding-left:5px"><input type="checkbox" class="radiol" name="option" id="option" value="1" checked></td>
						<td style="padding-left:5px"><cf_tl id="Use word variants"></td>
					    <td style="padding-left:20px"><cf_tl id="Sort result by">:</b></td>
						<td>
							<select class="regularxl" name="sorting" id="sorting">
								<option value="Function"><cf_tl id="Function"></option>
								<option value="Grade"><cf_tl id="Grade"></option>
							</select>
						</td>
					</tr>
										
					<tr><td height="4"></td></tr> 						
					<tr>
					  <td></td>
					  <td colspan="4">
					  	<cfoutput>
					  	<table>
							<tr>
								<td>
									<cf_tl id="Occ Group" var="1">
									<cf_button value="#lt_text#" onClick="search('occ')">
								</td>
								
								<td>
									<cf_tl id="Function" var="1">
									<cf_button value="#lt_text#" onClick="search('function')">
								</td>
								
								<td>
									<cf_tl id="Job Opening No" var="1">
									<cf_button value="#lt_text#" onClick="search('vacancy')">
								</td>
							</tr>
						</table>
						</cfoutput>
					  </td>
					</tr>
					
					</table>
					
					</td></tr>
										
				    <tr id="dmore">
						<td colspan="1" id="imore" style="padding:10px"></td>
					</tr>
					  
				  </table>
				 								 	
			<cf_menucontainer>		
						
			<cfif getBuckets.recordcount gte "1" or url.edition eq "all" or getPositions.recordcount eq "0">
			
				<cf_menucontainer item="3" class="hide"/>	
				<cf_menucontainer item="4" class="hide"/>	
				<cf_menucontainer item="5" class="hide" iframe="languagebox"/>				
			    <cf_menucontainer item="6" class="hide"/>	
				
				<script>
				    document.getElementById('menu1').click()
				</script>
				
			<cfelse>
			
			    <cfset url.submissionedition = url.edition>		
			    <cf_menucontainer item="3" class="hide"/>				
			    <cf_menucontainer item="4" class="hide"/>	
			    <cf_menucontainer item="5" class="hide" iframe="languagebox"/>				
			    <cf_menucontainer item="6" class="hide"/>	
	
				<script>
				    document.getElementById('menu1').click()
				</script>
								
			</cfif>	
			
			<cfif URL.Edition eq "All">
				<cf_menucontainer item="7" class="hide" iframe="analysisbox"/>						
			</cfif>				
		
			</table>
			
			</td>
		</tr>	
			
	</table>
		
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#Resource#FileNo#"> 
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewL#FileNo#">
	<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewT#FileNo#">
	
	</cfsavecontent>
			
		<cfoutput>#HTML#</cfoutput>
			
		<!---				
		<cfif findNoCase("mode=complete","#CGI.QUERY_STRING#")>
		--->
			
			<cftry>
				<cfdirectory action="CREATE" directory="#SESSION.rootpath#/CFReports/Cache">
				<cffile action="DELETE" file="#SESSION.rootpath#/CFReports/Cache/#SESSION.acc#Roster_#URL.Owner#_#URL.ExerciseClass#_#URL.Edition#.htm">
			<cfcatch></cfcatch>
			</cftry>
			
			<cffile action="WRITE" file="#SESSION.rootpath#/CFReports/Cache/#SESSION.acc#Roster_#URL.Owner#_#URL.ExerciseClass#_#URL.Edition#.htm" output="#HTML#">
		
		<!---						
		</cfif>
		--->
	
	<cfelse>	
	
		<!--- we read from cache --->
		
		 <cfquery name="getPositions" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    Ref_SubmissionEditionPosition
					WHERE   SubmissionEdition = '#URL.Edition#'
		 </cfquery>					
		
		<cfinclude template="../../../CFReports/Cache/#SESSION.acc#Roster_#URL.Owner#_#URL.ExerciseClass#_#URL.Edition#.htm">
	
	</cfif>
	
	</td></tr>
</table>

<cf_screenBottom layout="webapp">

