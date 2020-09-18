
<cf_screentop label="Review" html="No" jquery="Yes">

<cfparam name="url.documentNo" default="1000">
<cfparam name="url.ActionCode" default="VAD999">
<cfparam name="url.PersonNo"   default="">
<cfparam name="url.Status"     default="1">
<cfparam name="url.Mode"       default="view">

<cfquery name="getPerson" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT        *
	FROM          DocumentCandidate
	WHERE 		  DocumentNo = '#url.documentno#' 
	and           Status IN ('1','2','2s')
	AND           EntityClass is NULL
</cfquery>

<cfquery name="getPhrases" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     *
	FROM       FunctionOrganizationTopic
	WHERE 	   FunctionId IN (SELECT FunctionId 
	                          FROM   Functionorganization 
							  WHERE  Documentno = '#url.documentno#')           
	AND        Operational = 1 
	ORDER BY   TopicOrder
</cfquery>

<cfparam name="url.boxes" default="2">

<!--- change or the evaluator score, change text, change content --->

<cfinclude template="AssessmentViewScript.cfm">

<cfoutput>

<cf_textareascript>

<form method="post" name="textevaluation" id="textevaluation">

	<table height="100%" width="100%" class="formspacing" style="background-color:white">
			
	<tr class="labelmedium"><td style="height:40px;font-size:20px;padding-left:10px">
	<cfif url.mode eq "Edit">
	<cf_tl id="Apply received answers">: #session.first# #session.last#
	<cfelse>
	<cf_tl id="Reviewer">: #session.first# #session.last#
	</cfif>
	</td>
	<td align="right" style="font-size:17px;padding-right:8px"><a href="javascript:showquestion('#url.documentNo#','#url.personno#','#url.actioncode#','#url.mode#')">View Questions and submitted answers</a></td>
	
	</tr>
		
	<tr><td style="padding:5px" colspan="2">
		    			
		<table height="100%" width="100%" class="formspacing">
		<tr style="height:20px" class="line labelmedium">
		
			<cfloop index="itm" from="1" to="#url.boxes#">
			<td>			
			
				<table style="border:1px solid silver;border-bottom:0px;width:100%">
								
				<tr class="labelmedium line">
				    <td style="background-color:f4f4f4;padding-left:5px"><cf_tl id="Candidate"></td>
					<td>
					<select id="personno_#itm#" name="personno_#itm#" style="width:100%;border:0px; border-left:1px solid silver" class="regularxxl" id="personno_#itm#" 
					onchange="getContent('#itm#','#url.documentno#',this.value,document.getElementById('topic_#itm#').value,'#url.actioncode#','#url.mode#','#session.acc#')">					
					<cfif itm gt "1">
					<option value="">-- select --</option>
					</cfif>
					<cfloop query="getPerson">
						<option value="#PersonNo#" <cfif url.personno eq personno>selected</cfif>><cfif url.mode eq "View">Candidate #currentrow#<cfelse>#FirstName# #LastName#</cfif></option>
					</cfloop>				
					</select>				
					</td>
				</tr>				
				
				<tr class="labelmedium <cfif url.mode eq 'View'>line</cfif>">
				    <td style="background-color:f4f4f4;padding-left:5px"><cf_tl id="Question"></td>
					<td>
					<select id="topic_#itm#" name="topic_#itm#" style="width:100%;border:0px; border-left:1px solid silver" class="regularxxl" id="personno_#itm#" 
					onchange="getContent('#itm#','#url.documentno#',document.getElementById('personno_#itm#').value,this.value,'#url.actioncode#','#url.mode#','#session.acc#')">					
					<cfif itm gt "1">
					<option value="">-- select --</option>
					</cfif>
					<cfloop query="getPhrases">
						<option value="#TopicId#">#TopicSubject#</option>
					</cfloop>				
					</select>		
					
					</td>
				</tr>	
						
							
				<cfif url.mode eq "Edit">
					<cfset cl = "hide">
				<cfelse>
				    <cfset cl = "">
				</cfif>
								
				<tr class="labelmedium line #cl#">
				    <td style="background-color:f4f4f4;padding-left:5px"><cf_tl id="Evaluation"></td>
					<td>
					
					<cfif itm eq "1">
					
						<cfquery name="get" 
					     datasource="AppsVacancy" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT * 
						 FROM   DocumentCandidateAssessment
						 WHERE  DocumentNo    = '#url.documentno#'
						 AND    PersonNo      = '#getPerson.PersonNo#'
						 AND    ActionCode    = '#url.actionCode#'
						 AND    Competenceid  = '#getPhrases.topicid#'
						 AND    OfficerUserid = '#session.acc#'  
						</cfquery>
						
						<cfset score = get.AssessmentScore>
						<cfset memo  = get.AssessmentMemo>
					
					<cfelse>
					
						<cfset score = "0">
						<cfset memo  = "">						
						
					</cfif>
										
					<cfset lkt = "applyeval('#itm#','#url.documentno#',document.getElementById('personno_#itm#').value,'#url.actioncode#',document.getElementById('topic_#itm#').value,'#session.acc#','score_#itm#','score')">
																				
					<select name="score_#itm#" id="score_#itm#" disabled
					 class="regularxxl" style="border:0px; border-left:1px solid silver;width:100%" onchange="#lkt#">
					    <option value="0" <cfif Score eq "0">selected</cfif>>--<cf_tl id="Select">--</option>
						<option value="1" <cfif Score eq "1">selected</cfif>><cf_tl id="Out-standing"></option>
						<option value="2" <cfif Score eq "2">selected</cfif>><cf_tl id="Satisfactory"></option>
						<option value="3" <cfif Score eq "3">selected</cfif>><cf_tl id="Partially satisfactory"></option>
						<option value="4" <cfif Score eq "4">selected</cfif>><cf_tl id="Unsatisfactory"></option>
					</select>								
					
					</td>
				</tr>					
								
				<tr class="hide"><td id="result_#itm#"></td></tr>
				
				<cfset lkt = "applyeval('#itm#','#url.documentno#',document.getElementById('personno_#itm#').value,'#url.actioncode#',document.getElementById('topic_#itm#').value,'#session.acc#','memo_#itm#','memo')">
				
				<cfparam name="get.AssessmentMemo" default="">				
													
				<tr class="labelmedium #cl#">	
					<td valign="top" style="padding-top:5px;background-color:f4f4f4;padding-left:5px"><cf_tl id="Comments"></td>			    		
					<td>
					<textarea name="memo_#itm#" id="memo_#itm#" disabled onchange="#lkt#"
					  style="border:0px;border-left:1px solid silver;background-color:ffffaf;font-size:15px;padding:4px;resize: none;width:100%;height:70px">#memo#</textarea>
					</td>										
				</tr>	
						
				</table>
				
				
			</td>
			</cfloop>			
		</tr>
					
		<tr>
		<cfloop index="itm" from="1" to="#url.boxes#">
		
		<td style="height:95%;width:50%;padding:4px;border:1px solid silver;border-top:0px" valign="top">	
		
			<cfif itm eq "1">
						
		    <cf_securediv style="height:100%" 
			  bind="url:#session.root#/Vactrack/Application/Candidate/Assessment/AssessmentViewEditContent.cfm?itm=#itm#&documentno=#url.documentno#&personno=#url.PersonNo#&actioncode=#url.actioncode#&competenceid=#getPhrases.Topicid#&mode=#url.mode#&useraccount=#session.acc#" 
			 id="box#itm#">
						 			 
			<cfelse>
			
			<cfdiv style="height:100%" id="box#itm#"/>														
									
			</cfif>					
			
		</td>
		
		</cfloop>	
		
		</tr>				
		</table>
			
	</td></tr>
	</table>

</form>

</cfoutput>

