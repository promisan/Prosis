
<!--- Query returning program parameters --->

<cfparam name="url.recordstatus" default="1">
<cfparam name="evlist" default="">

<cfquery name="Status" 
datasource="AppsEPAS"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Status
	WHERE  ClassStatus = 'Contract'
</cfquery>

<cfquery name="Score" 
datasource="AppsEPAS"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   * 
    FROM     Ref_Score
	WHERE    ClassScore = 'Activity'
	ORDER BY ListingOrder
</cfquery>

<cfquery name="Default" 
datasource="AppsEPAS"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM   Ref_Score
	WHERE  ClassScore = 'Activity'
	AND    SelectDefault = 1 
</cfquery>	




<!--- provision to add record --->
				
<cfquery name="getActivity" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT   *		
  FROM     ContractActivity 
  WHERE    ContractId       = '#URL.ContractID#'
  AND      RecordStatus     = '#url.recordstatus#'
  AND      ActivityIdParent is NULL
</cfquery>

<cfquery name="Role" 
	datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   ContractActor
		WHERE  Contractid     = '#URL.ContractId#' 
		AND    Role           = 'Evaluation'
		AND    PersonNo       = '#client.personNo#'
		AND    RoleFunction   = 'FirstOfficer'
		AND    ActionStatus   = '1'
</cfquery>

<cfif getActivity.recordcount eq "0">

     <cfquery name="InsertActivity" 
	     datasource="AppsEPAS" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO ContractActivity
		         ( ContractId,
				   ActivityDescription,
				   Reference,
				   RecordStatus,
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName)
		  SELECT  ContractId,
				   ActivityDescription,
				   Reference,
				   '#url.recordstatus#',
				   OfficerUserId,
				   OfficerLastName,
				   OfficerFirstName
		  FROM     ContractActivity
		  WHERE    ContractId = '#URL.ContractId#'
		  AND      RecordStatus = '1'			     
	  </cfquery>
  
 </cfif> 
 
 <cfset sc = Default.Code>

<cfoutput>

	<script language="JavaScript">
	
	function ht(obj,row) {
	
	    count = 1
		while (count <= #Score.recordcount#) {
		se = document.getElementById("b_"+obj+"_"+count)
		se.className = "regular"
		count++	}			
		se = document.getElementById("b_"+obj+"_"+row)
		se.className = "highlight2"
		
	}
			
	function training(itm,val) {
		se = document.getElementById(itm)
		if (val == true) { 
			se.className = "regular" 
		} else { 
			se.className = "hide" }
	}
	
	</script>
		
</cfoutput>		

<cfquery name="Default" 
datasource="AppsEPAS"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	    SELECT    * 
    	FROM      Ref_Score
		WHERE     ClassScore = 'Activity'
		AND       SelectDefault = 1 
</cfquery>

<cfquery name="SearchResult" 
    datasource="AppsEPAS" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT    *
	    FROM      ContractActivity
		WHERE     ContractId     = '#URL.ContractId#'
		AND	      RecordStatus   = '#url.recordstatus#'
		AND       ActivityIdParent is NULL
		AND       Operational = 1
		ORDER BY  Reference, ActivityId
