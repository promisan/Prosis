
<cfparam name="url.mode" default="read">

<cf_tl id="This activity is dependent on the completion of" var="1" class="message">
<cfset msg1="#lt_text#">

<cfquery name="Activity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   ProgramActivity A, Program P
	WHERE  A.ProgramCode = P.ProgramCode
	AND    A.ActivityId = '#url.ActivityId#' 
</cfquery>

<cfif url.mode eq "Edit">

	<cf_tl id="Progress report" var="1">
	<cfset Progress="#lt_text#">
	
	<cf_screentop height="100%" scroll="Yes" html="yes" layout="webapp" banner="gray"  jquery="yes"
	     options="#Activity.ActivityDescription#"  label="#Progress# / #Activity.ProgramName#">
	  
	<cf_FileLibraryScript>
	<cfajaximport tags="cfdiv,cfform">
	<cf_calendarscript>
	
	<script>
			
		function revise(st, no) {
		
			se  = document.getElementById("Rev"+no)
			
			if ((st == "1") || (st== "0")) {
			   se.className = "Hide"
			   se.value = ""  
			   } else {
			   se.className = "Regular"
			   }
		}

	
	</script>

</cfif>

<cfparam name="URL.fileNo" default="">
<cfparam name="URL.mode" default="read">

<cfquery name="Param" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Parameter
</cfquery>

<cfset mission    = Activity.Mission>

<cfquery name="Output" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    O.*
	FROM      #CLIENT.LanPrefix#ProgramActivityOutput O
	WHERE     O.ActivityId = '#ActivityId#' 
	  AND     O.RecordStatus != '9'
	 ORDER BY ActivityOutputDate 
</cfquery>

<cfparam name="URL.ProgramCode" default="#Output.ProgramCode#">
<cfparam name="URL.Period"      default="#Output.ActivityPeriod#">

<cfif url.fileNo eq "">

	<cfset FileNo = round(Rand()*100)>

	<cfset ProgramFilter = "ProgramCode = '#Activity.ProgramCode#'">		
	<cfinclude template="../../Tools/ProgramActivityPendingPrepare.cfm">

</cfif>

<cfquery name="Parameter" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#mission#'
</cfquery>

<!--- check access --->

<cfinvoke component  = "Service.Access"
      Method         = "ProgramProgress"
   	  Role           = "ProgressOfficer"
	  ProgramCode    = "#Activity.ProgramCode#"
	  Period         = "#Activity.ActivityPeriod#" 
	  OrgUnit        = "#Activity.orgunit#"
      ReturnVariable = "ProgressAccess">	
	  
<cfoutput>

<table width="100%" cellspacing="0" cellpadding="0">

<tr><td id="box#activityid#">

<CFFORM  method="POST" name="progress#activityid#">	 
		 
<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center">

<tr><td height="3"></td></tr>	

<cfset line = 0>	
<cfset period = "">
<cfset out = 0>
		 
<cfif Output.recordcount eq "0">

	<tr><td align="center" class="labelit">No outputs defined</td></tr>

