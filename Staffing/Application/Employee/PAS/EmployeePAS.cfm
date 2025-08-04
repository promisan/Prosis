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

<cfparam name="URL.Mode" default="Current">
<cfparam name="URL.Code" default="">
<cfparam name="URL.PersonNo" default="#URL.ID#">
 
<cfquery name="Evaluation" 
  datasource="AppsEPAS" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  
	SELECT    C.*, IndexNo, LastName, FirstName, Gender, BirthDate, FullName, R.Description, R.InterfaceIcon
	FROM      Contract C,
			  Employee.dbo.Person P,
			  Ref_Status R
	WHERE     C.PersonNo        = P.PersonNo
	AND       C.ActionStatus    = R.Status
	AND       R.ClassStatus     = 'Contract'	
	AND       C.PersonNo       = '#URL.ID#'	
	
	AND       C.Operational = 1  
	
	<cfif URL.Mode eq "Current">
	AND       C.Period IN (SELECT Code FROM Ref_ContractPeriod WHERE Operational = 1)
	</cfif>
	
	ORDER BY LastName, FirstName, P.PersonNo, C.DateEffective
</cfquery>

<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop label="" jquery="Yes" height="100%" scroll="yes" html="No" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
		

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

<!--- scripts --->
<cf_dialogstaffing>
<cf_dialogPosition>
<cf_fileLibraryScript>

<cfset col = "8">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
	
<tr>
	<td height="40">
						
		<table cellpadding="0" cellspacing="0" width="99%" align="center">
		
			<tr><td height="10" style="padding-top:3px;padding-left:7px">	
				  <cfset ctr      = "0">		
			      <cfset openmode = "show"> 
				  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
				 </td>
			</tr>	
			
		</table>
	
		</td>
</tr>

<tr><td>
	
	

	<table width="96%" border="0" align="center" class="navigation_table">
	 			
			<cfif URL.Mode neq "All">
			
			    <cfoutput>
						
				<tr class="labelmedium line">		   
				<td width="3%"></td>
				<td width="7%"><cf_tl id="Contract"></td>
				<td width="20%"><cf_tl id="Unit"></td>
				<td width="15%"><cf_tl id="Reporting Officer"></td>
				<td width="20%"><cf_tl id="Function"></td>
				
				<td width="15%" style="min-width:160px"><cf_tl id="Period"></td>	
				<td width="3%"></td>			
				<td width="10%"><cf_tl id="Status"></td>
		        </tr>
			  				
				</cfoutput>
				
			</cfif>	
			
			<cfif Evaluation.RecordCount eq "0">
						
			<tr><td height="50" class="labelmedium" style="height:30" colspan="<cfoutput>#col#</cfoutput>" align="center">
			     <font color="gray"><cf_tl id="There are no items to show in this view"></font>
			</td></tr>	
			  	   									
			<tr><td height="1" colspan="<cfoutput>#col#</cfoutput>" bgcolor="d4d4d4"></td></tr>
			
			</cfif> 
				
				<cfoutput query="Evaluation" group="PersonNo">
										
						<cfoutput>
										      							
								<cfif ActionStatus eq "0">
									<cfset color = "FCFBE0">
								<cfelseif ActionStatus eq "1">
								 	<cfset color = "F2F7EA"> 
								<cfelse>
									<cfset color = "f4f4f4"> 
								</cfif>													
								
								<cfquery name="Role" 
									datasource="appsEPas" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT    *
									FROM      ContractActor C 
									WHERE     ContractId = '#ContractId#'
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
															
								<tr bgcolor="#color#" class="navigation_row line">
								
									<td height="25" align="center" style="min-width:40px;padding-top:3px">																											
									 <cf_img icon="edit" navigation="Yes" onClick="pasedit('#ContractId#','#mode#')">																			     
									</td>								
									     
									</td>
									<td>#ContractNo#</td>
									<td class="labelit" width="15%" colspan="1">#Mission#/#OrgUnitName#</td>
									<td width="15%" class="labelit">
									<cfif Evaluator.FullName eq "">
									  <cf_tl id="Pending">
									<cfelse> 
									  #Evaluator.FullName#
									</cfif>
									</td>
									<td class="labelit" width="15%" colspan="1">#FunctionDescription#</td>
									
									<td class="labelit" width="15%">#DateFormat(DateEffective, CLIENT.DateFormatShow)# - #DateFormat(DateExpiration, CLIENT.DateFormatShow)#</td>
									
									<td height="25" align="center" style="padding-top:2px">
									
									<cfif ActionStatus gte "0">
									
									 <cf_img icon="open" onClick="pasdialog('#ContractId#','#mode#')">
																	
									</cfif>	 																	
									
										<td style="width:5%">
											<table align="center">
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
															AND         CS.Operational = 1
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
																									
														<cf_tl id="Completed">
														
														</cfif>
														
													</td>
																									
													<td style="padding-left:10px;padding-right:5px">
														<img src="#SESSION.root#/images/pdfform.png" style="height:20px;" align="absmiddle" onclick="present('PDF','#ContractId#');">
													</td>
													
												</tr>
											</table>
										</td>
																								
								</tr>
																																		      
				        </cfoutput> 
																      
		</cfoutput>  		 
	
	</table>
</td></tr>
</table>
<cfset ajaxonload("doHighlight")>
