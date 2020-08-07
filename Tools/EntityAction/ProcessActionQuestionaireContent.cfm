
<table style="width:95%" align="center">

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
		<tr class="line" ><td colspan="3" style="padding:3px;font-size:20px;" class="labelmedium">#DocumentDescription# <span style="font-size:10px"><cfif entrymode eq "workflow">Attention: Edits are automatically saved</cfif></span></td></tr>		
			
	</cfif>
					
	<cfloop query="content">	
					
		<cfif entrymode eq "workflow">
		
			<cfset lkt = "savequestionaire('#object.Objectid#','#Questionaire.actioncode#','#questionid#','score_#left(QuestionId,8)#','score')">
			<cfset lkm = "savequestionaire('#object.Objectid#','#Questionaire.actioncode#','#questionid#','memo_#left(QuestionId,8)#','memo')">
			
		<cfelse>
		
		    <!--- script to detect and review the entries already made, we can tune this to assess the value entered as well --->
			
			<cfset lkt = "document.getElementById('process_#left(QuestionId,8)#').value='processed';document.getElementById('button_#documentid#trigger').click()">
			<cfset lkm = "">	
							
		</cfif>
		
		<input type="hidden" name="process_#left(QuestionId,8)#" id="process_#left(QuestionId,8)#" value="<cfif score neq "">processed</cfif>">

        <tr>       
	    <td valign="top" class="labelmedium" style="padding-top:3px;height:35px;font-size: 15px;font-weight:400;padding-left:4px">#currentrow#.</td>
		<td><table style="width:90%">
				<tr><td class="labelmedium" style="font-size: 18px;padding-left:4px">#QuestionLabel#</td></tr>
				<cfif questionmemo neq "">				
				<tr><td class="labelmedium" style="color:white;background-color:400080;font-size: 13px;padding-left:7px">#QuestionMemo#</td></tr>		
				</cfif>
			</table>
		</td>		
				
		<td align="right" valign="top" style="padding-top:5px;height:35px;font-size: 18px;padding-left:4px" class="labelmedium">
		
			<table cellspacing="0" cellpadding="0">
			<tr class="line"><td style="height:30px">
		
					<table>
					<tr>	
				
					<cfif InputMode eq "YesNo">			
					
						<cfif entrymode eq "view">
						
							<cfswitch expression="#score#">
							
								<td style="padding-left:3px;font-size: 15px" class="labelmedium">
								<cfcase value="9">No</cfcase>
								<cfcase value="1">Yes</cfcase>
								</td>
							
							</cfswitch>
							
						<cfelse>				
								
								<td><input type="radio" class="radiol"
								      name="score_#left(QuestionId,8)#" 
									  id="score_#left(QuestionId,8)#" onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>>	
								</td>
								<td style="padding-left:3px;font-size: 15px" class="labelmedium">Yes</td>
								
								<td style="padding-left:7px"><input type="radio" class="radiol"
								      name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#" onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
								<td style="padding-left:3px;font-size: 15px" class="labelmedium">No</td>					
						
						</cfif>
						
					<cfelseif InputMode eq "YesNoNA">
					
						<cfif entrymode eq "view">
						
							<cfswitch expression="#score#">
							
								<td style="padding-left:3px;font-size: 15px;" class="labelmedium">
								 <cfcase value="9"><cf_tl id="No"></cfcase>
								 <cfcase value="1"><cf_tl id="Yes"></cfcase>
								 <cfcase value="0"><cf_tl id="N/A"></cfcase>
								</td>
							
							</cfswitch>
							
						<cfelse>
										
								<td><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								    onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>></td>
								<td style="padding-top:3px;padding-left:3px;font-size: 15px" class="labelmedium"><cf_tl id="Yes"></td>
								
								<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								    onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
								<td style="padding-top:3px;padding-left:3px;font-size: 15px" class="labelmedium"><cf_tl id="No"></td>
								
								<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								    onclick="#lkt#" value="0" <cfif score eq "0">checked</cfif>></td>
								<td style="padding-top:3px;padding-left:3px;font-size: 15px" class="labelmedium"><font color="gray"><cf_tl id="N/A"></font></td>
											
						</cfif>
						
					<cfelseif InputMode eq "YesNoPA">
					
						<cfif entrymode eq "view">
						
							<cfswitch expression="#score#">
							
								<td style="padding-left:3px;font-size: 15px;" class="labelmedium">
								<cfcase value="9"><cf_tl id="No"></cfcase>
								<cfcase value="1"><cf_tl id="Yes"></cfcase>
								<cfcase value="5"><cf_tl id="Partly"></cfcase>
								</td>
							
							</cfswitch>
							
						<cfelse>
										
								<td><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								    onclick="#lkt#" value="1" <cfif score eq "1">checked</cfif>></td>
								<td style="padding-top:3px;padding-left:3px;font-size:15px" class="labelmedium"><cf_tl id="Yes"></td>
								
								<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								    onclick="#lkt#" value="9" <cfif score eq "9">checked</cfif>></td>
								<td style="padding-top:3px;padding-left:3px;font-size:15px" class="labelmedium"><cf_tl id="No"></td>
								
								<td style="padding-left:9px"><input class="radiol" type="radio" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
								    onclick="#lkt#" value="5" <cfif score eq "5">checked</cfif>></td>
								<td style="padding-top:3px;padding-left:3px;font-size:15px" class="labelmedium"><font color="gray"><cf_tl id="Partly"></font></td>
											
						</cfif>					
									
					<cfelse>
					
						<cfset arr = listToArray(inputmodestringlist)>	
					
						<cfif entrymode eq "view">
											
							<cfloop index="itm" from="1" to="#inputmode#">					    
									
								<td style="padding-left:3px;font-size: 18px;font-weight: 300;" class="labelmedium">
								<cfif score eq itm><b></cfif>						
								<cfif arr[itm] neq "">#arr[itm]#<cfelse>#itm#</cfif>						
								</td>
								<td width="3"></td>							
							
							</cfloop>
							
						<cfelse>
												
								<cfloop index="itm" from="1" to="#inputmode#">					
								    
									<td style="padding-left:6px"><input type="radio" class="radiol" name="score_#left(QuestionId,8)#" id="score_#left(QuestionId,8)#"
									   onclick="#lkt#" 
									   value="#itm#" <cfif score eq itm>checked</cfif>></td>
									<td style="padding-left:3px;font-size: 17px;font-weight:350;" class="labelmedium"><cfif arr[itm] neq "">#arr[itm]#<cfelse>#itm#</cfif>	</td>
									<td width="3"></td>
															
								</cfloop>
												
						</cfif>
								
					</cfif>
							
					</tr>
					
					</table>
					
				</td>
				</tr>	
								
				<tr><td align="center" style="padding-left:3px;font-size: 15px;font-weight:350;" id="i#questionid#"></td></tr>
				
				</table>
		
		</td>
						
		</tr>
					
		<cfif EnableInputMemo gte "1">
		
			<tr>
			    <td></td>
                <td colspan="2" align="right" style="padding-right:10px;padding-left:5px">                    
				
				<cfif entrymode eq "view">#Memo#<cfelse>
				
				 <cfset text = replace(Memo,"<script","disable","all")>
				 <cfset text = replace(text,"<iframe","disable","all")>		
								
	   			 <cf_textarea style="height:50px;min-height:40px;" height="80" color="ffffff" toolbar="Mini" init="Yes"
				   onchange="#lkm#" name="memo_#left(QuestionId,8)#" id="memo_#left(QuestionId,8)#">#Memo#</cf_textarea>				
								  
				</cfif>
				
				</td>
			</tr>
		
		</cfif>
		
		<cfif EnableInputAttachment eq "1">
		
			<tr>
			    <td></td>
			    <td colspan="2" style="padding-top:2px;padding-left:0px;padding-right:13px;border-top:1px solid silver">
				
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
	 
</cfoutput>

 <tr>
		 <td colspan="3" align="right" height="25" style="padding-top:3px;padding-right:20px">						 					 
										   
				   <cfset nextbox = boxno+1>
					 <cfoutput>			   					   					   					   					 		 
					    <input type = "button" 
						class       = "button10g" 
						style       = "width:210px;height:29px;font-size:14px;"						
						value       = "Next" 
						onclick     = "document.getElementById('menu#nextbox#').click()">
					</cfoutput>  				
										
		 </td>
	 </tr>
  
</table>
