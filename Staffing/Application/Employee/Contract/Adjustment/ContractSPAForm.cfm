<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<cf_actionListingScript>
<cf_FileLibraryScript>
<cf_calendarscript>

<cfparam name="url.action" default="0">
<cfparam name="url.mycl"  default="0">

<cfif URL.refer eq "workflow">
	<cfset url.action=1>	
</cfif>

<cfoutput>
	
	<cfquery name="SPA" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   PersonContractAdjustment
			WHERE  PostAdjustmentId = '#url.postadjustmentid#' 
			-- AND    ActionStatus != '9'
	</cfquery>
	
	<!--- check for active workflow --->  
	<cf_wfActive entitycode="PersonSPA" objectkeyvalue4="#url.postadjustmentid#">	
	
	<cfif (SPA.ActionStatus eq "1" and wfStatus eq "Open")   <!--- document is still pending completion in the wf processing --->
	       or url.action eq "1"    <!---access through PA screen --->
		   or url.mycl eq "1">     <!---access through wf --->
		  <cfset mode = "view">
	<cfelse>
		  <cfset mode = "edit">
		  <!--- any change will result in a new record --->
	</cfif>
	
	<cfif SPA.recordcount eq "0">
		<cfset lbl = "Grant Special Post Allowance (SPA)">
	<cfelse>
		<cfset lbl = "Amend Special Post Allowance (SPA)">	
	</cfif>
	
	<cfif url.action eq "1">
		<cfset html = "No">
	<cfelse>
		<cfset html = "No">
	</cfif>
		
	<cf_screentop height="100%" jquery="Yes" html="#html#" scroll="No" label="#lbl#" banner="gray" layout="webapp" user="No">	
	
	<cfif SPA.Recordcount eq "1">
	
	    <!--- -------------------------------- --->
		<!--- --- record exists => update ---- --->
		<!--- -------------------------------- --->
	
		<cfquery name="Contract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   PersonContract
				WHERE  ContractId = '#SPA.contractid#'
		</cfquery>
		
		<cfset contractid = spa.contractid>
	
	<cfelse>
	
		<!--- -------------------------------- --->
		<!--- ---------- new record ---------- --->
		<!--- -------------------------------- --->
			
		<cfquery name="Contract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM   PersonContract
				WHERE  ContractId = '#url.contractid#' 
		</cfquery>
		
		<cfset contractid = url.contractid>
	
	</cfif>
	
	<cfparam name="url.spabox" default="">	
	
	<script>
	
	    <!--- validate the regular form --->
		
	    function validateform(frm,act) {	
		    	
		    try {			    
			
				document.getElementById(frm).onsubmit()
			
				if( _CF_error_messages.length == 0 ) {	    
		    	    <!--- [it passed Passed the CFFORM JS validation, now run a Ajax script to save] --->
					ptoken.navigate('ContractSPASubmit.cfm?action='+act+'&contractid=#contractid#&postadjustmentid=#url.postadjustmentid#&spabox=#url.spabox#','spasave','','','POST',frm)
				}   
			
			} catch(e) {		
			    <!--- [it passed Passed the CFFORM JS validation, now run a Ajax script to save] --->
				ptoken.navigate('ContractSPASubmit.cfm?action='+act+'&contractid=#contractid#&postadjustmentid=#postadjustmentid#&spabox=#url.spabox#','spasave','','','POST',frm)
			}
		 
		}
	
	</script>
	
</cfoutput>

<cfquery name="CheckMission" 
	 datasource="AppsEmployee"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     Organization.dbo.Ref_EntityMission 
			 WHERE    EntityCode     = 'PersonSPA'  
			 AND      Mission        = '#Contract.Mission#' 
</cfquery>
			  
<cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.recordcount eq "0">
	        
	<!--- no workflow, clear the transaction immediately to status = 1 
		this will allow to amend it, otherwise you need to clear
	--->
										
	<cfquery name="Update" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   	  UPDATE PersonContractAdjustment
		  SET    ActionStatus     = '1'
		  WHERE  PersonNo         = '#Contract.PersonNo#' 
	        AND  PostAdjustmentId = '#url.postadjustmentid#' 	 
	</cfquery>
	
</cfif>	

<cfquery name="Contract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PersonContract
		WHERE  ContractId = '#url.contractid#'
</cfquery>

<cfquery name="LastContract" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PersonContract
		WHERE  Mission = '#contract.mission#'
		AND    PersonNo = '#contract.PersonNo#'
		AND    ActionStatus IN ('0','1')
		ORDER BY DateEffective DESC		
</cfquery>

<cfquery name="LastSPA" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   TOP 1 *
	    FROM     PersonContractAdjustment
		WHERE    PersonNo     = '#Contract.PersonNo#' 
		AND      Contractid IN ( SELECT Contractid 
			                     FROM   PersonContract 
								 WHERE  PersonNo = '#Contract.PersonNo#' 
								 AND    Mission  = '#Contract.Mission#' )
		AND      ActionStatus != '9'
		AND      PostSalarySchedule is not NULL
		ORDER BY DateEffective DESC		
</cfquery>

<cfoutput>

