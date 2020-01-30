
<!--- ---------------------- --->
<!--- ----review cycle------ --->
<!--- ---------------------- --->

<!--- we have 5 status

	0 = edit
	1 = in process
	2 = reviewed
	3 = completed
	8 = unsubscribed = action
	9 = denied : workflow

--->

<cfparam name="url.ProgramCode"     default="">
<cfparam name="url.Period"          default="">
<cfparam name="url.CycleId"         default="1">
<cfparam name="url.ReviewId"        default="">
<cfparam name="url.ObjectKeyValue4" default="">
<cfparam name="url.Header"          default="1">
<cfparam name="url.OpenMode"        default="Standard">
<cfparam name="url.Refer"           default="">

<cfif url.openmode eq "embed">

	<!--- no scripts --->

<cfelse>
	
	<cfif url.refer eq "workflow">
		<cf_screenTop height="100%" html="Yes" jquery="Yes" scroll="yes" label="Review" layout="webapp">
	<cfelse>
		<cf_screenTop height="100%" html="No"  jquery="Yes" scroll="yes">	
	</cfif>	
	
	<cfajaximport tags="cfmenu,cfdiv,cfwindow">
	<cf_ActionListingScript>
	<cf_FileLibraryScript>

</cfif>

<!--- ----------------------------------------------------------------------------------- --->
<!--- provision to disable workflows for review for projects that are no longer activated --->
<!--- ----------------------------------------------------------------------------------- --->

<cfquery name="Reset" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE    OrganizationObject
	SET       Operational = 0
	WHERE     ObjectId IN (
	             SELECT     O.ObjectId
                 FROM       OrganizationObject O 
				            INNER JOIN Program.dbo.ProgramPeriod Pe ON 
								O.ObjectKeyValue1 = Pe.ProgramCode AND 
								O.ObjectKeyValue2 = Pe.Period AND 
	                            O.ObjectKeyValue1 = Pe.ProgramCode AND 
								O.ObjectKeyValue2 = Pe.Period
                 WHERE      O.EntityCode = 'EntProgramReview' 
		         AND        Pe.RecordStatus = '9'
				 )
	AND       Operational = 1			 
</cfquery>				 

<cfif url.ReviewId neq "">
	
	<cfquery name="Review" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    *
		FROM      ProgramPeriodReview
		WHERE     ReviewId = '#url.reviewid#'			
	</cfquery>	
			
	<cfset url.ProgramCode = review.ProgramCode>
	<cfset url.Period      = review.Period>
					
</cfif>

