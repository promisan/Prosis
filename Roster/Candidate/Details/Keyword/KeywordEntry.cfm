
<cfparam name="URL.PHP"         default="Roster">
<cfparam name="URL.ID"    		default="0">  <!--- experience record id to show the values --->
<cfparam name="URL.ID1"   		default="Employment">
<cfparam name="URL.Owner" 		default="">
<cfparam name="URL.Box"   		default="">
<cfparam name="URL.Candidate"   default="1">

<cfif url.candidate eq "1">

	<cfset val = "range">
	<cfset req = "yes">
		
<cfelse>

	<cfset val = "">	
	<cfset req = "no">

</cfif>

<cf_keywordEntryScript>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfquery name="Master" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   DISTINCT 
           ExperienceClass, 
		   R.Description, 
		   DescriptionFull,
           R.ListingOrder, 
		   Par.Parent, 
		   Par.KeywordsMessage
  FROM     #CLIENT.LanPrefix#Ref_ExperienceClass R, 
           OccGroup, 
		   Ref_ParameterSkillParent Par
  WHERE    OccGroup.OccupationalGroup = R.OccupationalGroup   <!--- AND  OccGroup.OccupationalGroup =* R.OccupationalGroup --->
    AND    Par.Parent        = R.Parent
	AND    Par.Code = '#URL.ID1#'  <!--- expereince class employment --->
	AND    Par.Parent IN (#PreserveSingleQuotes(Group)#)  <!--- subportions under employment like level, region, area --->
    AND    Operational       = '1'
	
	<!--- filter only topics that are enabled for the owner --->
	
	<cfif url.owner neq "">
	
		
	AND    ExperienceClass IN (SELECT ExperienceClass 
	                           FROM   Ref_ExperienceClassOwner 
							   WHERE  ExperienceClass = R.ExperienceClass 
							   AND    Owner = '#url.Owner#')
							   
		
	</cfif>
	
 	AND     R.Candidate = '#URL.Candidate#'	
  ORDER BY  Par.Parent DESC, 
            OccGroup.DescriptionFull, 
		    R.ListingOrder 	   		  
		  
</cfquery>

<input type="hidden" name="Rows" value="<cfoutput>#Master.recordcount#</cfoutput>">

<cfoutput query="Master" group="Parent">

  <tr class="line">
  	<td valign="middle">
		
	<table width="100%" cellspacing="0" cellpadding="0">
				
	<cfif url.owner neq "">
	
			 <input type="hidden"
		       name="clCount_#Parent#"
		       value="0"
		       required="No"
		       visible="Yes"
		       enabled="Yes">  
			        		       
	<cfelse>
	
		<tr><td class="labelmedium" style="padding-left:0px">#Parent#
			
		<cfquery name="Count" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  	  SELECT   KeywordsMinimum, 
			           KeywordsMaximum, 
					   KeywordsMessage
			  FROM     Ref_ParameterSkillParent R
			  WHERE    R.Parent IN ('#Parent#')
			  AND      R.Code = '#URL.ID1#'
		</cfquery>
		
		<cfif url.id eq "">
				
			<cfset total = 0>
		
		<cfelse>
		
			 <cfif url.php eq "Roster">
				 
				<cfquery name="Counted" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT   COUNT(S.ExperienceFieldId) AS Total
				  FROM     Ref_ExperienceClass P INNER JOIN
		                   Ref_Experience F ON P.ExperienceClass = F.ExperienceClass INNER JOIN
		                   Ref_ParameterSkillParent R ON P.Parent = R.Parent INNER JOIN
		                   ApplicantBackgroundField S ON F.ExperienceFieldId = S.ExperienceFieldId
				  WHERE    S.ExperienceId = '#URL.ID#' 
				  AND      S.Status       != '9' 
				  AND      P.Parent IN ('#Parent#')
				  AND      F.Status = 1 
				</cfquery>
			
			<cfelse>
									
				<cfquery name="Counted" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT   COUNT(S.ExperienceFieldId) AS Total
				  FROM     Ref_ExperienceClass P INNER JOIN
		                   Ref_Experience F ON P.ExperienceClass = F.ExperienceClass INNER JOIN
		                   Ref_ParameterSkillParent R ON P.Parent = R.Parent INNER JOIN
		                   ApplicantFunctionSubmissionField S ON F.ExperienceFieldId = S.ExperienceFieldId
				  WHERE    S.SubmissionId = '#URL.ID#' 
				  AND      S.Owner        = '#url.owner#' 
				  AND      S.Status       != '9' 
				  AND      P.Parent IN ('#Parent#')
				  AND      F.Status = 1 
				</cfquery>
			
			</cfif>
			
			<cfset total = counted.total>
		
		</cfif>
		
		&nbsp;(#count.KeyWordsMinimum#,#count.KeyWordsMaximum#)
		
		</td>
		
		<td align="right">
		
		<cfif count.KeyWordsMinimum eq "">
		  <cfset min = "0">
		<cfelse>
		  <cfset min = count.KeyWordsMinimum> 
		</cfif>
		
		<cfif count.KeyWordsMaximum eq "">
		  <cfset max = "0">
		<cfelse>
		  <cfset max = count.KeyWordsMaximum> 
		</cfif>
		
		<cfif total eq "">
			<cfset total = 0>
		</cfif>			
									  
		    <cfinput type="Text"
			        name="clCount_#Parent#"
		       		value="#total#"
			       	range="#min#,#max#"
		       		width="2"
		       		message="#count.KeywordsMessage#"
		       		validate="#val#"
		       		required="#req#"		       		
			   		class="regular3"
			   		onError="show_error"
			   		readonly
			   		style="text-align : center; width:20px"
		       		size="1"
		       		maxlength="2">
			   
			 </td>
			 
		 </tr>   
		   
	 </cfif>	   
	
	 </table>
	
	</td>
   </tr>
       
	<cfoutput group="DescriptionFull">
	
	  <cfif DescriptionFull neq "">
		  <tr class="line"><td valign="middle" class="labelmedium" style="height:40px;padding-left:0px">#DescriptionFull#</b></td></tr>  
	  </cfif>
	
		<cfoutput>
	
	    <cfset ar = Master.ExperienceClass>
								
		<tr>
		
		<td>
		
		   <table width="100%" cellspacing="0" cellpadding="0">
		   
		   <tr><td height="20" align="left">
		   
		   <cfif url.id eq "">
				<cfset vId = '00000000-0000-0000-0000-000000000000'>
			<cfelse>
				<cfset vId = URL.ID>							
			</cfif>		
			
			<!--- check if some fields are selected --->
			
			 <cfif url.php eq "Roster">
									
				<cfquery name="Check"
		         datasource="AppsSelection"
		         username="#SESSION.login#"
		         password="#SESSION.dbpw#">
					 SELECT   F.*
					 
					 FROM     #CLIENT.LanPrefix#Ref_Experience F INNER JOIN
			                  ApplicantBackgroundField S ON F.ExperienceFieldId = S.ExperienceFieldId 						  
							  
					 WHERE    S.ExperienceId    = '#vId#'
					 AND      F.Status          = 1
				     AND      F.ExperienceClass = '#Ar#'			
				 </cfquery>
				 			 
			 <cfelse>
			 			 			 
				 <cfquery name="Check"
		         datasource="AppsSelection"
		         username="#SESSION.login#"
		         password="#SESSION.dbpw#">
					 SELECT   F.*
					 
					 FROM     #CLIENT.LanPrefix#Ref_Experience F INNER JOIN
			                  ApplicantFunctionSubmissionField S ON F.ExperienceFieldId = S.ExperienceFieldId 						  
							  
					 WHERE    S.SubmissionId   = '#vId#'
					 AND      S.Owner          = '#url.owner#' 
					 AND      S.Status         != 9
					 AND      F.Status         = 1
				     AND      F.ExperienceClass = '#Ar#'			
				 </cfquery>
			 		 
			 </cfif>
							
			   <table width="100%" height="100%">
			  				  
			   <tr style="cursor: pointer;" class="line fixlengthlist" id="line_#url.box#_#ar#">
			   
			      <td width="50" bgcolor="white" align="center" style="padding:2px">
				  							  			   
					   <img src="#SESSION.root#/Images/portal_max.png" alt="Show keywords" 
					   id="#url.box#_#Ar#Exp" border="0" class="<cfif Check.recordCount gt "0" or URL.Candidate eq 0>hide<cfelse>regular</cfif>" 
					   align="middle" style="cursor: pointer; width:17px;" onClick="expand('#Ar#','#url.box#','#url.id#','#url.id1#','#url.owner#')">
					  
					   <cfif Check.recordCount eq "0">
					   
						   <img src="#SESSION.root#/Images/portal_min.png" 
						    id="#url.box#_#Ar#Min"
						    alt="Hide Keywords" border="0" align="middle" class="<cfif Check.recordCount gt "0" or URL.Candidate eq 0>regular<cfelse>hide</cfif>" style="cursor: pointer; width:17px;" 
						    onClick="expand('#Ar#','#url.box#','#url.id#','#url.id1#','#url.owner#')">
						
					  <cfelse>
					  
						   <img src="#SESSION.root#/Images/finger.gif" alt="Keyword selected" 
						   id="#url.box#_#Ar#Shw" border="0" class="<cfif Check.recordCount gt "0" or URL.Candidate eq 0>regular<cfelse>hide</cfif>" 
						   align="middle">				  	
					   
					   </cfif>
				   
				   </td>
				   
			       <td onClick="expand('#Ar#','#url.box#','#url.id#','#url.id1#')" 
				        class="labelmedium" 
						style="height:34px;padding-left:4px" width="40%"><font color="0080C0">#Description#</font><input type="hidden" name="cl#currentrow#"></td>
				   
				   <td align="right">				   
				  				   
						<cfset URL.AR = ar>						

						<cfif url.id eq "">
							<cfset vId = '00000000-0000-0000-0000-000000000000'>
						<cfelse>
							<cfset vId = URL.ID>							
						</cfif>		
						
						<cfquery name="Class" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *						
						    FROM   Ref_ExperienceClass 									 
							WHERE  ExperienceClass = '#URL.AR#'
							AND    Parent IN ('#Parent#')							
						</cfquery>		
						
						<cfset ClassMin     = Class.KeywordsMinimum>
						<cfset ClassMax     = Class.KeywordsMaximum>	
						<cfset ClassDesc    = Class.Description>	
							
						<cfquery name="CountedInClass" 
						datasource="AppsSelection" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						   
							SELECT   count(*) as Total
									 
						    FROM     Ref_ExperienceClass P INNER JOIN
				                     Ref_Experience F ON P.ExperienceClass = F.ExperienceClass INNER JOIN
				                     Ref_ParameterSkillParent R ON P.Parent = R.Parent INNER JOIN
									 ApplicantBackgroundField A ON A.ExperienceFieldId = F.ExperienceFieldId 
									 AND  ExperienceId = '#vId#' 
									 AND  A.Status != '9'
									 
							WHERE    P.Parent IN ('#Parent#') <!--- main area --->
							AND      P.ExperienceClass = '#URL.AR#' <!--- subarea --->
							AND      F.Status = 1  <!--- field enabled --->
							GROUP BY P.KeywordsMinimum,
							         P.KeywordsMaximum,
									 P.Description 
						</cfquery>															
						
						<cfset total_class  = CountedInClass.total>
						<cfif total_class eq "">
							<cfset total_class= "0">
						</cfif>
						
						<input type="hidden" name="dtCount_#vID#_#URL.AR#_message" id="dtCount_#vID#_#URL.AR#_message" value="Maximum is #ClassMax#">
						<input type="hidden" name="dtCount_#vID#_#URL.AR#_min"     id="dtCount_#vID#_#URL.AR#_min"     value="#ClassMin#">
						<input type="hidden" name="dtCount_#vID#_#URL.AR#_max"     id="dtCount_#vID#_#URL.AR#_max"     value="#ClassMax#">		
						
						<cf_tl id="Attention: Choose at least #ClassMin#, but no more than #ClassMax# of #ClassDesc#" var="1">							
						
						<cfif classmin neq "0" and classmax neq "0">
																	
					    	<cfinput type="Text"
								 name="dtCount_#vID#_#URL.AR#"
								 value="#total_class#"
								 range="#ClassMin#,#ClassMax#"
								 message="#lt_text#"
								 validate="#val#"
								 width="2"
								 required="#req#"								 								 
								 class="regular3"
								 style="font-size:14px;text-align : center; width:20px"
								 size="1"
								 onError="show_error"
								 maxlength="2">		
							 
						</cfif>	 
							 		   	
				   </td>
			   </tr>
			   
			  </table>
			
			</td>
			</tr>
			  
			<cfif Check.recordCount eq "0" and URL.Candidate eq 1>
			  	  <cfset cl = "hide">				
			<cfelse>
				  <cfset cl = "regular">				 
			</cfif>
			  										
	    	 <tr class="#cl#" id="main_#url.box#_#Ar#">			  			
				  <td width="100%" style="padding-left:30px" colspan="2" id="content_#url.box#_#ar#" class="#cl#">				  
					<cfif check.recordcount neq 0 or URL.Candidate eq 0>									
						<cfinclude template="KeywordEntryDetail.cfm">						
					</cfif>					
				  </td>				  
			 </tr>
				
			</table>
			
		</td></tr>
			
		</cfoutput>		

	</cfoutput>		
	
</cfoutput>
				
</table>

<!--- disabled  
<cfoutput>
 	<input type="hidden" name="ExperienceNo" value="#URL.ID#">
</cfoutput>	
--->
