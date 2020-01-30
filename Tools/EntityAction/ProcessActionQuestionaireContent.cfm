<style>
    body,font{
        font-family:-apple-system,BlinkMacSystemFont,Segoe UI,Roboto,Helvetica Neue,Arial,sans-serif,Apple Color Emoji,Segoe UI Emoji,Segoe UI Symbol;
    }
    TEXTAREA {
	border-color: #cccccc;
	font-size: 9pt;
	overflow: auto;
	width: 95%;
	margin: auto;
	max-width: 400px;
    height: 120px;
}
    h3.lbl{
        margin: 0;
    }
</style>
<div style="max-width:650px;margin: auto;">
<table cellspacing="0" cellpadding="0" align="center">

<cfif entrymode eq "workflow">

	<tr class="hide"><td colspan="3" id="processquestion"></td></tr>
	<tr><td style="padding-top:4px" class="labelmedium" align="center" height="24" colspan="3"><font color="6688aa">Attention: Edits are automatically saved.</font></td></tr>
	
</cfif>

<cfoutput query="Questionaire">
	
	<cfquery name="Content" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT     *,
		
		          (SELECT QuestionScore 
				   FROM   OrganizationObjectQuestion 
				   WHERE  ObjectId   = '#Object.ObjectId#'
				   AND    ActionCode = '#actionCode#' 
				   AND    QuestionId = P.QuestionId) as Score,
				   
				  (SELECT QuestionMemo 
				   FROM   OrganizationObjectQuestion 
				   WHERE  ObjectId   = '#Object.ObjectId#'
				   AND    ActionCode = '#actionCode#' 
				   AND    QuestionId = P.QuestionId) as Memo
				
	    FROM       Ref_EntityDocumentQuestion P
	    WHERE      DocumentId = '#documentid#'	
	    ORDER BY   ListingOrder
    </cfquery>	
	
	<cfif content.recordcount gte "1">
		
		<tr><td height="4"</td></tr>
		<tr><td colspan="3" style="padding:3px" class="labellarge">#DocumentDescription#</td></tr>		
		<tr><td colspan="3" class="linedotted"></td></tr>
	
	</cfif>
	
	<!--- embedded trigger script : driven by Erin 10/3/2012 and diabled
	ajas _ProcessActionQuestionaireTrigger --->
					
	<input type="button" class="hide" id="button_#documentid#trigger" onclick="var process = 1;	
		 <cfloop query='content'>	
		 se = document.getElementById('process_#left(QuestionId,8)#').value;
		 if (se == '') { process = 0 };	 		 	  
		 </cfloop>			
		 if (process == 1) { try { methodquestionaire() } catch(e) {} }">		 
			
			
	<cfloop query="content">	
			
		<cfif entrymode eq "workflow">
		
			<cfset lkt = "savequestionaire('#object.Objectid#','#Questionaire.actioncode#','#questionid#','score_#left(QuestionId,8)#','score')">
			<cfset lkm = "savequestionaire('#object.Objectid#','#Questionaire.actioncode#','#questionid#','memo_#left(QuestionId,8)#','memo')">
			
		<cfelse>
		
		    <!--- script to detect and review the entries already made, we can tune 
			  this to assess the value entered as well --->
			
			<cfset lkt = "document.getElementById('process_#left(QuestionId,8)#').value='processed';document.getElementById('button_#documentid#trigger').click()">
			<cfset lkm = "">	
							
		</cfif>
		
		<input type="hidden" name="process_#left(QuestionId,8)#" id="process_#left(QuestionId,8)#" value="<cfif score neq "">processed</cfif>">

        <tr height="25"></tr>
        <tr height="50">
            <td  class="labelit" style="text-align: center;font-size: 18px;font-weight: 200;">#currentrow#. #QuestionLabel#</td>
        </tr>
        <tr height="50">
							
					
		<td width="15%" align="center" style="padding-right:20px" class="labelit">
		
			<cfif InputMode eq "YesNo">			
			
				<cfif entrymode eq "view">
				
					<cfswitch expression="#score#">
					
						<cfcase value="0">No</cfcase>
						<cfcase value="1">Yes</cfcase>
					
					</cfswitch>
					
				<cfelse>				
							
					<table cellspacing="0" cellpadding="0">
					<tr>	
						<td><input type="radio" class="radiol"
						      name="score_#left(QuestionId,8)#" 
							  id="score_#left(QuestionId,8)#"
						      onclick="#lkt#" 
							  value="1" <cfif score eq "1">checked</cfif>>	
						</td>
						<td style="padding-left:3px" class="labelmedium"><font color="green">Yes</font></td>
						
						<td style="padding-left:7px"><input type="radio" class="radiol"
						      name="score_#left(QuestionId,8)#" 
							  id="score_#left(QuestionId,8)#"
						      onclick="#lkt#" value="0" <cfif score eq "0">checked</cfif>></td>
						<td style="padding-left:3px" class="labelmedium"><font color="red">No</font></td>
					</tr>
					</table>
				
				</cfif>
				
			<cfelseif InputMode eq "YesNoNA">
			
				<cfif entrymode eq "view">
				
					<cfswitch expression="#score#">
					
						<cfcase value="0"><cf_tl id="No"></cfcase>
						<cfcase value="1"><cf_tl id="Yes"></cfcase>
						<cfcase value="9"><cf_tl id="N/A"></cfcase>
					
					</cfswitch>
					
				<cfelse>
			
					<table cellspacing="0" cellpadding="0">
					<tr>	
						<td><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>></td>
						<td style="padding-left:3px" class="labelmedium"><font color="green"><cf_tl id="Yes"></font></td>
						
						<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="0" <cfif score eq "0">checked</cfif>></td>
						<td style="padding-left:3px" class="labelmedium"><font color="red"><cf_tl id="No"></font></td>
						
						<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
						<td style="padding-left:3px" class="labelmedium"><font color="gray"><cf_tl id="N/A"></font></td>
					</tr>
					</table>	
				
				</cfif>
				
			<cfelse>
			
				<cfif entrymode eq "view">
				
					<table cellspacing="0" cellpadding="0">
							
					<tr>		
				
					<cfloop index="itm" from="1" to="#inputmode#">					    
							
						<td  class="labelit"><h3><cfif score eq itm><b></cfif>#itm#</h3></td>
						<td width="3"></td>							
					
					</cfloop>
					
					</tr>
					
					</table>
					
				<cfelse>
			
					<table cellspacing="0" cellpadding="0">
								
						<tr>			
						<cfloop index="itm" from="1" to="#inputmode#">					
						    
								<td style="padding-left:6px"><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								   onclick="#lkt#" 
								   value="#itm#" <cfif score eq "#itm#">checked</cfif>></td>
								<td style="padding-left:3px" class="labelmedium"><h3 class="lbl">#itm#</h3></td>
								<td width="3"></td>							
						
						</cfloop>
						 </tr>		
					
					</table>
				
				</cfif>
						
			</cfif>
		
		</td>
		
		<td class="hide" id="i#questionid#"></td>
		
		</tr>
		
		<cfif QuestionMemo neq "">		
            <tr height="40"></tr>
            <tr height="40"><td style="text-align: center;">#QuestionMemo# (Opcional)</td></tr>		
		</cfif>
		
		<cfif EnableInputMemo eq "1">
		
			<tr>
                <td style="text-align: center;">
                    
				
				<cfif entrymode eq "view">	
							
				    #Memo#
					 
				<cfelse>
				
				 <cfset text = replace(Memo,"<script","disable","all")>
				 <cfset text = replace(text,"<iframe","disable","all")>		
				
	   			 <textarea height="100" width="95%" color="ffffff" init="Yes" onchange="#lkm#"  name="memo_#left(QuestionId,8)#" 
					  id="memo_#left(QuestionId,8)#" toolbar="basic">#Memo#</textarea>				
								  
				</cfif>
				
				</td>
			</tr>
		
		</cfif>
				
		<cfif EnableInputAttachment eq "1">
		
			<tr><td></td>
			    <td colspan="1" class="labelit" style="padding-top:2px;padding-left:10px;padding-right:3px">
				
				<cfif entrymode eq "view">
				
					<cf_filelibraryN
						DocumentPath="Questionnaire"
						SubDirectory="#object.objectid#" 
						Filter = "#left(questionid,8)#"											
						box    = "box_#questionid#"
						Insert = "no"
						Remove = "no"
						LoadScript = "No"
						width  = "100%"									
						border = "1">	
				
				<cfelse>
					
					<cf_filelibraryN
						DocumentPath="Questionnaire"
						SubDirectory="#object.objectid#" 
						Filter = "#left(questionid,8)#"											
						box    = "box_#questionid#"
						Insert = "yes"
						Remove = "yes"
						LoadScript = "No"
						width  = "100%"									
						border = "1">	
					
				</cfif>				
				
				</td>
			</tr>
		
		</cfif>
		
		<cfif currentrow neq recordcount>
		
		<tr><td colspan="3" height="40"></td></tr>
        <tr><td colspan="3" class="linedotted" height="1"></td></tr>
				
		</cfif>
	
	</cfloop>	
	<tr height="50"></tr>	 
</cfoutput>
  
</table>
</div>