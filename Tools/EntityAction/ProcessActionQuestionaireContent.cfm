
<table style="width:95%" align="center">

<cfif entrymode eq "workflow">

	<tr class="hide"><td colspan="3" id="processquestion"></td></tr>
	<tr><td style="padding-top:4px" class="labelmedium" align="center" height="24" colspan="3">Attention: Edits are automatically saved.</font></td></tr>
	
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
		<tr class="line" ><td colspan="3" style="padding:3px;font-size:20px;font-weight:300" class="labelmedium">#DocumentDescription#</td></tr>		
			
	</cfif>
	
	<tr><td style="height:5px"></td></tr>
				
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

        <tr>       
	    <td class="labelmedium" style="height:45px;font-size: 18px;font-weight: 300;padding-left:4px">#currentrow#.</td>
		<td>
		<table>
		<tr><td class="labelmedium" style="font-size: 18px;font-weight:400;padding-left:4px">#QuestionLabel#</td></tr>
		<tr><td class="labelmedium" style="font-size: 13px;font-weight:300;padding-left:7px">#QuestionMemo#</td></tr>		
		</table>
		</td>				
		<td align="right" style="height:45px;font-size: 18px;font-weight: 300;padding-left:4px" class="labelmedium">
		
			<cfif InputMode eq "YesNo">			
			
				<cfif entrymode eq "view">
				
					<cfswitch expression="#score#">
					
						<cfcase value="9">No</cfcase>
						<cfcase value="1">Yes</cfcase>
					
					</cfswitch>
					
				<cfelse>				
							
					<table>
					<tr>	
						<td><input type="radio" class="radiol"
						      name="score_#left(QuestionId,8)#" 
							  id="score_#left(QuestionId,8)#" onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>>	
						</td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium">Yes</td>
						
						<td style="padding-left:7px"><input type="radio" class="radiol"
						      name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#" onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium">No</td>
					</tr>
					</table>
				
				</cfif>
				
			<cfelseif InputMode eq "YesNoNA">
			
				<cfif entrymode eq "view">
				
					<cfswitch expression="#score#">
					
						<cfcase value="9"><cf_tl id="No"></cfcase>
						<cfcase value="1"><cf_tl id="Yes"></cfcase>
						<cfcase value="0"><cf_tl id="N/A"></cfcase>
					
					</cfswitch>
					
				<cfelse>
			
					<table cellspacing="0" cellpadding="0">
					<tr>	
						<td><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><cf_tl id="Yes"></td>
						
						<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><cf_tl id="No"></td>
						
						<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="0" <cfif score eq "0">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><font color="gray"><cf_tl id="N/A"></font></td>
					</tr>
					</table>	
				
				</cfif>
				
			<cfelseif InputMode eq "YesNoPA">
			
				<cfif entrymode eq "view">
				
					<cfswitch expression="#score#">
					
						<cfcase value="9"><cf_tl id="No"></cfcase>
						<cfcase value="1"><cf_tl id="Yes"></cfcase>
						<cfcase value="5"><cf_tl id="Partly"></cfcase>
					
					</cfswitch>
					
				<cfelse>
			
					<table cellspacing="0" cellpadding="0">
					<tr>	
						<td><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><cf_tl id="Yes"></td>
						
						<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><cf_tl id="No"></td>
						
						<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
						    onclick="#lkt#" value="5" <cfif score eq "5">checked</cfif>></td>
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><font color="gray"><cf_tl id="Partly"></font></td>
					</tr>
					</table>	
				
				</cfif>					
							
			<cfelse>
			
				<cfif entrymode eq "view">
				
					<table cellspacing="0" cellpadding="0">
							
					<tr>		
				
					<cfloop index="itm" from="1" to="#inputmode#">					    
							
						<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium"><cfif score eq itm><b></cfif>#itm#</td>
						<td width="3"></td>							
					
					</cfloop>
					
					</tr>
					
					</table>
					
				<cfelse>
			
					<table>
								
						<tr>			
						<cfloop index="itm" from="1" to="#inputmode#">					
						    
							<td style="padding-left:6px"><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
							   onclick="#lkt#" 
							   value="#itm#" <cfif score eq "#itm#">checked</cfif>></td>
							<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium">#itm#</td>
							<td width="3"></td>
													
						</cfloop>
						 </tr>		
					
					</table>
				
				</cfif>
						
			</cfif>
		
		</td>
		
		<td class="hide" id="i#questionid#"></td>
		
		</tr>
					
		<cfif EnableInputMemo gte "1">
		
			<tr>
                <td colspan="3" align="right" style="padding-right:10px;padding-left:10px">                    
				
				<cfif entrymode eq "view">#Memo#<cfelse>
				
				 <cfset text = replace(Memo,"<script","disable","all")>
				 <cfset text = replace(text,"<iframe","disable","all")>		
								
	   			 <cf_textarea style="height:50px;width:1800px;min-height:40px;padding:3px;font-size:15px;" height="80" color="ffffff" toolbar="Mini" init="Yes"
				   onchange="#lkm#" name="memo_#left(QuestionId,8)#" id="memo_#left(QuestionId,8)#">#Memo#</cf_textarea>				
								  
				</cfif>
				
				</td>
			</tr>
		
		</cfif>
		
		<cfif EnableInputAttachment eq "1">
		
			<tr>
			    <td colspan="3" style="padding-top:2px;padding-left:10px;padding-right:13px">
				
				<cfif entrymode eq "view">
				
					<cf_filelibraryN
						DocumentPath   = "Questionnaire"
						SubDirectory   = "#object.objectid#" 
						Filter         = "#left(questionid,8)#"											
						box            = "box_#questionid#"
						Insert         = "no"
						Remove         = "no"
						LoadScript     = "No"
						width          = "100%"									
						border         = "1">	
				
				<cfelse>
					
					<cf_filelibraryN
						DocumentPath   = "Questionnaire"
						SubDirectory   = "#object.objectid#" 
						Filter         = "#left(questionid,8)#"											
						box            = "box_#questionid#"
						Insert         = "yes"
						Remove         = "yes"
						LoadScript     = "No"
						width          = "100%"									
						border         = "1">	
					
				</cfif>				
				
				</td>
			</tr>
		
		</cfif>
		
		<cfif currentrow neq recordcount>				
	        <tr><td colspan="3" class="line" height="1"></td></tr>				
		</cfif>
	
	</cfloop>	
	<tr height="50"></tr>	 
</cfoutput>
  
</table>