<cfoutput>

	<script language="JavaScript">
	
	    function reloadcycle(cycle) {
		     window.location = "#session.root#/ProgramREM/Application/Program/ReviewCycle/ReviewCycleView.cfm?header=#url.header#&ProgramCode=#url.ProgramCode#&Period=#url.period#&cycleid="+cycle 			
		}		
		
		function present(mode, id) {	     		  		  
			w = #CLIENT.width# - 100;
			h = #CLIENT.height# - 140;
			
			docid = document.getElementById("printdocumentid").value;
			
			if (docid != "") {			   
				window.open("#SESSION.root#/Tools/Mail/MailPrepare.cfm?docid="+docid+"&id="+mode+"&id1="+id,"_blank", "left=30, top=30, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
			} else {
				alert("No format selected");
			}	  
		} 
		
		<!--- call validations for the whole project --->
		parent.parent.doProjectValidations();
	</script>
	
</cfoutput>
	
<table width="99%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">

    <cfif url.header eq "0">
			
		<cfquery name="InProcess" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT     DISTINCT V.ReviewCycleId,
			           R.Description, 
					   R.DateEffective
			FROM       ProgramPeriodReview V, Ref_ReviewCycle R
			WHERE      V.ReviewCycleId = R.CycleId
			AND        V.ProgramCode = '#url.ProgramCode#'			
			AND        V.Period      = '#url.period#'
			AND        R.DateEffective < getDate()
			ORDER BY   R.DateEffective
		</cfquery>	
		
		<cfif url.cycleid eq "0">				
			<cfset url.cycleid = InProcess.ReviewCycleid>
		</cfif>	
		
	<cfelse>
		
		<cfparam name="InProcess.recordcount" default="1">		
				
	</cfif>	
				
	<cfquery name="Cycle" 
	  datasource="AppsProgram" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_ReviewCycle
			WHERE     CycleId = '#url.CycleId#'  
	</cfquery>		
		
	<cfif url.ReviewId eq "">
			
		<cfquery name="Review" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      ProgramPeriodReview
			WHERE     ProgramCode     = '#url.programcode#'		
			AND       Period          = '#url.period#'
			AND       ReviewCycleId   = '#url.cycleid#'						
			<cfif cycle.EnableMultiple eq "1">
			AND       ActionStatus < '3'
			</cfif>
			ORDER BY Created DESC
		</cfquery>	
				
		<cfset url.reviewid = review.ReviewId>
		
	</cfif>
	
	<tr>
	 	<td style="padding-left:5px">		
				
			<cfoutput>
			
				<cfif InProcess.recordcount gte "1">
					
				<table>		
				
					<tr>
					
					<cfif url.header eq "0">	
					
					<td style="padding-left:4px;padding-right:10px">		
					
					<select name="CycleSelect" class="regularxl" onchange="reloadcycle(this.value)">
						<cfloop query="inProcess">
							<option value="#ReviewCycleId#" <cfif url.cycleid eq reviewcycleid>selected</cfif>>#Description#</option>
						</cfloop>
					</select>				
							
					</td>
					
					</cfif>
																		
				    <cfif url.ReviewId neq "">
															
					  	<td height="20" width="120" class="labelit"><font color="808080"><cf_tl id="Hardcopy format"> :</td>
						<td class="labelit" width="130">					
						
							<cfquery name="Document" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT * 
									FROM   Ref_EntityDocument 
									WHERE  EntityCode   = 'EntProgramReview'
									AND    DocumentType = 'document'
									AND    DocumentId IN (SELECT DocumentId 
									                      FROM   Ref_EntityDocumentMissionPeriod
														  WHERE  Mission = '#cycle.mission#'
														  AND 	 Period = '#cycle.period#')							  					  
														  
							</cfquery>
							
							<cfquery name="getGroup" 
							  datasource="AppsProgram" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
								SELECT    *
								FROM      ProgramGroup
								WHERE     ProgramCode = '#url.ProgramCode#'  
							</cfquery>		
														
							<select name="printdocumentid" id="printdocumentid" style="width:200px" class="regularxl enterastab">
								<option value="">-- <cf_tl id="select"> --</option>	  
								<cfloop query="Document">
								
									<cfset show = 0>
									
									<cfif DocumentStringList eq "">								
										<option value="#DocumentId#">#DocumentCode# #DocumentDescription#</option>
									<cfelse>
									
									    <cfif getGroup.recordcount eq "0">
										
										   <option value="#Document.DocumentId#">#Document.DocumentCode# #Document.DocumentDescription#</option>
										
										<cfelse>
																		     								
											<cfloop query="getGroup">
											    <cfif findNoCase(ProgramGroup,Document.DocumentStringList)>
												    <cfset show = 1>
												</cfif> 						
											</cfloop>	
											
											<cfif show eq "1">
												<option value="#Document.DocumentId#">#Document.DocumentCode# #Document.DocumentDescription#</option>
											</cfif>		
										
										</cfif>							
									
									</cfif>	
								</cfloop>
							</select>
						
						</td>
						
						<td width="130">								
						
							<table class="formspacing"> 							
								<tr>							
									<td style="padding-left:3px"></td>
									<td>
										<button onClick="present('mail','#url.reviewid#')" type="button" class="button3">
											<img src="#SESSION.root#/Images/mail.png" style="height:40px;" alt="Send eMail" border="0" align="absmiddle">
										</button>
									</td>
									<td>|</td>
									<td>
										<button onClick="present('pdf','#url.reviewid#')" type="button" class="button3">
											<img src="#SESSION.root#/Images/pdf.png" alt="Print" border="0" style="height:23px;width:28px" align="absmiddle">
										</button>
									</td>
									<td>|</td>									
								</tr>							
							</table>				
						
						</td>
										
					</cfif>
					
					</tr>
					
				</table>
				
				</cfif>
							
				
			</cfoutput>
		</td>
	</tr>
	<tr><td height="1" class="line"></td></tr>
	
	<cfif url.header eq "1" and url.openmode eq "Standard">
	
		<tr><td style="padding:10px">
			<cfset url.attach = "0">
			<cfinclude template="../Header/ViewHeader.cfm">
			</td>
		</tr>
		
	<cfelse>			
				
		<cfquery name="CheckMission" 
			 datasource="AppsEmployee"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 SELECT   *
				 FROM     Organization.dbo.Ref_EntityMission 
				 WHERE    EntityCode     = 'EntProgram'  
				 AND      Mission        = '#url.Mission#' 
		</cfquery>
	
		<cfquery name="Program" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      ProgramPeriod
				WHERE     ProgramCode     = '#url.programcode#'		
				AND       Period          = '#url.period#'			
		</cfquery>	
	
	</cfif>			
	 
	<cfif Program.Status eq "0" and CheckMission.workflowEnabled eq "1" and Program.ProgramClass neq "Program">
	
		<tr><td style="padding-top:10px;border:0px solid silver;height:60" colspan="2" class="labellarge" width="100%" valign="top" align="center">
		 <font color="FF0000"><cf_tl id="Your new project record has not been cleared. Please contact your administrator"></td></tr>
	
	<cfelse>
		
	<tr><td style="padding-left:10px;padding-right:10px">
				
	<!--- ------------------------------------------------ --->
	<!--- populate the table initially for relevant topics --->
	<!--- ------------------------------------------------ --->
				
	<cfquery name="getList"
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT     *
		FROM       ProgramPeriodReviewProfile
		<cfif url.reviewid neq "">
		WHERE      ReviewId     = '#url.reviewid#'			
		<cfelse>
		WHERE      1=0
		</cfif>
	</cfquery>
		
	<cfinvoke component="Service.Access"
		Method="Program"
		ProgramCode="#URL.ProgramCode#"
		Period="#URL.Period#"	
		Role="'ProgramOfficer'"	
		ReturnVariable="EditAccess">
		
	<!---
	<cfif url.refer eq "workflow" or 
	      Review.ActionStatus gte "1" or 
		  EditAccess eq "NONE" or 
		  EditAccess eq "READ">
		  --->		
		  
		
		 		 		  	
	<cfif Review.ActionStatus gte "3" or 
		  EditAccess eq "NONE" or 
		  EditAccess eq "READ" or 
		  Program.recordStatus eq "9">		 
		  		  		  
	   <cfset mode = "view">	
	      
	<cfelse>
	
	   <cfset mode = "edit">
	   
	</cfif>   

	<table width="100%">
		
	    <cfif url.reviewid neq "">
		
			<cfquery name="priorReview" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      ProgramPeriodReview
					WHERE     ProgramCode     = '#url.programcode#'		
					AND       Period          = '#url.period#'
					AND       ReviewCycleId   = '#url.cycleid#'
					AND       ReviewId       != '#url.reviewid#'
			</cfquery>	
								
			<cfif PriorReview.recordcount gte "1">
						
				<tr><td class="linedotted">
				<table><tr>
				<td class="labelit" style="padding-left:5px;padding-right:10px"><font color="808080"><cf_tl id="Other actions">:</td>
				<cfoutput query="PriorReview">
				<td class="labelmedium" style="padding-left:5px;padding-right:10px">
				  <a href="ReviewCycleView.cfm?header=#url.header#&cycleid=#url.cycleid#&reviewid=#reviewid#"><font color="0080C0">#OfficerLastName# #dateformat(created,client.dateformatshow)# <cfif actionstatus eq "3">Completed<cfelseif actionstatus eq "9">Denied<cfelse>Pending</cfif></a>
	 		    </td>
				</cfoutput>
				</tr>
				</table>			
				</td></tr>
										
			</cfif>	
			
		</cfif>
		
		
	<cfif mode eq "edit" or Review.ActionStatus eq "8">	
							
			<cfoutput>			
					
			<cfif Cycle.EnableMultiple eq "1">
					
				<cfif Review.ActionStatus eq "8" or url.reviewid eq "">
				
				    <cf_tl id="Open #Cycle.Description#" var="1"> 
					
					<tr><td align="center" style="height:40px" id="process" class="linedotted">
					<input style="width:250;height:29px" 
					   type="button" 
					   name="Submit" 
					   onclick="ptoken.navigate('setSubscription.cfm?header=#url.header#&status=1&reviewid=#Review.ReviewId#&programcode=#url.programcode#&period=#url.period#&cycleid=#url.cycleid#','process')" value="#lt_text#" class="button10g">
					</td></tr>		
									
				<cfelseif Review.ActionStatus eq "1">
				
					<tr><td align="center" style="height:40px" id="process" class="linedotted">
					<input style="width:250;height:29px" type="button" name="Subscribe" value="Cancel submission #Cycle.Description#" 
					onclick="ptoken.navigate('setSubscription.cfm?header=#url.header#&status=0&reviewid=#Review.ReviewId#&programcode=#url.programcode#&period=#url.period#&cycleid=#url.cycleid#','process')" class="button10g">
					</td></tr>		
										
				<cfelse>
				
					<!--- not possible --->	
					
				</cfif>
			
			<cfelse>
						
									
				<cfif Review.ActionStatus eq "8" or url.reviewid eq "">				
				
					<cf_tl id="Open #Cycle.Description#" var="1"> 	
					
				    <!--- only visible if the period is valid --->
										
					<cfif Cycle.DateEffective lte now() and Cycle.DateExpiration gte now()>
					
										
						<tr><td align="center" class="linedotted" style="height:40px" id="process">
						<input style="width:250;height:29px" 
						   type="button" 
						   name="Subscribe" 
						   onclick="ptoken.navigate('setSubscription.cfm?header=#url.header#&status=1&reviewid=#Review.ReviewId#&programcode=#url.programcode#&period=#url.period#&cycleid=#url.cycleid#','process')" value="#lt_text#" class="button10g">
						</td></tr>		
											
					</cfif>
					
				<cfelseif Review.ActionStatus eq "0" or Review.ActionStatus eq "1">
				
					 <cf_tl id="Revoke #Cycle.Description#" var="1"> 	
				
					<tr>
						<td align="center" class="linedotted" style="height:40px" id="process">
						<input style="width:250;height:29px" type="button" name="Subscribe" value="#lt_text#" 
						onclick="ptoken.navigate('setSubscription.cfm?header=#url.header#&status=8&reviewid=#Review.ReviewId#&programcode=#url.programcode#&period=#url.period#&cycleid=#url.cycleid#','process')" class="button10g">
						</td>
					</tr>		
										
				<cfelse>
								
					<!--- not possible --->	
					
				</cfif>
							
			</cfif>
			
			</cfoutput>
					
	</cfif>
		
					
	<cfif url.reviewId neq "">	
		
				
		<cfif Review.ActionStatus gte "0">	
		
		    <tr><td style="padding-left:4px;height:35" class="linedotted labellarge"><cfif Review.ActionStatus eq "3"><font color="green"><b><cf_tl id="Completed"><cfelseif Review.ActionStatus eq "9"><font color="red"><cf_tl id="Denied"></cfif></td></tr>
		
			<tr><td>
			
			    <form method="post" name="reviewform" id="reviewform">
																	
					<cf_ProgramTextArea
						Table           = "ProgramPeriodReviewProfile" 
						Domain          = "Review"
						TextAreaCode    = "#quotedvalueList(getList.TextAreaCode)#"
						FieldOutput     = "ProfileNotes"
						Join            = "INNER JOIN"
						Mode            = "#mode#"
						Key01           = "ReviewId"
						Key01Value      = "#URL.ReviewId#">
					
				</form>	
							
			</td></tr>		
			
									
			<cfif mode eq "edit" and Review.ActionStatus neq "8">
						
			<tr><td align="center" style="height:40px" id="process">
			
				<cf_tl id="Save" var="1">
			
			    <cfoutput>
				<input style="width:250;height:29px" 
				   type="button" 
				   name="Save" 
				   onclick="Prosis.busy('yes');ColdFusion.navigate('ReviewCycleSubmit.cfm?header=#url.header#&cycleid=#url.cycleid#&reviewid=#url.ReviewId#','process','','','POST','reviewform')"
				   value="#lt_text#" 
				   class="button10g">
				 </cfoutput>  
				</td></tr>		
				<tr><td class="linedotted"></td></tr>
			
			</cfif>	
			
			<!--- --------------------------------------------------------------------------------------------------------- --->
			<!--- 18/6/2016 we check if the text has data and is obligatory, if not then we prevent submitting the workflow --->
			<!--- --------------------------------------------------------------------------------------------------------- --->
										
			<cfset wf = "1">
			
			<cfif mode eq "edit">
			
				<cfquery name="getTopics"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM    Ref_ReviewCycleProfile
						WHERE   CycleId = '#url.Cycleid#'
						AND     ValueObligatory = 1
				</cfquery>		
				
				<cfloop query="getTopics">
				
					<cfquery name="get"
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    ProfileNotes
						FROM      ProgramPeriodReviewProfile
						WHERE     ReviewId = '#url.reviewid#' 
						AND       TextAreaCode = '#TextareaCode#'			
					</cfquery>		
												
					<cfif len(get.ProfileNotes) lte 3>
					
					   <cfset wf = "0">
					 
					 </cfif>			
								
				</cfloop>	
			
			</cfif>	
			
			
			<cfif wf eq "0">			
				 <tr>
				  <td class="labellarge" style="background-color:E35457; color:ffffff; padding:10px; font-size:150%;" align="center">
				  <cf_tl id="Please provide the requested information before continuing">
				  </td>
				 </tr>
			</cfif>	
			
			<cfif Review.ActionStatus neq "8" and wf eq "1">
				
				<cfset wflnk = "ReviewCycleWorkFlow.cfm">
				
				<tr><td width="100%" align="center" style="padding-left:10px;padding-right:10px">
						
					 <cfoutput>
						 
					 	<input type="hidden" id="workflowlink_#URL.ReviewId#" value="#wflnk#"> 					 
					    <cfdiv id="#URL.ReviewId#"  bind="url:#wflnk#?ajaxid=#URL.ReviewId#"/>												
							
					 </cfoutput>	 
							
					</td>
				</tr>	
			
			</cfif>					
								
		</cfif>	
			
	</cfif>			
		
	</table>

	</td>
	</tr>

	</cfif>


</table>

