
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

<cfinclude template="../Assessment/AssessmentViewScript.cfm">

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
					onchange="getContent('#itm#','#url.documentno#',this.value,document.getElementById('topic_#itm#').value,'#url.actioncode#','#url.mode#','#session.acc#','#url.modality#')">					
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
					onchange="getContent('#itm#','#url.documentno#',document.getElementById('personno_#itm#').value,this.value,'#url.actioncode#','#url.mode#','#session.acc#','#url.modality#')">					
					<cfif itm gt "1">
					<option value="">-- select --</option>
					</cfif>
					<cfloop query="getPhrases">
						<option value="#TopicId#">#TopicSubject#</option>
					</cfloop>				
					</select>		
					
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
				  bind="url:#session.root#/Vactrack/Application/Candidate/Interaction/AssessmentTestContent.cfm?itm=#itm#&documentno=#url.documentno#&personno=#url.PersonNo#&actioncode=#url.actioncode#&competenceid=#getPhrases.Topicid#&mode=#url.mode#&useraccount=#session.acc#" 
				 id="box#itm#">						 			 
			<cfelse>			
			   <cfdiv style="height:100%" id="box#itm#"/>																							
			</cfif>					
			
		</td>
		
		<span class="hide" id="result_#itm#"></span>
		
		</cfloop>	
		
		</tr>				
		</table>
			
	</td></tr>
	</table>

</form>

</cfoutput>

