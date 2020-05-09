<cfquery name="Questionaire" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT     D.DocumentId, 
	           D.DocumentCode, 
			   D.DocumentDescription,
			   A.ActionCode
    FROM       Ref_EntityActionDocument A INNER JOIN
               Ref_EntityDocument D ON A.DocumentId = D.DocumentId
    WHERE      A.ActionCode   = '#url.actioncode#' 
	AND        D.DocumentType = 'Question'
	<!--- enabled for this workflow --->
	AND        D.DocumentId IN (SELECT DocumentId
	                           FROM   Ref_EntityActionPublishDocument 
							   WHERE  ActionPublishNo = '#url.ActionPublishNo#' 
							   AND    ActionCode = '#url.actioncode#' 
							   AND    Operational = 1)
    ORDER BY   D.DocumentOrder 
</cfquery>	


<table width="99%" cellspacing="0" cellpadding="0" align="center">

<cfoutput query="Questionaire">
	
	<cfquery name="Content" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT     *,
		
		          (SELECT QuestionScore 
				   FROM   OrganizationObjectQuestion 
				   WHERE  ObjectId   = '#url.ObjectId#'
				   AND    ActionCode = '#actionCode#' 
				   AND    QuestionId = P.QuestionId) as QuestionScore,
				   
				  (SELECT QuestionMemo 
				   FROM   OrganizationObjectQuestion 
				   WHERE  ObjectId   = '#url.ObjectId#'
				   AND    ActionCode = '#actionCode#' 
				   AND    QuestionId = P.QuestionId) as Memo
				
	    FROM       Ref_EntityDocumentQuestion P
	    WHERE      DocumentId = '#documentid#'	
	    ORDER BY   ListingOrder
    </cfquery>	
	
	<cfif content.recordcount gte "1">
		
		<tr><td height="4"</td></tr>
		<tr><td colspan="3" style="padding-left:10px" class="labellarge">#DocumentDescription#</td></tr>		
		<tr><td colspan="3" class="linedotted"></td></tr>
	
	</cfif>
			
	<cfloop query="content">	
				
    	<tr>
		<td style="padding-left:20px" width="5%" class="labelit">#currentrow#.</td>					
		<td width="80%" style="padding-left:10px" class="labelmedium">#QuestionLabel#</font></td>				
		<td width="15%" align="right" style="padding-right:20px" class="labelit">
						
			<table cellspacing="0" cellpadding="0">
					
			<tr>	
			
			<td>	
		
		      <cfif InputMode eq "YesNo">			
											
					<cfswitch expression="#score#">
					
						<cfcase value="0">No</cfcase>
						<cfcase value="1">Yes</cfcase>
					
					</cfswitch>						
				
				<cfelseif InputMode eq "YesNoNA">			
				
					<cfswitch expression="#score#">
					
						<cfcase value="0"><cf_tl id="No"></cfcase>
						<cfcase value="1"><cf_tl id="Yes"></cfcase>
						<cfcase value="9"><cf_tl id="N/A"></cfcase>
					
					</cfswitch>		
					
				<cfelseif InputMode eq "YesNoPA">			
				
					<cfswitch expression="#questionscore#">
					
						<cfcase value="0"><cf_tl id="No"></cfcase>
						<cfcase value="1"><cf_tl id="Yes"></cfcase>
						<cfcase value="9"><cf_tl id="Partly"></cfcase>
					
					</cfswitch>					
				
				<cfelse>
				
					<cfset arr = listToArray(inputmodestringlist)>	
					
					<cfloop index="itm" from="1" to="#inputmode#">					    
							
						<cfif questionscore eq itm><cfif arr[itm] neq "">#arr[itm]#<cfelse>#itm#</cfif></cfif>											
					
					</cfloop>
						
				
				</cfif>
				
			</td>	
			
			</tr>
			
			</table>					
				
		</td>
				
		</tr>
		
		<cfif QuestionMemo neq "">		
			<tr><td></td><td class="labelit" style="padding-left:10px"><font color="808080">#QuestionMemo#</td></tr>		
		</cfif>
		
		<cfif EnableInputMemo eq "1">
		
			<tr><td></td>
			    <td colspan="2" class="labelmedium" style="padding-top:2px;padding-right:10px;padding-left:10px">
															
				     <font color="808080">#Memo#</font>									 
								
				</td>
			</tr>
		
		</cfif>
				
		<cfif EnableInputAttachment eq "1">
		
			<tr><td></td>
			    <td colspan="1" class="labelit" style="padding-top:2px;padding-left:10px;padding-right:3px">
												
					<cf_filelibraryN
						DocumentPath="Questionnaire"
						SubDirectory="#url.objectid#" 
						Filter = "#left(questionid,8)#"											
						box    = "box_#questionid#"
						Insert = "no"
						Remove = "no"
						LoadScript = "No"
						width  = "100%"									
						border = "1">				
				
				</td>
			</tr>
		
		</cfif>
					
	</cfloop>	
		 
</cfoutput>
  
</table>