<cfelse>		
		 
	<cfloop query="Output">
	
	    <cfset out = out + 1>
		<cfset outdte = ActivityOutputDate>
		
		<tr><td height="3"></td></tr>	
			
		<tr><td style="padding:10px"><table style="border:1px solid silver">
		<tr>
	   		<td height="70" width="4%" style="padding-left:10px"><font color="gray">
			<cfif targetid neq "">
				<img src="#SESSION.root#/Images/logos/program/target.png" height="32" alt="Milestone/Output" border="0" align="absmiddle">
			<cfelse>
				<img src="#SESSION.root#/Images/milestone1.png" height="32" alt="Milestone/Output" border="0" align="absmiddle">
			</cfif>
			</td>	    	
	    	<td width="74%" class="labellarge" style="padding-left:10px;padding-right:5px"><font color="black">
			
			<cfif targetid neq "">
						
				<cfquery name="Target" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT    *
					FROM      #CLIENT.LanPrefix#ProgramTarget
					WHERE     TargetId = '#TargetId#' 		
				</cfquery>
				
				<table>
				
					<tr><td class="labellarge">#Target.TargetReference# #Target.TargetDescription#</td></tr>
					<tr><td class="labelmedium">#Target.TargetIndicator#</td></tr>
					
				</table>
									
			<cfelse>			
				#Output.ActivityOutput#
			</cfif>
			
			</td>
			<td width="7%" class="labellarge"><font color="black">#DateFormat(ActivityOutputDate, CLIENT.DateFormatShow)#&nbsp;</font></td>	
		</tr>
		</table></td></tr>
				
		<cfquery name="ListPriorProgress" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT *
		    FROM ProgramActivityProgress A, 
			     Ref_Status S 
		    WHERE A.OutputId   = '#Output.OutputId#' 
		    AND A.ProgramCode  = '#Output.ProgramCode#' 
		    AND A.ProgressStatus = S.Status 
			AND	A.RecordStatus != 9
		    AND S.ClassStatus = 'Progress' 
			ORDER BY Created
	    </cfquery>	
			
		<cfif ListPriorProgress.recordcount eq "0">
		
		<tr class="line"><td colspan="3" class="labelmedium" align="center"><font color="808080">There are no progress reports recorded</font></td></tr>
		
		<cfelse>
		
		<tr class="line">
			    	
	    <td colspan="3">
		   				
			<table width="96%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
					 
			 <tr><td height="3"></td></tr>  	
			 	  
			  <cfloop query="ListPriorProgress">
			  				   
					   <tr>
						<td align="left" height="20" class="labelmedium"><cf_tl id="Output Status"> per #DateFormat(ProgressStatusDate, CLIENT.DateFormatShow)#:
						<td width="70%" align="left" class="labellarge">
						 <cfif ProgressStatus eq 0>
							     <img src="#SESSION.root#/Images/arrow.gif" alt="" border="0" align="absmiddle">&nbsp;<font color="FF0000">
							 <cfelseif ProgressStatus eq 1>
								 <img src="#SESSION.root#/Images/check.gif" alt="" border="0" align="absmiddle">&nbsp;<font color="green">
							 <cfelseif ProgressStatus eq 2>
								 <img src="#SESSION.root#/Images/pending.gif" alt="" border="0" align="absmiddle">&nbsp;<font color="0080FF">
							 <cfelse>
								 <img src="#SESSION.root#/Images/pending.gif" alt="" border="0" align="absmiddle">&nbsp;<font color="0080FF">
							 </cfif>
							 #Description#	
						</td>
						<TD width="5%" style="padding-right:5px">
						
							<cfif ProgressAccess eq "EDIT" or ProgressAccess eq "ALL">
							  
							  <cf_img icon="delete" tooltip="Remove Entry" 			
								   onclick="ptoken.navigate('#SESSION.root#/programrem/application/activity/progress/OutputProgressDelete.cfm?mode=#url.mode#&mission=#activity.mission#&fileno=#fileNo#&progressid=#progressId#&activityid=#activityid#','box#activityid#')">							
								
							</cfif>
							
						</td>
						</tr>
						
						<tr class="labelmedium">						
						<td><cf_tl id="Reporting Officer">:</td>
						<td>#OfficerFirstName# #OfficerLastName# [#DateFormat(Created, CLIENT.DateFormatShow)# #TimeFormat(Created, "HH:MM")#]</td>
						</tr>
						
						<cfif OutputCompletion neq "0" and OutputCompletion neq "100">
						<tr class="labelmedium">
						   <td height="20"><cf_tl id="Percentage">:</td>
						   <td colspan="3"><b>#OutputCompletion# %</td>				  
						</tr>
						</cfif>
						
						<cfif ProgressMemo neq "">
						<tr class="labelmedium">
						   <td height="20"><cf_tl id="Memo">:</td>
						   <td colspan="3">#ProgressMemo#</td>				  
						</tr>
						</cfif>
						
						<tr><td colspan="4">
						
						<cfif ListFind("ALL",ProgressAccess) GT 0>	
						   <cfset remove = "Yes">
						<cfelse>
						   <cfset remove = "No">
						</cfif> 
						
						<cfif attachmentid eq "">   
						
						<cf_filelibraryN
							DocumentPath="#Param.DocumentLibrary#"
							SubDirectory="#ProgramCode#" 
							Filter="prg#progressid#"
							Insert="no"
							Box="att#progressid#"
							loadscript="no"
							Remove="#remove#"
							Highlight="no"
							Rowheader="no"
							Width="100%"
							Listing="yes">		
							
						<cfelse>				
											
						<cf_filelibraryN
							DocumentPath="#Param.DocumentLibrary#"
							SubDirectory="#ProgramCode#" 
							Filter="#attachmentid#"
							Insert="no"
							Box="att#progressid#"
							loadscript="no"
							Remove="#remove#"
							Highlight="no"
							Rowheader="no"
							Width="100%"
							Listing="yes">	
							
						</cfif>	
												
						</td></tr>	
									   			
						<tr><td colspan="4" height="1" class="line"></td></tr>
						
											
			   </cfloop>
			     
			  </table>	
			  
		</td></tr>	
		
		</cfif> 
			
		 <!--- allow ONLY to report progress on this activity 
		 if the activity which is the parent of this action has been completed --->	 
		 			 	     	   
		 <cfquery name="ParentPending" 
	      datasource="AppsProgram" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
		  SELECT  Pending.*, P.ActivityParent
		  FROM    ProgramActivity A INNER JOIN
	              ProgramActivityParent P ON A.ProgramCode = P.ProgramCode AND A.ActivityPeriod = P.ActivityPeriod AND A.ActivityId = P.ActivityId INNER JOIN
	              userQuery.dbo.#SESSION.acc#ActivityPending#FileNo# Pending ON P.ProgramCode = Pending.ProgramCode AND P.ActivityPeriod = Pending.ActivityPeriod AND 
	              P.ActivityParent = Pending.ActivityId
		  WHERE A.ActivityId = '#ActivityId#'			 
		 </cfquery>		
		 	 
		 <cfif ParentPending.recordcount gte "1">
		 
		 <tr><td colspan="4" bgcolor="ffffcf">
		 
			 <table width="95%" cellspacing="0" cellpadding="0" align="center">
			 <tr class="labelmedium"><td colspan="2">#msg1#:</td></tr>
			 <cfloop query="ParentPending">
			  <tr class="labelmedium"><td style="width:20px">-</td><td>#ActivityDescription#</td></tr>
			 </cfloop>
			 </table>
			 
		 </td>
		 </tr> 
		 
		 </cfif>
		
		 <cfif ParentPending.recordcount eq "0" 
			 AND (ProgressAccess is "EDIT" OR ProgressAccess is "ALL")> 	
			 		 		 	
			     <!--- retrieve if this is completed bbut based on last progress report for each of the output --->	
				 
			     <cfquery name="CompletedOutput" 
			      datasource="AppsProgram" 
			      username="#SESSION.login#" 
			      password="#SESSION.dbpw#">
				  SELECT * 
				  FROM   ProgramActivityProgress
				  <!--- for each output take the last report and then check if the last reports states completed --->
				  WHERE  Created IN (SELECT MAX(Created)
								     FROM   ProgramActivityProgress 
								     WHERE  OutputId = '#Output.OutputId#'	
									 AND    RecordStatus != '9')
				    AND  OutputId = '#Output.OutputId#'	
				    AND  ProgressStatus = '1'
					AND  RecordStatus != '9' 
				 </cfquery>
			 
				 <!--- NOT completed so allow for input --->
				 
				 <cfif CompletedOutput.recordcount eq "0">
						
					 <!--- pointer to identify that the activity can not be completed yet --->
					 		 		     
				     <cfset line = line+1>		
					 
					 <cfif url.mode neq "Read">
					 
						<tr><td colspan="4" height="30" align="center">
						 	 <cfinclude template="ActivityProgressInput.cfm"> 
							</td>
						</tr>	
					
					 </cfif>
					 	
				 </cfif>	
			 
		</cfif> 
						    
	</cfloop> 
	
	<cfif url.mode eq "Read">
	
		<cfif line gt "0" and ParentPending.recordcount eq "0" 
			 AND (ProgressAccess is "EDIT" OR ProgressAccess is "ALL")>			 
				
		<tr><td colspan="4" height="30" class="labelmedium">
				
			<cf_tl id="Press here to Report Activity Progress" var="1">
			<cfoutput>
			<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">			
			<a href="javascript:progressreport('#activityid#')"><font color="0080C0">#lt_text#</font></a>	
			</cfoutput>
				  
		</td></tr>
		<tr class="hide"><td height="1" id="act#activityid#"></td></tr>
		
		<tr><td height="3"></td></tr>
		
		<cfif Activity.ActivityDate gt now()>
		
			<script>
			try {
			 statusprogress("#ActivityId#","OnSchedule")	} catch(e) {}
		 	</script>
		
		<cfelse>
		
			<script>
			try {
			 statusprogress("#ActivityId#","Overdue")	} catch(e) {}
		 	</script>
		
		</cfif>
				
		<cfelseif ParentPending.recordcount eq "0">
					 
			<script>
			try {
			 statusprogress("#ActivityId#","Completed")	} catch(e) {}
		 	</script>
		
		</cfif>
		
	<cfelse>
	
			<cfif line gt "0" and ParentPending.recordcount eq "0" 
			 AND (ProgressAccess is "EDIT" OR ProgressAccess is "ALL")>		
			 
			 <tr><td colspan="4">
			
			<table width="100%" align="center">
			<tr><td height="30" align="center">
			<cf_tl id="Submit" var="1">
			<input type="button" 
			  name="Submit" id="Submit" 
			  onclick="ptoken.navigate('#SESSION.root#/programrem/application/activity/progress/ActivityProgressSubmit.cfm?mode=#url.mode#&mission=#activity.mission#&activityid=#activityid#&fileno=#url.fileNo#','act#activityid#','','','POST','progress#activityid#')"
		 	  class="button10g" 
			  value="<cfoutput>#lt_text#</cfoutput>">
			</td></tr>
			
			<tr><td height="1" id="act#activityid#"></td></tr>
			
			<tr><td height="3"></td></tr>
			</table>
			
			</td></tr>	 
		
		</cfif>
		
	
	</cfif>
	
	<!--- get the last report date of any of the progress reports that state completion to get
	the right end date for the activity itself --->
	
	<cfquery name="LastProgress" 
	    datasource="AppsProgram" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		    SELECT   TOP 1 ProgressStatusDate, ProgressStatus 
		    FROM     ProgramActivityProgress  
			WHERE    OutputId  IN (
			                       SELECT OutputId 
			                       FROM   ProgramActivityOutput
			                       WHERE  ActivityId = '#URL.ActivityId#'
								   AND    RecordStatus != '9'
								  )
			AND      RecordStatus != '9'					
			AND      ProgressStatus = '1' 
			ORDER BY ProgressStatusDate DESC		   
	</cfquery>	
	
	<!--- check if this is enabled --->
	
	<cfif Parameter.ProgressApply eq "1">
	
		<!--- check if there is at progress report and if this progress report states completion --->
	
		<cfif LastProgress.recordcount eq "1">
			
			<!--- we determined that none of the output lines = pending = not completed yet) so we are good to go  --->	
				
			<cfif line eq "0">
				    			
					<cfif Activity.ActivityDate neq LastProgress.ProgressStatusDate>
					
						<cfif LastProgress.ProgressStatusDate gte Activity.ActivityDateStart>
						
						  <!--- the progress report observation date has a equal/later date than the activity start and as such
						  we will update the field ActivityDate with the correct end date and keep the original date
						  in the field ActivityDate end --->
						  									
							<cf_ActivityProcess 
							 ProgramCode  = "#URL.ProgramCode#"
							 ActivityId   = "#URL.ActivityId#"
							 DateEnd      = "#dateformat(LastProgress.ProgressStatusDate,CLIENT.DateFormatShow)#">
							 
						<cfelse>
												
						  <!--- the progress report observation completion date has a date earlier than the activity start and as such
						  we will update the field ActivityDate with the start date only, we assumed this is a very unlikely scenario --->
						
							<cf_ActivityProcess 
							 ProgramCode  = "#URL.ProgramCode#"
							 ActivityId   = "#URL.ActivityId#"
							 DateEnd      = "#dateformat(Activity.ActivityDateStart,CLIENT.DateFormatShow)#">
							 				 
						</cfif>	 
									
					</cfif>
					
			<cfelse>
			
				    <!--- not completed yet or not completed anymore, so revert the end date to the 
					planned enddate here --->
						
					<cfif LastProgress.ProgressStatusDate neq Activity.ActivityDate 
					    AND Activity.ActivityDateEnd neq "">	
											
						<cf_ActivityProcess 
						 ProgramCode  = "#URL.ProgramCode#"
						 ActivityId   = "#URL.ActivityId#"
						 DateEnd      = "#dateformat(Activity.ActivityDateEnd,CLIENT.DateFormatShow)#">
								
					</cfif>
						
			</cfif>
			
		<cfelse>
		
			<!--- revert activity --->
		
			<cf_ActivityProcess 
					 ProgramCode  = "#URL.ProgramCode#"
					 ActivityId   = "#URL.ActivityId#"
					 DateEnd      = "#dateformat(Activity.ActivityDateEnd,CLIENT.DateFormatShow)#">
			
					
		</cfif>
	
	</cfif>		
	
	<input type="hidden" name="line" id="line" value="<cfoutput>#line#</cfoutput>">
	
	</cfif>
	
</table>

</td></tr></table>

</cfform>	

</cfoutput>

<cfif url.mode eq "Edit">

	<cf_screenbottom layout="webapp">

</cfif>




