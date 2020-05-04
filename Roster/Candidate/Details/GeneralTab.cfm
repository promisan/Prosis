
<!--- here we take the global default PHP source --->

<cfquery name="Parameter" 
datasource="AppsSelection">
    SELECT *
    FROM   Parameter   
</cfquery>

<cfquery name="Skill"
    datasource="AppsSelection"
    username="#SESSION.login#"
    password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_ParameterSkill	
	<cfif URL.Topic neq "All">
	WHERE Code = '#URL.Topic#' 
	</cfif>
	ORDER BY ListingOrder 
</cfquery>

<cfoutput>
		 
 <cfset sk  = "">
 <cfset dis = "">
	 
 <cfloop query="Skill">
	 <cfset sk = "#sk#,#code#">
 </cfloop>		 
 
<table width="100%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">	

<tr><td height="40">
		
	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0">		  		
								
			<cfset ht = "54">
			<cfset wd = "54">
			
			<tr>
			<cf_tl id="Submissions" var="1">
						
			<cf_menutab item   = "1" 
	            iconsrc        = "Logos/Roster/Submission.png" 
				iconwidth      = "#wd#" 
				iconheight     = "#ht#" 
				name           = "#lt_text#"
				class          = "highlight1"
				source         = "Submission.cfm?source=#url.source#&id=#url.id#">				
				
			<cfset menu = 1>	
				
			<cfloop index="itm" list="#sk#" delimiters=",">
							
				<cfquery name="SkillCode"
				    datasource="AppsSelection"
				    username="#SESSION.login#"
				    password="#SESSION.dbpw#">
				    SELECT *
				    FROM   Ref_ParameterSkill
					WHERE  Code = '#itm#'					
				</cfquery>						
								
				<cfset URL.id2 = itm>	
				
				<cfif SkillCode.allowEdit eq "0">	
				
										
																 
				    <cfsilent>
					
				  	  <cfset URL.id2 = "#itm#">
					  <cfinclude template="#SkillCode.template#">
					  <cfif detail.recordcount eq "0">
				      		<cfset dis = "true">						
				  	  <cfelse>
							<cfset dis = "false">
					  </cfif>		
					  
				    </cfsilent>	 						
				
				<cfelse>
								
					<cfset dis = "false">
				
				</cfif>		
																			  		
				<cfif dis eq "false">	
				
				    <cfset menu = menu+1>  
									
					<cf_menutab item  = "#menu#" 
			            iconsrc       = "Logos/Roster/#SkillCode.Code#.png" 
						iconwidth     = "#wd#" 
						targetitem    = "2"
						iconheight    = "#ht#" 
						name          = "#SkillCode.Description#"
					    source        = "#SESSION.root#/roster/candidate/details/#SkillCode.template#?id=#url.id#&id2=#url.id2#&topic=#url.topic#&source=#url.source#">					  											
							   
			    </cfif>	
						 
			</cfloop> 
			
			<!--- only if the source = global PHP source ---> 
			
			<cfif url.source eq parameter.PHPSource>  				
			
				<cfquery name="SearchResult" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					 SELECT   TOP 1 *
					 FROM     ApplicantSubmission A INNER JOIN
					          ApplicantBackground B ON A.ApplicantNo = B.ApplicantNo
							  <!---  LEFT OUTER JOIN
					          Vacancy.dbo.stApplicantBackground C ON B.ExperienceId = C.ExperienceId 
					     AND  C.DocumentNo = '#Object.ObjectKeyValue1#'
					     AND  C.PersonNo   = '#Object.ObjectKeyValue2#' --->
					 WHERE    A.PersonNo = '#url.id#' 
					 AND      B.Status <> '9' 
					 AND      B.ExperienceCategory NOT IN ('Miscellaneous', 'School')
					 ORDER BY B.ExperienceCategory, B.ExperienceStart DESC 
					</cfquery>
					
					<cfif SearchResult.recordcount gte "0">
						
							<cf_tl id="Assessment" var="1">
					
							<cf_menutab item   = "#menu+1#" 
					            iconsrc        = "Logos/Roster/assessment.png" 
								iconwidth      = "#wd#" 
								targetitem     = "3"
								iconheight     = "#ht#" 
								name           = "#lt_text#"
								source         = "#SESSION.root#/roster/candidate/details/BackGroundRelevant/SelectBackground.cfm?id=#url.id#&id2=#url.id2#&topic=#url.topic#&source={source}">					  											
								
			       </cfif>
				   
			 </cfif>   
	
			 <cfif menu eq "1">
			 
				  <td width="30%" align="center" class="labelmedium"><i>
			   	  <cf_tl id="No Candidate profile information recorded" var="1" class="message">
			  	  <cfset msg = lt_text>
			 	  <font color="red">
				  <b><cf_tl id="Attention">:</b> <cfoutput>#msg#</cfoutput>.</font>
				  </td>
				  
			 </cfif>
			   				   				   
			   </tr>
				
</table>	
</td></tr>

<tr><td class="linedotted"></td></tr>

<tr><td height="100%" valign="top">

<table width="100%" height="100%">
		
	<cf_menucontainer item="1" class="regular">		
		<cfinclude template="Submission.cfm">
	<cf_menucontainer>
		   
	<cf_menucontainer item="2" class="hide">
	      	      
    <cf_menucontainer item="3" class="hide">		
	     <cfinclude template="BackGroundRelevant/SelectBackground.cfm">
	</cf_menucontainer>
	
</table>
	
</td></tr>	

</table>	
		
</cfoutput>	