<cfform name="spaform">

	<table ccellspacing="0" width="95%" align="center" bgcolor="FFFFFF" class="formpadding formspacing">
	
		<cfif SPA.actionStatus eq "9" or SPA.actionStatus eq "8">
		
		<tr bgcolor="FFFF00"><td style="border:1px solid silver" class="labelmedium" colspan="3" align="center">Attention, this record is no longer applicable or effective</font></td></tr>
			
		</cfif>	
	
		<cfif url.action eq "1">	
		
			<cfif SPA.ActionStatus eq "0" and getAdministrator("#contract.mission#") eq "1">
			
				<tr class="line">
				  <td height="20">		   
					<cf_tl id="Delete" var="1">   
					<input class="button10g" 
					   type="button" 
					   name="Delete" 
					   onclick="validateform('spaform','delete')"
					   style="width:100px" 
					   value="#lt_text#">   
				  </td>
				</tr>			   
								   
			</cfif>   
		
		</cfif>		
		
		<tr class="xxhide"><td id="spasave"></td></tr>	
			
		<tr class="line">
			<td>
			
				<input type="hidden" name="PostAdjustmentId" value="#url.PostAdjustmentId#">
				
				<table width="99%" ccellspacing="0" align="center" class="formpadding">
								
				 <cfif SPA.recordcount eq "1">
				 													 
				 	<!--- edit of existing SPA record --->		
					<cfset def = Dateformat(SPA.DateEffective, CLIENT.DateFormatShow)>	 
					<cfset exp = Dateformat(SPA.DateExpiration, CLIENT.DateFormatShow)>
				    <cfset vst = Dateformat(Contract.DateEffective, 'YYYYMMDD')>
					<cfif SPA.DateExpiration lt LastSPA.DateEffective>
					    <cfset ved = Dateformat(Contract.DateExpiration, 'YYYYMMDD')> 
					<cfelse>
					    <cfset ved = Dateformat(LastContract.DateExpiration, 'YYYYMMDD')>
					</cfif>
					
				 <cfelseif LastSPA.recordcount gte "1">	
				 							
					<cfif LastSPA.DateExpiration neq "">		
					    <!--- New SPA define the next date after the last SPA --->
						<cfset def = Dateformat(LastSPA.DateExpiration+1, CLIENT.DateFormatShow)>
						<cfset vst = dateAdd("d","1",LastSPA.DateExpiration)>
					<cfelse>
						<cfset def = dateAdd("m","1",LastSPA.DateEffective)>
						<cfset def = Dateformat(def, CLIENT.DateFormatShow)>
						<cfset vst = dateAdd("m","1",LastSPA.DateEffective)>
					</cfif>	
										
					<cfset exp = Dateformat(Contract.DateExpiration, CLIENT.DateFormatShow)>							
					<cfset vst = Dateformat(vst, 'YYYYMMDD')>					
				    <cfset ved = Dateformat(Contract.DateExpiration, 'YYYYMMDD')>
					
				 <cfelse>	
				 	
					<!--- New SPA no prior records --->		
					<cfset def = "">	  
					<cfset exp = "">
													
					<cfquery name="getDates" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT *
						    FROM   PersonContract
							WHERE  Mission = '#contract.mission#'
							AND    PersonNo = '#contract.PersonNo#'
							AND    ActionStatus IN ('0','1')
							ORDER BY DateEffective 
					</cfquery>
								 
				    <cfset vst = Dateformat(getDates.DateEffective, 'YYYYMMDD')>
				    <cfset ved = Dateformat(Contract.DateExpiration, 'YYYYMMDD')>
					
				 </cfif>
				 				 
				<cfquery name="get" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				    SELECT *
					FROM   Person
			        WHERE  PersonNo = '#Contract.PersonNo#'
				 </cfquery>
				 
				 <cfif mode eq "view">
				 
				   <tr><td height="4" class="header"></td></tr>
					<tr class="labelmedium">
					  <td width="100"><cf_tl id="Name">:</td>
					 <td width="85%"><cfoutput><a href="javascript:personedit('#get.PersonNo#')">#Get.firstName# #Get.lastName#</a></cfoutput></td>
					</tr>
					
					<tr class="labelmedium">
					  <td><cf_tl id="IndexNo">:</td>
					  <td><cfoutput>#Get.indexNo#</cfoutput></td>
					</tr>
					
					<tr class="labelmedium">
					  <td><cf_tl id="Birth date">:</td>
					  <td><cfoutput>#dateformat(Get.birthdate,CLIENT.DateFormatShow)#</cfoutput></td>
					</tr>
					
				 </cfif>	
					
					<tr class="labelmedium">
					  <td><cf_tl id="Schedule">:</td>				  
					  <td>
					  
					  <cfquery name="Schedule" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT    *
					  FROM      SalarySchedule S INNER JOIN
		                        SalaryScheduleMission M ON S.SalarySchedule = M.SalarySchedule
						WHERE   M.Mission = '#Contract.Mission#'
					</cfquery>
					
					<cfif mode eq "view">
						 
						 	#SPA.PostSalarySchedule#
						 
					 <cfelse>
					 
					 	<cfif LastSPA.recordcount gte "1">
																
						<select name="postsalaryschedule" style="width:290px" 
						   size="1" class="regularxl">
							<cfloop query="Schedule">
								<option value="#SalarySchedule#" <cfif LastSPA.PostSalarySchedule eq SalarySchedule>selected</cfif>>#Description#</option>
							</cfloop>
					    </select>						
					 
					 	<cfelseif SPA.PostSalarySchedule eq "">
						
						<select name="postsalaryschedule" style="width:290px" 
						   size="1" class="regularxl">
							<cfloop query="Schedule">
								<option value="#SalarySchedule#" <cfif Contract.SalarySchedule eq SalarySchedule>selected</cfif>>#Description#</option>
							</cfloop>
					    </select>			
						
						<cfelse>
											
						<select name="postsalaryschedule" style="width:290px" 
						   size="1" class="regularxl">
							<cfloop query="Schedule">
								<option value="#SalarySchedule#" <cfif SPA.PostSalarySchedule eq SalarySchedule>selected</cfif>>#Description#</option>
							</cfloop>
					    </select>		
						
						</cfif>
						
					 </cfif>				  
					 
					 </td>
					
					</tr>
					
					<tr class="labelmedium">
					  <td><cf_tl id="Location">:</td>
					  
					  <td>
					  
					    <cfquery name="Schedule" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT    R.*
					  FROM      Ref_PayrollLocation R INNER JOIN
	                            Ref_PayrollLocationMission M ON R.LocationCode = M.LocationCode
					   WHERE    M.Mission = '#Contract.Mission#'
					</cfquery>
					
					<cfif mode eq "view">
						 
						 	#SPA.PostServiceLocation#
						 
					 <cfelse>
					 
					 	<cfif LastSPA.recordcount gte "1">
						
						<select name="postserviceLocation" style="width:290px"
							   size="1" class="regularxl">
								<cfloop query="Schedule">
									<option value="#LocationCode#" <cfif LastSPA.PostServiceLocation eq LocationCode>selected</cfif>>#Description#</option>
								</cfloop>
						    </select>				
					 
					 	<cfelseif SPA.PostServiceLocation eq "">
						
							<select name="postserviceLocation" style="width:290px"
							   size="1" class="regularxl">
								<cfloop query="Schedule">
									<option value="#LocationCode#" <cfif Contract.ServiceLocation eq LocationCode>selected</cfif>>#Description#</option>
								</cfloop>
						    </select>			
						
						<cfelse>
					
							<select name="postserviceLocation" style="width:290px"
							   size="1" class="regularxl">
								<cfloop query="Schedule">
									<option value="#LocationCode#" <cfif SPA.PostServiceLocation eq LocationCode>selected</cfif>>#Description#</option>
								</cfloop>
						    </select>		
						
						</cfif>
						
					 </cfif>				  
					  
					 </td>				   
					  
					</tr>
					
					<cfquery name="PostGrade" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM  Ref_PostGrade
						WHERE PostGradeContract = 1
						<!--- I made this more flexible 1/6/2010
						AND   PostGradeParent = (SELECT PostGradeParent 
						                         FROM   Ref_PostGrade 
												 WHERE  PostGrade = '#contract.ContractLevel#')
												 --->
											
						ORDER BY PostOrder
					</cfquery>
					
					<cfif PostGrade.recordcount eq "0">
					
						<cfquery name="PostGrade" 
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT   *
						    FROM     Ref_PostGrade
							WHERE    PostGradeContract = 1										
							ORDER BY PostOrder
						</cfquery>
									
					</cfif>
							
					<tr class="labelmedium">		
				  	<TD><cf_tl id="Grade">:</TD>
					<TD>
					
					<cfif mode eq "view">
						 
						 	#SPA.PostAdjustmentLevel#
						 
					 <cfelse>
					 
					 	 <cfif LastSPA.recordcount gte "1">
						 
						 <select name="contractlevel" style="width:290px"
						   size="1" class="regularxl">
							<cfloop query="PostGrade">
								<option value="#PostGrade#" <cfif LastSPA.PostAdjustmentLevel eq PostGrade>selected</cfif>>#PostGrade#</option>
							</cfloop>
					    </select>
						 
						 <cfelse>
					
						<select name="contractlevel" style="width:290px"
						   size="1" class="regularxl">
							<cfloop query="PostGrade">
								<option value="#PostGrade#" <cfif SPA.PostAdjustmentLevel eq PostGrade>selected</cfif>>#PostGrade#</option>
							</cfloop>
					    </select>
						
						</cfif>		
						
					 </cfif>
					 		
					</TD> 
				</tr>
				
				<tr class="labelmedium">
				    <TD><cf_tl id="Step">:</TD>
				    <td>
					
						<cfif mode eq "view">
						 
						 	#SPA.PostAdjustmentStep#
						 
					   <cfelse>
					   
					   <cfif LastSPA.recordcount gte "1">
					   
					   	<cfdiv bind="url:ContractSPAGrade.cfm?grade={contractlevel}&select=#LastSPA.PostAdjustmentStep#" id="dgrade"/>
					   
					   <cfelse>
					   
					   	<cfdiv bind="url:ContractSPAGrade.cfm?grade={contractlevel}&select=#SPA.PostAdjustmentStep#" id="dgrade"/>
						
					    </cfif>	
					   	<!---	
					   
						cfinput type="Text"
					       name="contractstep"
					       validate="integer"
					       required="Yes"
						   range="1,15"
						   message="please record a valid step 1-15"
					       visible="Yes"
					       enabled="Yes"			     
					       size="1"
					       maxlength="2"
						   value="#SPA.PostAdjustmentStep#"
					       class="regularxl"
					       style="text-align:center"
					      --->
						   
						</cfif>   
					</TD> 
					
				</tr>
				
				<TR class="labelmedium">
				    <TD width="170"><cf_tl id="Effective">:</TD>
				    <TD width="70%">
					
					     <cfif mode eq "view">
						 
						 	#Dateformat(SPA.DateEffective, CLIENT.DateFormatShow)#
						 
						 <cfelse>
						 
						   <cfif SPA.recordcount eq "1">
						 					   					   
								<cfquery name="PriorSPA" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT   TOP 1 *
									    FROM     PersonContractAdjustment
										WHERE    PersonNo      = '#SPA.PersonNo#' 
										AND      DateEffective < '#SPA.DateEffective#'
										AND      ActionStatus != '9'
										ORDER BY DateEffective DESC
								</cfquery>	
														
																						
								<cfif PriorSPA.recordcount eq "0">
																																																    
									 <cf_intelliCalendarDate9
										FieldName="DateEffective" 
										Default="#def#"																
										AllowBlank="False"
										class="regularxl">		
								
								<cfelse>
															
									<cfif PriorSPA.dateExpiration eq "">
											<cfset pri = Dateformat(now()+1, 'YYYYMMDD')>
										<cfelse>
											<cfset pri = Dateformat(PriorSPA.DateExpiration+1, 'YYYYMMDD')>
									</cfif>
													    
									 <cf_intelliCalendarDate9
										FieldName="DateEffective" 
										Default="#def#"
										DateValidStart="#pri#"								
										AllowBlank="False"
										class="regularxl">		
										
								</cfif>			
													   
						   <cfelse>
						   
						  					  				 					 														
							    <cf_intelliCalendarDate9
									FieldName="DateEffective" 
									Default="#def#"
									DateValidStart="#vst#"
									DateValidEnd="#ved#"
									AllowBlank="False"
									class="regularxl">	
									
							</cfif>		
						  
						 </cfif> 
										
					</TD>
					</TR>
					
						<cfoutput>
			
			     <script>
					function expiration_selectdate(argObj) {				
					  // trigger a function to set the cf9 calendar by running in the ajax td						 
					  ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/Adjustment/ContractSPAExpirationScript.cfm?personno=#contract.personno#&mission=#Contract.Mission#','DateExpiration_trigger')					  						
					} 
				</script>	
				
			     </cfoutput>	
				 				
					<TR class="labelmedium">
				    <TD><cf_tl id="Expiration">:</TD>
				    <TD>
					
					   <cfif mode eq "view">
					   			 
						 	#Dateformat(SPA.DateExpiration, CLIENT.DateFormatShow)#	
											 
					   <cfelse>	
					   
					   		<cfif Dateformat(exp, CLIENT.DateFormatShow) neq "31/12/2099">
					   					   
							<cf_intelliCalendarDate9
								FieldName="DateExpiration" 
								Default="#exp#"
								DateValidStart="#vst#"
								DateValidEnd="#ved#"
								scriptdate="expiration_selectdate"
								AllowBlank="True"
								class="regularxl">	
								
							<cfelse>
							
							<cf_intelliCalendarDate9
								FieldName="DateExpiration" 
								Default=""
								DateValidStart="#vst#"
								DateValidEnd="#ved#"
								scriptdate="expiration_selectdate"
								AllowBlank="True"
								class="regularxl">	
							
							
							</cfif>							
													
						</cfif>	
							
					</TD>
					</TR>
				
				<TR class="labelmedium">
				    <TD><cf_tl id="Step Increase">:</TD>				
				    <TD>
					
					   <cfif mode eq "view">					 
						 	#dateformat(SPA.StepIncreaseDate,client.dateformatshow)#					 
					   <cfelse>
					   
					     <cfdiv id="increment">	
						 
						      <cfif SPA.StepIncreaseDate eq "">
							    <cfset url.eff  = dateformat(now(), CLIENT.DateFormatShow)>
							  <cfelse>
							   <cfset url.eff  = dateformat(SPA.StepIncreaseDate, CLIENT.DateFormatShow)>
							  </cfif>
							
							  <cfinclude template="../ContractEditFormIncrement.cfm">
						  </cfdiv>				
					 						
						</cfif>	
							
					</TD>
					
				</TR>
				
				<cfif mode eq "view">
						
						<cfif SPA.remarks neq ""> 
						<tr class="labelmedium">
							<td style="padding-top:3px" colspan="2" class="line">#SPA.Remarks#</td>
						</tr>
						</cfif>
						 
				<cfelse>		
		
					<tr>
					<td colspan="2" style="padding-top:7px">	
							<textarea name="Remarks" class="regular" 
							onkeyup="return ismaxlength(this)"	totlength="1000" 
							style="border:0px;background-color:f1f1f1;padding:6px;font-size:15px;height:240;width:100%;">#SPA.Remarks#</textarea>
					</td>
					</tr>
						
				</cfif>	
				
							
				</table>
			
			</td>
		</tr>
		
		<cfif mode eq "view">	
		
		<cfelse>
		
			<tr><td colspan="2">	
				<table width="100%" ccellspacing="0" ccellpadding="0" bgcolor="FFFFFF">
					<tr>
						<td align="center" height="35">
										
							<cfoutput>
							
								<cf_tl id="Close" var="1">
							    <input type="button" 
								   name="cancel" 
								   value="#lt_text#" 
								   style="width:100px" 
								   class="button10g" 
								   onClick="parent.ProsisUI.closeWindow('spa')">
								   
								   <cfquery name="CheckSource" 
									datasource="AppsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									    SELECT   TOP 1 *
									    FROM     EmployeeAction
										WHERE    ActionSourceId  = '#url.PostAdjustmentId#' 										
								</cfquery>	
																								
								<cfif CheckSource.recordcount gte "1">
								   
									<cfif SPA.ActionStatus eq "0" or (SPA.ActionStatus eq "1" and getAdministrator("*") eq "1")>
									   
										<cf_tl id="Delete" var="1">   
									    <input class="button10g" 
										   type="button" 
										   name="Delete" 
										   onclick="validateform('spaform','delete')"
										   style="width:100px" 
										   value="#lt_text#">   
									   
									</cfif>   
								
								</cfif>
								   
								<cf_tl id="Save" var="1">   
							    <input class="button10g" 
								   type="button" 
								   name="Submit" 
								   onclick="validateform('spaform','save')"
								   style="width:100px" 
								   value="#lt_text#">
								   
							</cfoutput>  
							
						</td>
					</tr>
				</table>		
				</td>		
			</tr>	
			
		</cfif>	
		
		<cfif (url.action eq "1") and SPA.Recordcount eq "1">
		
			<cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.recordcount eq "0">
			
			<cfelse>
				
				<input type="hidden" 
					   name="workflowlink_#url.PostAdjustmentId#" 
					   id="workflowlink_#url.PostAdjustmentId#" 			   
					   value="EmployeeContractSPAWorkflow.cfm">	
					
				<tr>
				
					<td colspan="9" id="#url.PostAdjustmentId#">
					   <cfset url.ajaxid = url.PostAdjustmentId>				  			   
					   <cfinclude template="EmployeeContractSPAWorkflow.cfm">						  
					</td>
					
				</tr>
			
			</cfif>
				
		</cfif>
		
	</table>

</cfform>

</cfoutput>	
