
<!--- ability to change the label of the title --->

<cf_textareascript>
<cfajaximport tags="cfform">
<cf_menuscript>

<cf_screentop layout="webapp" 
			  jquery="Yes" 
			  height="100" 
			  label="Edit title" 
			  banner="gray" 
			  bannerforce="Yes" 
			  html="No"
			  close = "parent.ColdFusion.Window.hide('EditEditionPosition'); parent.reloadPosition('#url.PositionNo#','#url.submissionEdition#')" 
			  scroll="Yes">


<cfquery name="qExercise"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  E.*, 
	        S.ActionStatus, S.Owner
	FROM    Ref_ExerciseClass E INNER JOIN Ref_SubmissionEdition S
	ON      E.ExcerciseClass    = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#' 
</cfquery> 

<cfquery name="get"
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ExerciseClass E INNER JOIN Ref_SubmissionEdition S
	ON      E.ExcerciseClass    = S.ExerciseClass
	WHERE   S.SubmissionEdition = '#url.submissionedition#' 
</cfquery>

<cfquery name="language"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Ref_SystemLanguage
	WHERE  LanguageCode != ''
	AND    Operational > 0
	ORDER BY LanguageCode	
</cfquery>

<cfquery name="getPosition"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Position
	WHERE  Positionno = '#url.PositionNo#'
</cfquery>

<cfif qExercise.ActionStatus eq "0">
    <cfset mode = "edit">
<cfelse>
	<cfset mode = "view">
</cfif>
 
	
	<table width="95%" height="100%" align="center">
	
		<tr><td>
					
			<table width="97%" height="100%" border="0" align="center">		  		
							
				<cfset ht = "40">
				<cfset wd = "40">
						
				<tr>							
							
						<cf_menutab item       = "1" 					            
						            iconsrc    = "Logos/Staffing/Position.png" 
									iconwidth  = "#wd#" 
									iconheight = "#ht#" 
									class      = "highlight1"
									name       = "Position title"
									source     = "PositionEditionTitle.cfm?positionno=#url.positionno#&submissionedition=#url.submissionedition#">	
						
						<cfset itm = 1>
									
						<cfoutput query="language">		
						
						<cfset itm = itm+1>	
									
					    <cf_menutab item       = "#itm#" 
						            iconsrc    = "Flag/#code#.gif" 
									iconwidth  = "#wd#" 								
									iconheight = "#ht#" 	
									targetitem = "1"							
									name       = "Job Description"
									source     = "#session.root#/Staffing/Application/Assignment/Review/PositionProfile.cfm?accessmode=view&id=#getPosition.PositionParentId#&id1=#url.PositionNo#&languagecode=#languagecode#">
									
						</cfoutput>					
						
						<td width="10%"></td>				
																							
																		 		
					</tr>
			</table>
			
			</td>
		</tr>
		
		<tr><td style="height:100%">
			
			<cf_divscroll style="height:100%">
						
			<table width="96%" 			     
				  height="100%"				  
				  align="center">	  	 		
								
					<cf_menucontainer item="1" class="regular">								
											
						<cfinclude template="PositionEditionTitle.cfm">						
					    	
					<cf_menucontainer>		
					
					
			</table>
			
			</cf_divscroll>
			
			</td>
	</tr>				
		
	</table>
