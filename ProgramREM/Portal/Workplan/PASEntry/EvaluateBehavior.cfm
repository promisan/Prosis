
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

<table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">

	<tr class="line fixrow">						
		<td width="100%" colspan="3" class="labelit">					
			<table>
			<tr>
				<td class="labelmedium" style="height:30px;font-size:20px;padding-left:6px">
				<h1 style="font-size:30px;padding:5px 15px 0;font-weight: 200;">
				<cf_tl id="Behavioral Appraisal"></h1></td>
			</tr>
			</table>	
							 
		</td>						 
	</tr>
			
	<tr><td style="padding-left:10px">
	
		<cfquery name="Class" 
		 datasource="appsEPAS" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		    SELECT *
		    FROM   Ref_BehaviorClass
		    WHERE Operational = '1' 
		</cfquery>			
		
		<cfoutput>
		<script language="JavaScript">
		
		function hl(obj,row,total) {
		
		    count = 1
			while (count <= total)
			{
			se = document.getElementById("b_"+obj+"_"+count)
			se.className = "regular"
			count++
			}
			
			se = document.getElementById("b_"+obj+"_"+row)
			se.className = "highlight2"
		}
		
		function twist(code) {
		
			se = document.getElementById(code)
			
			if (se.className == "regular"){
				se.className = "hide"
			} else {
				se.className = "regular"
			}
		
		}
		
		</script>
		
		</cfoutput>		
						
		<cfquery name="Default" 
		datasource="AppsEPAS"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
		    FROM  Ref_Score
			WHERE ClassScore = 'Behavior'
			AND   SelectDefault = 1 
		</cfquery>
					
			<table width="100%" class="formpadding">
				
				<cfoutput query="Class">
							
					<cfquery name="Score" 
						datasource="AppsEPAS"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   * 
						    FROM     Ref_Score
							WHERE    ClassScore = '#Code#'
							ORDER By ListingOrder 
					</cfquery>
					
					<cfquery name="Default" 
					datasource="AppsEPAS"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT * 
					    FROM   Ref_Score
						WHERE  ClassScore = '#Code#'
						AND    SelectDefault = 1 
					</cfquery>	
					
					<cfif Score.recordcount eq "0">
					
											
						<cfquery name="Score" 
							datasource="AppsEPAS"
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT    * 
							    FROM      Ref_Score
								WHERE     ClassScore = 'Default'
								ORDER By  ListingOrder 
						</cfquery>
						
						<cfquery name="Default" 
						datasource="AppsEPAS"
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT * 
						    FROM   Ref_Score
							WHERE  ClassScore = 'Default'
							AND    SelectDefault = 1 
						</cfquery>	
					
					</cfif>
					
				
					<tr class="line">
					  
					   <td width="90%">
					   	  
						   <table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
						   <tr>
						   <td width="40" align="center">
						   <img src="#SESSION.root#/Images/#InterfaceIcon#" alt="" border="0" align="absmiddle">
						   </td>						  
						   <td class="labelmedium" style="font-size:19px">#Description#</td>
						   <td></td>
						   </tr>
						   </table>
						   
					   </td>
					   
					   <td width="25" align="center"></td>
					   
					   <td width="200" align="right">
					   
					        <cfif currentrow eq "1">
					    	 <table width="100%" cellspacing="0" cellpadding="0">
							  <tr>
							  <cfloop query="score">
							      <td width="20%" align="center">
									  <table width="100%" cellspacing="0" cellpadding="0">
									  <tr><td width="100%" align="center">
									   <img src="#SESSION.root#/Images/#InterfaceIcon#" alt="#Description#" border="0" align="absmiddle">
									  </td>
									  </tr>
									  <tr><td width="100%" align="center" class="labelmedium"><cf_UIToolTip tooltip="#DescriptionMemo#">#Description#</cf_UIToolTip></td>
									  </tr>
									  </table>															  
								  </td>
							  </cfloop>
							  </tr>
						    </table>
					        </cfif>							
							
					   </td>
					  
					</tr>
																					   
					<cfquery name="Detail" 
						 datasource="appsEPAS" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 SELECT   C.*, 
						          R.*, 
								  P.Description as PriorityDescription
						 FROM     ContractBehavior C, 
						          Ref_Behavior R, 
								  Ref_Priority P 
						 WHERE    ContractId = '#URL.ContractId#'
						 AND      C.BehaviorCode = R.Code
						 AND      C.PriorityCode = P.Code
						 AND      R.BehaviorClass = '#Code#' 					         
						 ORDER BY R.ListingOrder 
					</cfquery>						
																															
					<cfloop query="Detail">
						  						  
							  <cfloop index="ev" list="#evlist#" delimiters=",">
							  
							     <cfset evid = evaluate("#ev#.EvaluationId")>
														
								 <cfquery name="Result" 
										datasource="AppsEPAS" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT  *
										FROM    ContractEvaluationBehavior
										WHERE   EvaluationId = '#evid#' 
										AND     BehaviorCode = '#Detail.BehaviorCode#' 
										AND     ContractId   = '#URL.ContractId#'
								 </cfquery>
										
								  <cfif Result.EvaluationScore eq "">
										 <cfset sc = "#Default.Code#">
								  <cfelse>
										 <cfset sc = "#Result.EvaluationScore#">
								  </cfif>		
																	
								<cfif ev eq "Evaluate">
								
								  <tr bgcolor="f2f2f2">
														
							    	<td width="100%" colspan="2" align="right">
									  
									  <table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
																	
										<tr>
										   <td width="50" align="right"><!--- #CurrentRow#.&nbsp; ---></td>
										   <cfif Param.HideBehaviorName eq "0">	
											   <td width="85%" style="cursor: pointer;padding-left:30px" class="labelit">#BehaviorMemo# <cfif BehaviorDescription neq "">#BehaviorDescription#</cfif></td>
											   <td width="10%" class="labelit"></td>
										   <cfelse>
											   <td width="10%" class="labelit"></td>	
										   </cfif>	
										   
										   <cfif Param.HidePriority eq "0">	
										   <td width="2%" class="labelit"><!---#PriorityDescription#---></td>
										   </cfif>
								 		</tr>										
										<tr><td></td><td colspan="3" class="hide labelit" id="#BehaviorCode#">#BehaviorMemo#</td></tr>
																																
									  </table>
									  
									  </td>
								  
								<cfelse>
								
									<tr>
							
								    	<td width="100%" colspan="2" align="right" class="labelit">									
										#officerFirstName# #OfficerLastName# : #dateformat(created, CLIENT.DateFormatShow)#
										</td>
																			
								</cfif>	    
																											
								<td rowspan="1" style="padding-right:5px">																																																	   
								  								 								   								   
								   <table width="200">								   
								    <tr bgcolor="E6E6E6">
									
								   	<cfset cde = BehaviorCode>									
																		
									<cfloop query="score">
																		
									   <cfif Sc eq Code>
									     <cfset cl = "highlight2">
										<cfelse>
										 <cfset cl = "regular">
										</cfif> 	
										
										<cfquery name="ScoreBehavior" 
										datasource="AppsEPAS" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT  *
											FROM    Ref_ScoreBehavior
											WHERE   Score    = '#code#' 
											AND     Behavior = '#cde#' 
										</cfquery>
																																
										<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") 
										    and ev eq "Evaluate" and mode eq "Evaluate" 
											and (role.recordcount gte "1" or session.acc eq "Administrator")>																																
																						
											<cf_UIToolTip tooltip="#DescriptionMemo#">
												<td width="20%" 
												name="b_#cde#" id="b_#cde#_#currentrow#" 
												align="center" 
												style="border: 0px solid ##DCDCDC;height:25px"
												class="#cl# labelit">
													<input type="radio" 
													       name="Behavior_Score_#cde#" 
														   value="#Code#" class="radiol"
													<cfif Sc eq "#Code#">checked</cfif>
													       onclick="hl('#cde#','#currentrow#','#Score.Recordcount#')">
														   
												</td>
											</cf_UIToolTip>
											
										<cfelse>
										
										  <cf_UIToolTip tooltip="#DescriptionMemo#">
											  <cfif Sc eq "#Code#">
											  <td width="20%" align="center" style="height:25px;border: 1px solid silver;background-color:white">
											   <img src="#SESSION.root#/Images/CheckMark.png" alt="#Code#" border="0" align="absmiddle" style="height:20px;">
											  </td>
											  <cfelse>
											  <td width="20%" align="center" style="height:25px;border: 1px solid silver;" height="20" width="25"></td>
											  </cfif>
										  </cf_UIToolTip>
										</cfif>										
										
									</cfloop>
								   </tr>
								   </table> 
									
								</td>			
														   
						   	  </TR>	
							
							  <cfif Mode eq "Evaluate">
							      <cfset cl = "hide">
							  <cfelse>
								  <cfset cl = "regular"> 
							  </cfif>
							  						  
							 <cfif Mode eq "Evaluate" and ev eq "Evaluate">
								 
								 <tr id="#Behaviorcode#" class="#cl#">
										<td colspan="3">				
											<table width="94%"
												   style="border: 1px solid ##e4e4e4;" 
												   cellspacing="0" 
												   cellpadding="0"
												   class="formpadding" 
												   align="center">
												   
											<tr><td class="labelit">#BehaviorMemo#</td></tr>
											</table>
											</td>
										</tr>
													
							     <tr><td colspan="2">
							
								    <table width="100%" align="center" class="formpadding">
									
										<cfif Param.HideComments eq "0">	
									
											<cfloop index="itm" list="1,2" delimiters=",">
											
												<cfset t = Evaluate("Result.EvaluationRemarks" & #itm#)>
												<cfif t neq "" or (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p")>
																							
													<tr>
													   
														<td style="min-width:40px" align="center">
														  <cfif itm eq "1">
														   <cf_UIToolTip tooltip="Negative Comments">
														   <img src="#SESSION.root#/Images/rating_min.png" alt="" border="0" align="absmiddle">
														   </cf_UIToolTip>
														  <cfelse>
														   <cf_UIToolTip tooltip="Positive Comments">
														   <img src="#SESSION.root#/Images/rating_pospos.png" alt="" border="0" align="absmiddle">
														   </cf_UIToolTip>
														  </cfif>
														</td>
														
														<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") and (role.recordcount gte "1" or session.acc eq "Administrator")>
														     <td width="80%" align="left" class="labelit">															
															 	<textarea style="padding:3px;font-size:13px;" onkeyup="return ismaxlength(this)" totlength="700" class="regular" cols="60" rows="1" name="Behavior_Remarks#itm#_#cde#" totlength="800" onkeyup="return ismaxlength(this)">#t#</textarea>
															 </td>
														<cfelse>
														     <td width="90%" style="padding:7px;background-color:ffffcf" class="labelit" align="left">#t#</td>
														</cfif>
														
													</tr>
												
												</cfif>
											
											</cfloop>
											
										</cfif>		
																																															
										<cfif Param.HideTraining eq "0">
										
										   <cfset task = cde>
										
											<cfquery name="Training" 
											datasource="AppsEPAS" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT  *
												FROM    ContractEvaluationBehavior
												WHERE   EvaluationId = '#Evaluate.EvaluationId#'
												AND     BehaviorCode   = '#Detail.BehaviorCode#'
												AND     ContractId   = '#URL.ContractId#'
												AND     TrainingReason is not NULL
											</cfquery>
																								
											<cfif (Evaluate.ActionStatus eq "0" or Evaluate.ActionStatus eq "0p") and (role.recordcount gte "1" or session.acc eq "Administrator")>
																  
												<tr>										
												    <td colspan="2" class="labelit">
													<cf_interface cde="TrainingHeader">
													<img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
													#Name#:
													<input type="checkbox" 
													         onclick="training('b#task#',this.checked)" 
															 name="Training_#task#" class="regularxl"
													value="1" <cfif #Training.Recordcount# neq "0">checked</cfif>>
													</td>
												</tr>
												
												<cfset Entry = "Edit">
																				
											<cfelse>
																									
											    <cfset Entry = "View">	
																								
											</cfif>	
												
											<cfif Training.Recordcount neq "0">
											  <cfset cl = "regular">
											<cfelse>  
											  <cfset cl = "hide">
											</cfif>  
																
											<tr id="b#task#" class="#cl#">
												<td colspan="2">
												<cfinclude template="TrainingEntry.cfm"></td>
											</tr>	
																				
										</cfif>	
								
								</table>
							
							</td></tr>
							
							<cfelse>
							
							<tr><td colspan="2">
							
								    <table width="100%" style="background-color:ffffcf" class="formpadding">
									
										<cfif Param.HideComments eq "0">	
									
											<cfloop index="itm" list="1,2" delimiters=",">
											
												<cfset t = Evaluate("Result.EvaluationRemarks" & #itm#)>
												
												<cfif t neq "" and Evaluate.ActionStatus gte "1">
																							
													<tr>
													   
														<td style="min-width:40px" align="center">
														  <cfif itm eq "1">
														   <cf_UIToolTip tooltip="Negative Comments">
														   <img src="#SESSION.root#/Images/rating_min.png" alt="" border="0" align="absmiddle">
														   </cf_UIToolTip>
														  <cfelse>
														   <cf_UIToolTip tooltip="Positive Comments">
														   <img src="#SESSION.root#/Images/rating_pospos.png" alt="" border="0" align="absmiddle">
														   </cf_UIToolTip>
														  </cfif>
														</td>														
														<td width="90%" class="labelit" align="left" style="font-size:14px;padding:15px;padding-right:30px">#t#</td>																												
													</tr>
												
												</cfif>
											
											</cfloop>
											
										</cfif>				
								
								</table>
							
							</td></tr>							
							
							</cfif>
												
					     </cfloop>
						 
					</cfloop> 
					 
				</cfoutput>	 
							
			</table>

	</td></tr>

</table>	  