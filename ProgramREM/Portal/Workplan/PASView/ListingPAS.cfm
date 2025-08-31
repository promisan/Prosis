<!--
    Copyright © 2025 Promisan B.V.

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
<cfparam name="URL.Mode"        default = "Staff">
<cfparam name="url.webapp"      default = "Backoffice">
<cfparam name="client.personno" default = "">
<cfparam name="URL.PersonNo"    default = "#client.personno#">

<cf_screentop html="No" jquery="Yes">

<cfoutput>
	<script>
		function present(mode, id) {	     		  		  
			w = #CLIENT.width# - 100;
			h = #CLIENT.height# - 140;
			
			templatepath = 'ProgramREM/Reporting/Document/PAS/PAS.cfm';
			
			if (templatepath != "") {			   
				window.open("#SESSION.root#/"+templatepath+"?id="+id,"_blank", "left=30, top=30, width=800, height=700, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
			} else {
				alert("No format selected");
			}	  
		} 
		
		function supervisor(per,cde,fun) {
			ptoken.open('#SESSION.root#/ProgramREM/Portal/Workplan/PASView/ListingSupervisor.cfm?personno='+per+'&period='+cde+'&function='+fun,'_self')
		}
	</script>
</cfoutput>
 
<cfquery name="Period" 
	datasource="appsEPas" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT *
     FROM   Ref_ContractPeriod	
	 WHERE  Mission = '#url.mission#' 	
</cfquery>	

<cfquery name="PAS" 
  datasource="AppsEPAS" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
	SELECT    C.*, 
	          IndexNo, 
			  LastName, 
			  FirstName, 
			  Gender, 
			  BirthDate, 
			  FullName, 
			  R.Description, 
			  R.InterfaceIcon,
			  G.Description as ContractClassDescription 
			
			   
	FROM       Contract AS C 
	           INNER JOIN  Employee.dbo.Person AS P ON C.PersonNo = P.PersonNo AND C.PersonNo = '#url.personNo#' AND C.Operational = 1 
			   INNER JOIN  Ref_Status AS R ON C.ActionStatus = R.Status AND R.ClassStatus = 'Contract' 
			   INNER JOIN  Ref_ContractClass AS G ON C.ContractClass = G.Code
						 
    WHERE     C.Mission = '#url.mission#'
				
	ORDER BY LastName, FirstName, P.PersonNo, C.DateEffective 
				
</cfquery>

<cfset col = "10">
	
<table width="98%" align="center" class="formpadding">
<tr><td>
    <cfif url.webapp neq "Backoffice">
		 <cfset url.id = CLIENT.personno>
	</cfif>
    <cfset ctr      = "1">		
	<cfset openmode = "open"> 	
	<cfinclude template="../../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">
</td></tr>

<cftry>
	
	<cfquery name="Pilot" 
		datasource="appsEPas" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		 SELECT PersonNo
	     FROM   stPilotUser		
	</cfquery>	
	
	<cfset pilot = valueList(Pilot.PersonNo)>
	
	<cfcatch>
		<cfset pilot = "">
	</cfcatch>

</cftry>

<cfif now() lt Period.PASPeriodStart and not find(url.personno,pilot) and getAdministrator("*") eq "0">
 
<tr><td colspan="2" style="padding:20px 0 10px 30px;height:54px;" valign="top" height="100" id="result">

					<img src="<cfoutput>#session.root#/Images/PerformanceAppraisal.png</cfoutput>" style="height:65px;float:left;">
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;">Performance <strong>Appraisal</strong></h1>
        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Check and process your Performance appraisal.</p>
        <div class="emptyspace" style="height: 40px;"></div>		
						    
	<style>
	    .x-body {
		font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif,"Raleway",sans-serif;
	}
	</style>
	
	<p></p>
	<p></p>
	<p style="font-size:40px;clear: both; margin: 1% 0 0 1%;">&nbsp;&nbsp;&nbsp;Coming soon.</p>
	
	</td>
	
</tr>	

<cfelse>

<tr><td colspan="2" style="padding:20px 0 10px 30px;height:54px;" valign="top" height="100" id="result">

					<img src="<cfoutput>#session.root#/Images/PerformanceAppraisal.png</cfoutput>" style="height:65px;float:left;">
        <h1 style="float:left;color:#333333;font-size:28px;font-weight:200;padding-top:10px;">Performance <strong>Appraisal</strong></h1>
        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Check and process your Performance appraisal.</p>
        <div class="emptyspace" style="height: 40px;"></div>		
						    
	<style>
	    .x-body {
		font-family: -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif,"Raleway",sans-serif;
	}
	</style>

	<table width="96%" align="center" class="navigation_table">
	 		
						
			<cfoutput>
						
				<tr class="labelmedium line">		   
				<td width="3%"></td>
				<td width="6%"><cf_tl id="Ref. No"></td>		
				<td width="10%"><cf_tl id="Class"></td>						
				<td width="20%"><cf_tl id="Functional Title"></td>
				<td width="30%"><cf_tl id="Section">/<cf_tl id="Unit"></td>
				<td colspan="3"><cf_tl id="Appraisal Period"></td>				
				<td style="padding-left:4px" width="20%"><cf_tl id="Reporting Officer"></td>
				<td width="10%"><cf_tl id="Status"></td>
		        </tr>
			  				
			</cfoutput>			
							
			<cfif PAS.RecordCount eq "0">
						
			<tr><td style="height:34px" class="labelit" colspan="<cfoutput>#col#</cfoutput>" align="center">
			     <font color="gray"><cf_tl id="There are no items to show in this view"></font>
			</td></tr>	
			  	   									
			<tr><td height="1" colspan="<cfoutput>#col#</cfoutput>" bgcolor="d4d4d4"></td></tr>
			
			</cfif> 
			
			
			<cfoutput query="Period">
			
				<cfquery name="PASPeriod" dbtype="query">
					  SELECT *
					  FROM   PAS
					  WHERE  Period = '#Code#'
					  ORDER BY LastName, FirstName, PersonNo, DateEffective
			   </cfquery>
							
			   <cfloop query="PASPeriod">
																						      							
						<cfif ActionStatus eq "0">
							<cfset color = "white">
						<cfelseif ActionStatus eq "1">
						 	<cfset color = "F2F7EA"> 
						<cfelse>
							<cfset color = "f4f4f4"> 
						</cfif>			
						
						<cfif contractid neq "">						
												
						<tr bgcolor="#color#" class="labelmedium navigation_row line">
						
							<td height="25" align="center" style="padding:4px;padding-right:14px">
																									
							<cfif ActionStatus lte "2">
							
							 <table>
							 <tr class="labelmedium" bgcolor="1D61A5">
							 	<td class="navigation_action" style="text-align:center;min-width:120px;color:white;padding:5px" onClick="pasdialog('#ContractId#','#mode#')"><cf_tl id="Continue"></td>
							 </tr>
							 </table> 	
							 
							<cfelseif ActionStatus lte "3">
							
							 <table>
							 <tr class="labelmedium" bgcolor="1D61A5">
							 	<td class="navigation_action" style="text-align:center;min-width:120px;color:white;padding:5px" onClick="pasdialog('#ContractId#','#mode#')"><cf_tl id="Open"></td>
							 </tr>
							 </table>  						
							 
							<cfelse>
							
							 <table>
							 <tr class="labelmedium" bgcolor="red">
							 	<td class="navigation_action" style="text-align:center;min-width:120px;color:white;padding:5px"><cf_tl id="Disabled"></td>
							 </tr>
							 </table>  
							 			
															
							</cfif>	 
							     
							</td>
							<td style="padding-right:3px">#ContractNo#</td>	
							<td style="padding-right:3px">#ContractClassDescription#</td>																			
							<td style="padding-right:3px">#FunctionDescription#</td>
							<td style="padding-right:3px">#Mission#/#OrgUnitName#</td>
							<td style="padding-right:3px">#DateFormat(DateEffective, CLIENT.DateFormatShow)#</td>
							<td>-</td>
							<td style="padding-right:3px">#DateFormat(DateExpiration, CLIENT.DateFormatShow)#</td>
							
							<td style="padding-left:4px">
							
								<cfquery name="Role" 
									datasource="appsEPas" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    *
										FROM      ContractActor C 
										WHERE     ContractId   = '#ContractId#'
										AND       RoleFunction = 'FirstOfficer'
										AND       ActionStatus = '1'
										ORDER BY  RoleFunction
								</cfquery>
							
								<cfquery name="Evaluator" 
									datasource="appsEmployee" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT    *
										FROM      Person 
										WHERE     PersonNo = '#Role.PersonNo#'
								</cfquery>				
								
								<cfif Evaluator.FullName eq "">
								  	<font color="FF0000"><cf_tl id="To be determined"></font>
								<cfelse> 
								    #Evaluator.FullName#
								</cfif>
							
							</td>
							
							<td style="width:5%">
								<table>
									<tr>
																						
										<td style="min-width:100px;padding-right:5px">
										
										 <cfif ActionStatus lte "2">
										 												
											 <cfquery name="Section" 
												datasource="appsePas" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
												SELECT      R.Description, 
												            R.DescriptionTooltip, 
															CS.ProcessStatus
												FROM        ContractSection AS CS INNER JOIN
									                        Ref_ContractSection AS R ON CS.ContractSection = R.Code
												WHERE       CS.ContractId = '#contractId#'
												ORDER BY    R.ListingOrder
											</cfquery>	
										
											<table width="100%">
												<tr>
												
												<cfloop query="section">										
												<td style="height:15px;border:1px solid gray;<cfif ProcessStatus eq "1">background-color:lime</cfif>">									
												<cf_UIToolTip tooltip="#DescriptionTooltip#"></cf_UIToolTip>
												</td>																								
												</cfloop>												
												</tr>
											</table>
											
											<cfelse>
																						
											<img src="#SESSION.root#/images/#InterfaceIcon#" alt="#Description#" border="0" align="absmiddle">
											
											</cfif>
											
										</td>
																						
										<td style="padding-left:10px;padding-right:5px">
											<img src="#SESSION.root#/images/pdfform.png" style="height:20px;" align="absmiddle" onclick="present('PDF','#ContractId#');">
										</td>
										
									</tr>
								</table>
							</td>
													
						</tr>							
						
					</cfif>
					
					<cfif actionstatus lte "1" and contractId neq "">
								
						<tr class="line">
							<td style="padding-top:5px;font-size:19px;height:50px;padding:0px 8px 0;font-weight: 180;" align="center" colspan="10" class="labelmedium">								
								<font color="red"><cf_tl id="You need to complete and submit your draft">		
								(<a href="https://prosis.stl/Apps/Manual/ePasModuleManual.pdf" target="_new"><cf_tl id="Click here for instructions"></b></a>) 										
							</td>
						</tr>
						
					</cfif>	
					
					</cfloop>
					
					 <cfquery name="First" 
							datasource="appsePas" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
					
					       SELECT       COUNT(*) AS Counted
                           FROM         Contract AS SC INNER JOIN
                                        ContractActor AS SA ON SC.ContractId = SA.ContractId
                           WHERE        SC.Period = '#Code#' 
						   AND          SC.ActionStatus NOT IN ('8', '9') 
						   AND          SA.PersonNo = '#client.personno#' 
						   AND          SA.RoleFunction = 'FirstOfficer' 
						   AND          SA.ActionStatus = '1' 
					</cfquery>	   
						   
						   
					<cfquery name="Second" 
						datasource="appsePas" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">   	
							
						   SELECT       COUNT(*) AS Counted
                           FROM         Contract AS SC INNER JOIN
                                        ContractActor AS SA ON SC.ContractId = SA.ContractId
                           WHERE        SC.Period = '#Code#' 
						   AND          SC.ActionStatus NOT IN ('8', '9') 
						   AND          SA.PersonNo = '#client.personno#' 
						   AND          SA.RoleFunction = 'SecondOfficer' 
						   AND          SA.ActionStatus = '1' 	
					 </cfquery>	   				   
						            					
																								
					<cfif First.Counted gte "1" or Second.Counted gte "1">
					
						<tr class="line">
						<td class="labelmedium" style="padding-left:10px;height:40px" colspan="10">
						<table>
						    <tr class="labelmedium">
							    <td style="font-size:20px">#Code#:</td>
								
								<cfif First.Counted gte "1">
								<td style="padding-left:5px;font-size:20px">
									<a href="javascript:supervisor('#client.personno#','#code#','FirstOfficer')"><cf_tl id="First Reporting Officer"> [#First.counted#]</a>	
								</td>
								</cfif>
								<cfif Second.Counted gte "1">
								<td style="padding-left:5px;font-size:20px">					
								<a href="javascript:supervisor('#client.personno#','#code#','SecondOfficer')"><cf_tl id="Second Reporting Officer"> [#Second.Counted#]</a>
								</td>
								</cfif>
						    </tr>
						</table>
						</td></tr>
					
					</cfif>
										      
		</cfoutput>  		 
	
	</table>

</td></tr>	

</cfif>

<!---

	<tr class="line">
		<td style="padding-top:20px;font-size:16px;height:50px;padding:0px 8px 0;font-weight: 180;" align="center" colspan="9" class="labelmedium">								
			<a href="http://hrportal.stl/prosisdocument/manual/ePasModuleManual.pdf" target="_new">ePAR Module Instruction Manual</a> 										
		</td>
	</tr>
	
--->

</table>

<cfset ajaxonload("doHighlight")>
