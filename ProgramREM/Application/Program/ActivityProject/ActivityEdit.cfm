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
<cfparam name="URL.ajax" default="0">
		
<cfinclude template="ActivityEditInit.cfm">  

<cfquery name="Delete" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	DELETE FROM ProgramActivity 
		WHERE  Reference     = 'TMP'
		AND    OfficerUserId = '#SESSION.last#'
		AND    ActivityId   != '#URL.ActivityId#'
</cfquery>

<cfquery name="Period" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT    *
    FROM      Ref_Period
	ORDER BY  Period
</cfquery>

<cfinvoke component="Service.AccessGlobal"  
      method="global" 
	  role="AdminProgram" 
	  returnvariable="AdminAccess">

<cfset URL.ActivityID = trim("#URL.ActivityID#")>

<!--- Query returning search results for activities  --->
<cfquery name="EditActivity" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   A.*, 
	         O.OrgUnitName, 
			 O.OrgUnitCode, 
			 O.OrgUnitClass, 
			 O.Mission, 
			 O.MandateNo		
	FROM     #CLIENT.LanPrefix#ProgramActivity A LEFT OUTER JOIN Organization.dbo.#CLIENT.LanPrefix#Organization O
	ON       A.OrgUnit    = O.OrgUnit
	WHERE    A.ActivityID = '#URL.ActivityID#'  
</cfquery>

<cfif EditActivity.recordcount eq "0">
	
	<!--- Query returning search results for activities  --->
	<cfquery name="EditActivity" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   A.*, 
		         O.OrgUnitName, 
				 O.OrgUnitCode, 
				 O.OrgUnitClass, 
				 O.Mission, 
				 O.MandateNo		
		FROM     ProgramActivity A LEFT OUTER JOIN Organization.dbo.#CLIENT.LanPrefix#Organization O
		ON       A.OrgUnit    = O.OrgUnit
		WHERE    A.ActivityID = '#URL.ActivityID#'  
	</cfquery>

</cfif>

<cfset url.programcode = EditActivity.ProgramCode>
<cfset url.period      = EditActivity.ActivityPeriod> 
		
<cfif EditActivity.recordstatus eq "9">	
	<cfset st = "new">	
<cfelse>
	<cfset st = "edit">
</cfif>		

<cfquery name="Parameter" 
    datasource="AppsProgram" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#EditActivity.Mission#'
</cfquery>


<cf_tl id="Activity has been completed." var="1" class="message">
<cfset msg1="#lt_text#">

<cf_tl id="Please enter a valid duration" var="1" class="message">
<cfset msg2="#lt_text#">

<cf_tl id="You must enter a activity short description (50 chars)" var="1" class="message">
<cfset msg3="#lt_text#">

<cf_divscroll style="height:100%">