</cfquery>

	<table width="100%" align="center">
				
		<tr><td width="100%">
							
		<table border="0" width="100%" class="formpadding">
						
			<cfoutput query="SearchResult">			
			
				<cfquery name="Result" 
				datasource="AppsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT  *
					FROM    ContractEvaluationActivity
					WHERE   EvaluationId = '#evid#'
					AND     ActivityId   = '#ActivityId#'							
				</cfquery>		
				
				<cfif Result.EvaluationScore eq "">												
					 <cfset sc = Default.Code>							   
				<cfelse>																												
				   <cfset sc = Result.EvaluationScore>							   
   			    </cfif>
											
				<cfif Mode eq "View">
							
					<tr class="line">
								
				     <td width="100%" colspan="2" align="left" style="padding-top:10px"> 				
					  	
						<table>
							<tr>
							<td class="labelmedium" style="height:50px;font-size:20px;padding-left:6px">
								<h1 style="font-size:30px;height:50px;padding:5px 15px 0;font-weight: 200;">
								<cf_tl id="Major assignments and objectives">							
								</h1>							
							</td>
							</tr>
						</table>						 
									
					 </td>		
								
					 <td style="min-width:200px;width:1%" align="right" valign="bottom">		
					 							
						<table style="width:100%">	
						
					  	  <tr>						  
						  <cfloop query="score">
						      <td width="25%" align="center">						  
								  <table width="100%" cellspacing="0" cellpadding="0">
								  <tr><td width="100%" align="center"><img src="#SESSION.root#/Images/#InterfaceIcon#" align="absmiddle"></td></tr>
								  <tr><td width="100%" align="center" class="labelmedium"><cf_UIToolTip tooltip="#DescriptionMemo#">#Description#</cf_UIToolTip></td>
								  </table>														  
							  </td>									  
						  </cfloop>							  
						  </tr>
						  
						</table>   						
										
					  </td>	
											  
				    </tr>
																						 
					<tr>
							  
					<td width="99%" colspan="2" style="background-color:f5f5f5;padding-top:2px;padding-left:45px;padding-right:20px">#ActivityDescription#</td>
							  
					<td style="min-width:200px;width:1%;padding-right:6px" align="right" valign="top">	
															  
						  <table style="width:100%;background-color:f5f5f5">	
														
							  <tr style="height:50px">		
							  								 
							   	<cfset ord = ActivityOrder>	
																													
								<cfloop query="score">								
																													
								   <cfif Sc eq Code>
								     <cfset cl = "highlight2">
									<cfelse>
									 <cfset cl = "regular">
									</cfif> 
									
									<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") and ev eq "Evaluate" and Mode eq "Evaluate">
								
									<td width="25%" class="#cl#" id="b_#ord#_#currentrow#"  align="center">
										<input type="radio" name="Activity_Score_#ord#" class="radiol" value="#Code#" 
										   <cfif Sc eq Code>checked</cfif> onclick="ht('#ord#','#currentrow#')">
									</td>	
									
									<cfelse>																		
																	
									  <cfif Sc eq Code>
									  <td width="25%" align="center" style="border:1px solid silver;">
									    <img src="#SESSION.root#/Images/checkmark.png" align="absmiddle">
									  </td>
									  <cfelse>								 
									  <td width="25%" align="center" style="background-color:e4e4e4;border:1px solid silver;" height="25" width="25"></td>
									  </cfif>
									</cfif>	
									
								</cfloop>
							   </tr>
							   
							</table>   
							  
						</td>
							  
					  </tr>
					  
					  <cfquery name="Detail" 
						datasource="AppsEPAS" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT   *
							FROM     ContractActivity CA LEFT OUTER JOIN Ref_Priority C ON CA.PriorityCode = C.Code  
							WHERE    CA.ContractId       = '#URL.ContractId#'
							AND      CA.ActivityId       = '#ActivityId#'												
							AND	     CA.RecordStatus     = '#url.recordstatus#'						 
							AND      CA.Operational = 1
							ORDER BY ActivityOrder					
						</cfquery>	
						
						<cfif detail.recordcount eq "1">	
						
						    <cfset evid = evaluate("#ev#.EvaluationId")>
						  						   					 			
							<cfquery name="Result" 
							datasource="AppsEPAS" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  *
								FROM    ContractEvaluationActivity
								WHERE   EvaluationId = '#evid#'
								AND     ActivityId   = '#ActivityId#'							
							</cfquery>
						
						    <cfset t = Evaluate("Result.EvaluationRemarks")>
							
							<cfif t neq "" and Evaluate.ActionStatus gte "1">
							
							<tr style="height:80px" class="labelmedium">																																						
							
							      <td width="100%" class="line" style="font-size:14px;background-color:ffffcf;padding:10px;padding-left:35px;padding-right:35px" 
								   colspan="2" >#t#</td>
																		
						    </tr>	
							
							</cfif>	
						
						</cfif>
							 
				</cfif>		
													   			
				<cfquery name="Detail" 
				datasource="AppsEPAS" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT   *
					FROM     ContractActivity CA LEFT OUTER JOIN Ref_Priority C ON CA.PriorityCode = C.Code  
					WHERE    CA.ContractId       = '#URL.ContractId#'
					
					<cfif Mode eq "View">
					AND      CA.ActivityIdParent = '#ActivityID#'					
					<cfelse>
					AND      CA.ActivityIdParent is NULL <!--- only for evaluation --->					
					</cfif>
					AND	     CA.RecordStatus     = '#url.recordstatus#'						 
					AND      CA.Operational = 1
					ORDER BY ActivityOrder					
				</cfquery>		
																												
				<cfif detail.recordcount gte "1">							
											
				    <tr class="line">						
						<td width="90%" colspan="3" class="labelit">						
						<table style="width:100%">
						<tr>
						<td class="labelmedium" style="height:30px;font-size:20px;padding-left:6px">
						<h1 style="font-size:30px;padding:5px 15px 0;font-weight: 200;">
						<cfif Mode eq "Evaluate">
						    <cf_tl id="Overall Appraisal">
						<cfelse>
						    <cf_tl id="Specific assignments and objectives">	
						</cfif>								
						</h1></td>
						</tr>
						</table>						 
						</td>													 
					</tr>						
												
				</cfif>								
						
				<cfloop query="Detail">										
				
				    <cfloop index="ev" list="#evlist#" delimiters=",">					
															
					       <cfset evid = evaluate("#ev#.EvaluationId")>						   
						 						  						   					 			
							<cfquery name="Result" 
							datasource="AppsEPAS" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  *
								FROM    ContractEvaluationActivity
								WHERE   EvaluationId = '#evid#'
								AND     ActivityId   = '#ActivityId#'							
							</cfquery>
																																											
							<cfif ev eq "Evaluate">
							
								<tr>
								
								<td width="98%" colspan="2">
																  
								  <table width="100%" align="left">
									  <tr>
										<td width="10" align="right" valign="top" style="padding-right:4px"><!--- <img src="#SESSION.root#/Images/join.gif">---></td>
										<td class="labelit" style="width:100%;padding:10px;border:0px solid silver;padding-left:30px">#Reference# #ActivityDescription#</td>
										<td valign="top" align="right" style="width:100px;padding-right:5px" class="labelit"><!--- #Description# ---></td>
									  </tr>
								  </table>
								  
								 </td> 
							  
							<cfelse>
							
								<tr>							
								<td width="98%" colspan="2" align="right" class="labelit" style="color:##808080;pdding-right:5px">							
								   #officerFirstName# #OfficerLastName# : #dateformat(created, CLIENT.DateFormatShow)#		
								   </td>						
								   
							</cfif>	    
																				
							<cfif Result.EvaluationScore eq "">												
							   <cfset sc = Default.Code>							   
							<cfelse>																					
							   <cfset sc = Result.EvaluationScore>							   
							</cfif>
							
							<td style="min-width:200px;padding-top:5px;width:1%;border:0px solid silver" align="right" valign="top">		
							
									<table style="width:100%">	
																	 
								  	  <tr>									  
									  									  
									  <cfloop query="score">
									      <td width="25%" align="center">
											  <table width="100%" cellspacing="0" cellpadding="0">
											  <tr><td width="100%" align="center"><img src="#SESSION.root#/Images/#InterfaceIcon#" align="absmiddle"></td></tr>
											  <tr><td width="100%" align="center" class="labelmedium"><cf_UIToolTip tooltip="#DescriptionMemo#">#Description#</cf_UIToolTip></td>
											  </table>														  
										  </td>									  
									  </cfloop>
													  
									  </tr>
									 	
									  <tr style="background-color:f5f5f5;height:55px;padding-left:20px;padding-right:20px">	
									  																		  								 
									   	<cfset ord = ActivityOrder>		
																																					
										<cfloop query="score">
										
										   <cfif Sc eq Code>
										     <cfset cl = "highlight2">
											<cfelse>
											 <cfset cl = "regular">
											</cfif> 
																						
											<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") and ev eq "Evaluate" and Mode eq "Evaluate" and (role.recordcount gte "1" or session.acc eq "administrator")>
										
											<td width="25%" class="#cl#" id="b_#ord#_#currentrow#"  align="center" style="background-color:e4e4e4;padding-top:2px;">
												<input type="radio" name="Activity_Score_#ord#" class="radiol" style="height:25px;width:25px" value="#Code#" 
												   <cfif Sc eq Code>checked</cfif> onclick="ht('#ord#','#currentrow#')">
											</td>	
											
											<cfelse>
											
											  <cfif Sc eq Code>
											  <td width="25%" align="center" style="border:1px solid silver;">
											   <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/CheckMark.png" alt="#Code#" border="0" align="absmiddle">
											  </td>
											  <cfelse>
											  <td width="25%" align="center" style="background-color:e4e4e4;border:1px solid silver;" height="25" width="25"></td>
											  </cfif>
											</cfif>	
											
										</cfloop>
									   </tr>
									</table>
														
							</td>
								
							</tr>
							
							<tr class="hide">
							
						     <td width="100%" colspan="4" align="left" style="padding-top:10px"> 				
							  	
								<table width="100%">
									<tr class="line">
									<td class="labelmedium" style="height:40px;font-size:20px;padding-left:6px">
										<h1 style="font-size:30px;height:40px;padding:5px 15px 0;font-weight: 200;">
										<cf_tl id="Strengths and Weaknesses">
										</h1>
									</td>
									</tr>
									
								</table>						 
											
							 </td>			
							 
							</tr>
																				
							<tr><td colspan="3">
																																			
								    <table width="95%" align="center" class="formpadding">
									
									<cfloop index="itm" list="1,2" delimiters=",">
									
									<cfset t = Evaluate("Result.EvaluationRemarks" & #itm#)>
									
									<cfif t neq "" or (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p")>
												
										<tr class="hide">
											<td width="120" style="padding-left:30px;padding-right:4px">
											  <cfif itm eq "1">
											  <img src="#SESSION.root#/Images/rating_min.png" alt="" border="0" align="absmiddle">
											  <cfelse>
											   <img src="#SESSION.root#/Images/rating_pospos.png" alt="" border="0" align="absmiddle">
											  </cfif>
											</td>
											<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") and ev eq "Evaluate" and Mode eq "Evaluate" and role.recordcount gte "1">
											     <td width="99%" align="left" class="labelit">												 
													<textarea class="regular" style="border:1px solid silver;padding:3px;font-size:13px;width:98%" rows="3" name="Activity_Remarks#itm#_#ord#">#t#</textarea>
												 </td>
											<cfelse>
											      <td width="80%" align="left" class="labelit">#t#</td>
											</cfif>
											
										</tr>
									
									</cfif>
																											
									</cfloop>
									
									<cfif Param.HideTraining eq "0">
									
									   <cfset task = "#ord#">
									
										<cfquery name="Training" 
										datasource="AppsEPAS" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT  *
											FROM    ContractEvaluationActivity
											WHERE   EvaluationId = '#Evaluate.EvaluationId#'
											AND     ActivityId   = '#Detail.ActivityId#'
											AND     ContractId   = '#URL.ContractId#'
											AND     TrainingReason is not NULL
										</cfquery>
															  
											<tr><td colspan="2" class="labelit">
												<cf_interface cde="TrainingHeader">
												<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
												#Name#:
												<input type="checkbox" 
												         onclick="training('b#task#',this.checked)" 
														 name="Training_#task#" 
												value="1" <cfif Training.Recordcount neq "0">checked</cfif>>
												</td>
											</tr>
											
											<cfif Training.Recordcount neq "0">
											  <cfset cl = "regular">
											<cfelse>  
											  <cfset cl = "hide">
											</cfif>  
															
											<tr id="b#task#" class="#cl# labelit">
												<td colspan="2"><cfinclude template="TrainingEntry.cfm"></td>
											</tr>	
																			
									</cfif>	
														
									</table>
								
								</td>
							</tr>							

							<tr>
							
						     <td width="100%" colspan="2" align="left" style="padding-top:10px"> 				
							  	
								<table>
									<tr class="line">
									<td class="labelmedium" style="height:50px;font-size:20px;padding-left:6px">
										<h1 style="font-size:30px;height:40px;padding:5px 15px 0;font-weight: 200;">
										<cf_tl id="Overall comments">
										</h1>
									</td>
									</tr>
									<tr class="line" ><td class="labelmedium" style="font-weight:342;color:gray;font-size:12px;padding:4px;padding-left:20px">Comments should be specific as possible. They should also provide additional information on points that merit particular attention, e.g. responsibility
									beyond those usually performed at the staff member's level, or lack of progress after performance problems had been identified and an improvement plan put into place.
									Specific explanations are required for "Above" and "Below" expectation rattings in both individual appraisal and overall appraisal.</td></tr>
								</table>						 
											
							 </td>			
							 
							</tr>								
							
							<cfset t = Evaluate("Result.EvaluationRemarks")>
							
							<tr style="height:80px" class="line">							
																																
							<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") and ev eq "Evaluate" and Mode eq "Evaluate" and (role.recordcount gte "1" or session.acc eq "Administrator")>
							     <td width="100%" align="left" colspan="2" style="padding-left:20px">								 
									<textarea class="regular" 
									style="border:1px solid silver;padding:5px;font-size:14px;width:98%" rows="10" name="Activity_Remarks_#ord#">#t#</textarea>
								 </td>
							<cfelse>
							      <td width="100%" style="background-color:ffffcf;padding-left:20px;padding:15px;font-size:14px" 
								   colspan="2" class="labelit">#t#</td>
							</cfif>
											
						    </tr>															
																
					</cfloop>					
													
					<cfquery name="Output" 
					datasource="AppsEPAS" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    *
						FROM      ContractActivityOutput O, Ref_OutputClass S
						WHERE     O.ActivityId = '#Detail.ActivityID#'
						 AND      O.ContractId = '#URL.ContractId#'
						 AND      (O.RecordStatus <> 9 OR O.RecordStatus IS NULL)
						 AND      S.Code = O.OutputClass
						 AND      OutputDescription != ''
						 ORDER BY O.OutputClass
					</cfquery>
													
					<cfif Output.recordcount neq "0">
					
						<tr><td height="1" colspan="3" bgcolor="white" style="border:0px solid silver">
						
						<table width="94%" align="center" bgcolor="ffffff" class="formpadding">
					
						    <cfloop query="Output">
							
							<tr bgcolor="ffffff">			 
							  <td width="120"><b>#Description#:</td>
							  <td>#OutputDescription#</td>
							</tr>  
						  	  
						    </cfloop> 
						
						</table>
						
						</td></tr>
					
					<tr><td height="1"></td></tr>
					
					</cfif>
							  
				</cfloop>
										
		</cfoutput>
		
		</td></tr>
					
		</table>
		
    </td></tr>
    </table>
	