<cfform name="activityentryform" method="post" onsubmit="return false"> 

	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			   
	<tr><td height="100%" colspan="2" valign="top">  
	  
		<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
		   
		  <tr><td height="100%" colspan="2" valign="top">       
				  
			    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
					
					<cfoutput>	
					<input type="hidden" name="ProgramCode" id="ProgramCode"   value = "#EditActivity.ProgramCode#">		
					<input type="hidden" name="Period"      id="Period"        value = "#EditActivity.ActivityPeriod#">	
					<input type="hidden" name="ActivityId"  id="ActivityId"    value = "#url.activityid#">	
					<input type="hidden" name="Access"      id="Access"        value = "#ProgramAccess#">	
					</cfoutput>		
					
					<cfset url.programcode = EditActivity.ProgramCode>
					<cfset url.period      = EditActivity.ActivityPeriod> 
					
				    <!--- Field: Activity Date --->
				
					<cfset DefaultDate      = EditActivity.ActivityDate>
					<cfset DefaultDateStart = EditActivity.ActivityDateStart>		
					
					<!--- access is granted in case you have ALL or if the action is not completed --->	
					<!--- 31/3/2014 : need to tune this to disable it when access is READ ---> 
						 						
					<tr><td height="40" colspan="2" valign="top">				
					
							<table width="100%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
														
							<tr><td colspan="4">
							
								<table width="95%" align="center" class="formpadding">
																
									<!--- Field: Activity Description--->
									<TR>
								        <td style="min-width:200px" class="labelmedium"><cf_tl id="Short Description">:</td>
									    <td width="80%" colspan="3" height="24" class="labelmedium"><i>
										
										    <cfoutput>
											
												<cfif ProgramAccess eq "ALL" or completed eq "0">						
												
													<cfinput type = "Text" 
													   name       = "activitydescriptionshort" 
													   value      = "#EditActivity.activitydescriptionshort#" 
													   message    = "#msg3#" 
													   required   = "Yes" 
													   visible    = "Yes" 
													   enabled    = "Yes" 
													   size       = "50"
													   maxlength  = "50" 
													   style      = "border:1px solid silver;padding-left:5px"
													   class      = "regularxl enterastab">
															
												<cfelse>
												
													<input type="hidden" name="activitydescriptionshort" id="activitydescriptionshort" value="">		
													<cfif EditActivity.ActivityDescriptionShort neq "">
														#EditActivity.ActivityDescriptionShort#
													<cfelse>
														n/a
													</cfif>
												
												</cfif>
											
											</cfoutput>
										 </td>
									</TR>
											 	
								    <!--- Field: Activity Description--->
									<TR>
								        <td valign="top">
										   <table><tr><td height="20" class="labelmedium"><cf_tl id="Description">:</td></tr></table>
										</td>
									    <td colspan="3" height="28" class="labelmedium">
										   <cfoutput>
											<cfif ProgramAccess eq "ALL" or completed eq "0">																							
											<textarea class="regular" style="font-size:15px;padding:5px;width:100%;height:66px" name="activitydescription">#EditActivity.ActivityDescription#</textarea>																				
											<cfelse>
											<input type="hidden" name="activitydescription" id="activitydescription" value="">		
											#EditActivity.ActivityDescription#
											</cfif>
										   </cfoutput>	
										 </td>
									</TR>
																				 	
								    <!--- Field: Activity Outline--->
									<TR>
								        <td valign="top">
										   <table><tr><td height="20" class="labelmedium"><cf_tl id="Detailed Outline">:</td></tr></table>
										</td>
									    <td colspan="3" height="28" class="labelmedium" style="padding-right:1px;border:1px solid silver">
										   <cfoutput>
										   
											<cfif ProgramAccess eq "ALL" or completed eq "0">											
											
											   <cf_textarea name="activityoutline" id="activityoutline"                                            
												   height         = "100"
												   toolbar        = "mini"
												   init           = "Yes"
												   resize         = "yes"
												   color          = "ffffff">#EditActivity.ActivityOutline#</cf_textarea>										
																																	
											<cfelse>
												<input type="hidden" name="activityoutline" id="activityoutline" value="">		
												#EditActivity.ActivityOutline#
											</cfif>
										   </cfoutput>	
										 </td>
									</TR>									
																				
								    <TR>
								    <TD class="labelmedium"><cf_tl id="Start Date">:<cf_space spaces="45"></TD>
								    <TD>
									   
									   <table cellspacing="0" cellpadding="0">
									   <tr>
									    <!--- ajax box for processing dependency --->
										
									    <td class="labelmedium">
		
										<cfif completed eq "0">
										
										  <cf_intelliCalendarDate9
												FieldName="activitydatestart" 
												Default="#Dateformat(defaultdateStart, CLIENT.DateFormatShow)#"
												onchange="setstartdate('#EditActivity.activityid#')"											
												message="Please record a valid activity start date"
												class="regularxl enterastab"
												AllowBlank="False">									
																	
											<cfquery name="CheckParent" 
											    datasource="AppsProgram" 
											    username="#SESSION.login#" 
											    password="#SESSION.dbpw#">
												 SELECT  *
												 FROM    ProgramActivityParent B
												 WHERE   B.ActivityId = '#url.ActivityId#'  	
												 AND     ActivityId != ActivityParent			 
											</cfquery>							
											
											<cfif CheckParent.recordcount gte "1">
												<input type="hidden" name="ds_disable" id="ds_disable" value=1>
											<cfelse>
												<input type="hidden" name="ds_disable" id="ds_disable" value=0>
											</cfif>
											
										<cfelse>
										
											<cfoutput>
											<input type="hidden" name="activitydatestart" id="activitydatestart" value="#Dateformat(defaultdateStart, CLIENT.DateFormatShow)#">		
											#Dateformat(defaultdateStart, CLIENT.DateFormatShow)#
											</cfoutput>
											
										</cfif>	
									    </td>
										
										<td class="hide" id="setstartdate">&nbsp;</td>
										
										<td>&nbsp;</td>
										<td>&nbsp;</td>					
																				
										<cfif completed eq "0">
										
										    <td style="padding-right:6px">
											
											<input type="radio" class="enterastab" style="width:18px;height:18" name="selectme" id="selectme" value="duration" onClick="end(this.value)"></td>
										   
										    <td style="padding-right:3px" class="labelmedium"><cf_tl id="Duration"></td>
											
											<td style="padding-left:5px;padding-right:6px" id="duration" class="hide">:
											
											<cfinput type="Text" name="activitydays" class="regularxl enterastab" value="#EditActivity.ActivityDays#" range="0,800" message="#msg2#" 
											                     validate="integer" 
																 style="text-align:center"
																 required="No" 
																 size="3" 										 
																 maxlength="3">
																 
											<cfoutput>					 
											<input type="hidden" name="PriorDate" id="PriorDate" value="#Dateformat(defaultdate, CLIENT.DateFormatShow)#"></td>
											<td class="labelmedium" style="padding-right:3px"><cf_tl id="days"></td>
											</cfoutput>					
																
											<td style="padding-left:6px;padding-right:6px"><input type="radio" class="enterastab" style="width:18px;height:18" name="selectme" id="selectme" value="enddate" onClick="end(this.value)" checked></td>
											<td style="padding-right:3px" class="labelmedium"><cf_tl id="End date"></td>						
												
											<td id="enddate" style="padding-left:5px;padding-right:3px">
											
											  <cf_intelliCalendarDate9
													FieldName="activitydate" 
													class="regularxl enterastab"
													Default="#Dateformat(defaultdate, CLIENT.DateFormatShow)#"
													AllowBlank="True">	
												
											</td>
										
										<cfelse>
										
											<cfoutput>
												<input type="hidden" name="selectme" id="selectme" value="duration">
												<input type="hidden" name="activitydays" id="activitydays" value="#EditActivity.ActivityDays#">
											</cfoutput>
											
										</cfif>
									
									   </table>			
								 	</TD>
									</TR>
									
									<!--- determine possible dependency : add a expand option to hide/show --->
									
									<cfif completed eq "0">
									
									<tr><td></td>
										<td><cfinclude template="ActivityEditDependency.cfm"></td>						
									</tr>
									
									</cfif>
										
									<cfif completed eq "1">					
																	
										<TR>
										<cfif EditActivity.ActivityDateStart neq EditActivity.ActivityDate>
											<TD class="labelmedium"><cf_tl id="Planned End Date">:</td>
										<cfelse>
											<TD class="labelmedium"><cf_tl id="Actual End Date">:</td>
										</cfif>
											<td class="labelmedium">
												<cfoutput>
												<font color="008000">#DateFormat(EditActivity.ActivityDateEnd,CLIENT.DateFormatShow)#</font>
												</cfoutput>
											</TD>
										</TR>
										
										<cfif EditActivity.ActivityDateStart neq EditActivity.ActivityDate>
										
											<TR>
											<TD class="labelmedium"><cf_tl id="Actual End Date">:</td>
											<td class="labelmedium">
												<cfoutput>
												<font color="008000">#DateFormat(DefaultDate,CLIENT.DateFormatShow)#</font>							
												<font color="008000">&nbsp;<i>#msg1#</font>
												</cfoutput>
											</TD>
											</TR>
										
										</cfif>
										
									</cfif>				
									
									</td>
									</tr>			
																
									<cfinclude template="ActivityEditDetails.cfm">
																		
									<cfquery name="targetlist" 
										datasource="AppsProgram" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT   T.*, (SELECT Targetid 
											             FROM   ProgramActivityOutput 
														 WHERE  ProgramCode     = '#url.programcode#'
													 	 AND    ActivityPeriod  = '#url.period#'	
														 AND    ActivityId      = '#url.ActivityId#'		
														 AND    TargetId        = T.TargetId
														 AND    RecordStatus != '9') as Selected, C.Description
											FROM     ProgramTarget T
													 INNER JOIN ProgramCategory PC
														ON T.ProgramCode = PC.ProgramCode
														AND T.ProgramCategory = PC.ProgramCategory
													 INNER JOIN Ref_ProgramCategory C
														ON PC.ProgramCategory = C.Code
											WHERE    T.ProgramCode = '#url.programcode#'
											AND      T.Period      = '#url.period#'												
											AND      T.RecordStatus != '9'
											ORDER BY C.ListingOrder ASC, T.ListingOrder ASC
									</cfquery>										
									
									<cfif targetlist.recordcount gte "1">
									
										<tr>
																
											<td height="40" valign="top" style="padding-top:4px" class="labelmedium"><cf_tl id="Outputs">:</td>						  
											<td>
											
												<table width="100%">
												
												<cfoutput query="targetlist" group="ProgramCategory">
												
													<tr><td class="labelmedium" colspan="3"><font color="gray">#Description#</td></tr>
												
													<cfoutput>
												
													<tr>
													   <td valign="top" style="padding-left:3px;width:20;padding-top:2px">
													     <input type="checkbox" <cfif selected neq "">checked</cfif> name="target_#left(targetid,8)#" value="#targetid#">
													   </td>
													   <td valign="top" style="width:20px;padding-left:4px" class="labelit">#currentrow#.</td>												  
													   <td style="padding-left:10px" valign="top" class="labelit"><b>#TargetReference#</b> - #TargetDescription#</td>
												   </tr>
												   
												   <cfif TargetIndicator neq "">
												   
												   <tr class="line">
												       <td></td>
												       <td></td>
												   	   <td style="padding-left:10px" class="labelit">#TargetIndicator#</td>
												   </tr>
												   
												   </cfif>
												   
												   </cfoutput>
												   
												</cfoutput>											
												
												</table>
																												
											</td>
										</tr>	
									
									</cfif>											
									
									<tr>
															
										<td height="40" valign="top" style="padding-top:5px" class="labelmedium">
										<cfif targetlist.recordcount gte "1">
											<cf_tl id="Other outputs">:
										<cfelse>
											<cf_tl id="Outputs">:
										</cfif>
										</td>						  
										<td>
																									
											<cfdiv id="outputbox">						    
											    <cfset url.id            = URL.ActivityId>
												<cfset url.programaccess = programaccess>														
												<cfinclude template="OutputEntry.cfm">	
											</cfdiv>													
															
										</td>
									</tr>	
																
								</table>
							</td>
						</tr>						
						</table>			
						
					</td>
					
					</tr>		
									
				</table>					
									
				</td>
				 
				</tr>				
				
				<cfif ProgramAccess eq "ALL" or completed eq "0"> 	
				
						<tr class="line"><td colspan="2"></td></tr>
						
					  	<tr>
							
						<td height="25" align="center" colspan="2" id="process" style="padding-left:7px">
								
						   <table class="formspacing" align="center">
						   
						   <tr>
						   
						   <td width="1%" align="right" id="detail"></td>
						   
						   <!--- check if there is a program report --->
						   
						   <cfquery name="Progress" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
								SELECT  ProgressId
								FROM    ProgramActivity P INNER JOIN 
								        ProgramActivityOutput PO ON P.ActivityID = PO.ActivityID AND PO.RecordStatus != 9 INNER JOIN 
										ProgramActivityProgress PA ON PO.OutputID = PA.OutputID AND PA.RecordStatus != 9
								WHERE   P.RecordStatus != 9 
								AND     P.ActivityID = '#URL.ActivityId#'		  		
						   </cfquery>	  					   
						 		   
						   <cfif Progress.recordcount eq "0" 
								  OR AdminAccess eq "EDIT" 
								  OR AdminAccess eq "ALL">
								  
							   <cfif editactivity.recordcount eq "1">  
							   
								   <cf_tl id="Delete" var="1">
								   
								   <cfoutput>	
								 
								   <td>
								   
								   <input type="button" 
										class="button10g" style="width:140px;height:25px;font-size:13px"
										onclick="if (confirm('Do you want to purge this activity ?')) {	ColdFusion.navigate('ActivityEditDelete.cfm?activityid=#url.activityId#','process')};" 
										name="Delete" 
										value="<cfoutput>#lt_text#</cfoutput>">
										
									</td>
									
									</cfoutput>	
								   
							   </cfif>
							   
						  </cfif>	
						  
						  <td> 		  
						 		  
							  <cfif st eq "new">
								  	<cf_tl id="Save | Next" var="1">
								   <input class="button10g" style="width:170px;height:27px;font-size:13px" type="button" name="UpdateNext" value="<cfoutput>#lt_text#</cfoutput>" onclick="updateTextArea();validate()">		
							  <cfelse>
								   <cf_tl id="Save" var="1">
								   <input class="button10g" style="width:170px;height:27px;font-size:13px" type="button" name="Update" value="<cfoutput>#lt_text#</cfoutput>" onclick="updateTextArea();validate()">
							  </cfif>
						   
						  </td>
						   
						   </tr>
						   
						   </table>
						   
						</td>
						
					    </tr>	
										
					</cfif>
		   
		</table>
			
		</TD>
		</TR>
		
	</TABLE>

</cfform>
		
</cf_divscroll>


<cfif URL.ajax eq 1>	 
	 <cfset ajaxonload("doCalendar")>
     <cfset ajaxOnLoad("initTextArea")>
<cfelse>
	 <script>
	 	dateInit();
	 </script>	 
</cfif>	 
