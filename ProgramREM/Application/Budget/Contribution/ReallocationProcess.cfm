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
<!--- here we show only relevant contributions based on the selected program through the transactionid and we 
show along the same lines as for the initial assignment of funding only contribution lines that indeed
have funding left that matches the amount of this line ProgramAllotmentDetailContribution ---> 

<cf_screentop height="100%" 
      scroll="Yes" 
	  label="Amend transaction contribution"      
	  jquery="yes"
	  html="Yes" 
	  close="parent.ColdFusion.Window.destroy('mycontribution',true)"
	  banner="gray" 
	  line="no"
	  layout="webapp">
	 
<cf_DialogREMProgram>
<cf_actionlistingscript>
<cfajaximport tags="cfform,cfdiv">

<cfoutput>
<script>

function showlist(line,act) {
  
	   se = document.getElementsByName(line)
	   ex = document.getElementById(line+'_exp')
	   mn = document.getElementById(line+'_min')
	   cnt = 0
	   
	   if (act == "show") {
	    	 
		  while (se[cnt]) {	  	    
			se[cnt].style.display = 'block'
			cnt++
		  }  		
		  mn.style.display = 'none'	 		 
		  ex.style.display = 'block'	  	 
		 
	   } else {
	            	   
	   	  while (se[cnt]) {	 		   
		     se[cnt].style.display = 'none'
		     cnt++
		  } 		    
		  ex.style.display = 'none'	 		 
		  mn.style.display = 'block'	 
		   }
	
		}

function changeReference(id) {        
		ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionReferenceEdit.cfm?editreference=1&id='+id, 'tdReference');
	}
	
function submitActionReference(id) {
		ColdFusion.navigate('#SESSION.root#/ProgramREM/Application/Budget/Action/AllotmentActionReferenceEditSubmit.cfm?id='+id, 'tdReference','','','POST','editreference');	
	}


</script>

</cfoutput>

<cfparam name="URL.scope"              default="">
<cfparam name="URL.ContributionLineId" default="">

<cfoutput>

<cf_divscroll height="100%">
		
<table width="100%" height="100%" align="center">
		<tr><td id="main" valign="top">
		
		<cfform name="donorform" id="donorform">
		
		<input type="hidden" name="TransactionIds" value="#url.transactionids#">
		
		<table width="100%" align="center">
					
		<cfset row = "0">
		
			<tr>
			<td>
				   	
			<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
			
			<tr><td colspan="10">
					
				   <cf_presentationscript>
						
					<cfinvoke component = "Service.Presentation.TableFilter"  
					   method           = "tablefilterfield" 
					   name             = "linesearch"				  
					   filtermode       = "direct"
					   style            = "font:17px;height:23;width:120"
					   rowclass         = "clsdonor"
					   rowfields        = "ccontent">			
				
				</td>
			</tr>	
				
			<cfloop index="transactionid" list="#url.transactionids#" delimiters=":">
								
					<cfoutput>
					
					 <cfif row eq "0">
					 
					 	<tr>	
						    <td width="10"></td>
							<td width="30%" class="labelit"><cf_tl id="Contribution"></td>
							<td width="90" class="labelit">Expiration</td>
							<td width="100" align="right" class="labelit">Original</td>
							<td width="80" align="right"  style="padding-top:3px" class="labelsmall">Overdraw</td>
							<td width="80" align="right"  style="padding-top:3px" class="labelsmall">Adjusted</td>
							<td width="100" align="right" class="labelit">Amount</td>
							<td width="100" align="right" class="labelit">Allocated</td>
							<td width="100" align="right" class="labelit">Balance</td>
							<td width="100" align="right" class="labelit">Allocation</td>	
						</tr>
						<tr><td colspan="10" class="line"></td></tr>
					 			 
					 </cfif>
					 
					 <cfset row = row+1>
								
					 <cfquery name="getTransaction" 
							datasource="AppsProgram" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							
							SELECT     P.Mission, 
							           P.ProgramCode, 
									   P.ProgramName,
									   PA.Period,
							           PA.Fund,
									   PA.OrgUnit, 
									   PA.ObjectCode,
									   PA.Amount,
									   Per.Period, 
									   Per.DateEffective, 
									   Per.DateExpiration, 									   
									   R.Version
							FROM       ProgramAllotmentDetail PA INNER JOIN
					                   Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
					                   Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
					                   Ref_Period Per ON R.Period = Per.Period
							WHERE      PA.TransactionId = '#transactionid#'	  
							AND        PA.Status = '1' <!--- only cleared amounts --->
						 </cfquery> 
						
										
						<tr class="line">
						<td colspan="10" bgcolor="80FFFF">
						
							<table width="100%">					
								
								<tr>
								    <td>
									
									   <img src="#SESSION.root#/Images/ct_collapsed.gif" alt="" 
											id="line_#row#_min" 
											border="0" style="border:1px solid silver"
											align="right" class="hide" style="cursor: pointer;" 
											onClick="showlist('line_#row#','show')">
												   
										<img src="#SESSION.root#/Images/ct_expanded.gif" 
											id="line_#row#_exp" alt="" border="0" 
											style="border:1px solid silver"
											align="right" class="show" style="cursor: pointer;" 
											onClick="showlist('line_#row#','hide')">
									
									</td>
									<td class="labelit" style="width:20%;padding-left:10px">
										<a href="javascript:AllotmentInquiry('#getTransaction.ProgramCode#','#getTransaction.Fund#','#getTransaction.Period#','Inquiry','#getTransaction.Version#')">
										#getTransaction.ProgramName#:
										</a>									
									</td>
												
									<td class="labelsmall" style="width:40;padding-left:10px">Fund:</td>
									<td class="labelit" style="width:60;padding-left:10px"><b>#getTransaction.Fund#</td>
										
									<cfquery name="Object" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT *
										FROM   Ref_Object
										WHERE  Code = '#getTransaction.ObjectCode#'
									</cfquery>
															
									<td class="labelit" style="width:30%" style="padding-left:3px"><b>#Object.Code# #Object.Description#</td>
									
									<cfquery name="Org" 
									datasource="AppsProgram" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										SELECT *
										FROM   Organization.dbo.Organization
										WHERE  OrgUnit = '#getTransaction.OrgUnit#'
									</cfquery>
																	
									<td class="labelit" style="width:30%" style="padding-left:3px"><b>#org.OrgUnitName#</td>
															
									<td class="labelmedium" align="right" style="width:200;padding-right:8px">#Application.BaseCurrency# #numberformat(getTransaction.Amount,"__,__.__")#</td>
								</tr>
											
							</table>
						
						</td>
						</tr>
												
										
					</cfoutput>
					
					<tr><td height="5"></td></tr>		
										
					<cfset processmode = "amendment"> 
					<cfset total = 0> 
					<cfset url.box = row>
					<cfset url.transactionid = transactionid>
					 				 
					<cfinclude template="../Allotment/Clearance/DonorAllocationViewLines.cfm">
								
			</cfloop>
		
			</table>	 
				
			</td>
			
		</tr>
		
		<cfif row gte "1">
						
			<tr>
				<td>
				<table width="95%" align="center" class="formpadding">
					<tr>
					<td class="labelmedium" style="width:120;height:25;padding-left:5px;padding-right:20px">Transaction&nbsp;date:</td>
					<td colspan="6">
						
						<cf_calendarscript>
							
						<cf_intelliCalendarDate9
							FieldName      = "TransactionDate" 
							Manual         = "True"		
							class          = "regularxl"					
							DateValidStart = "#Dateformat(getTransaction.DateEffective, 'YYYYMMDD')#"
							DateValidEnd   = "#Dateformat(getTransaction.DateExpiration, 'YYYYMMDD')#"
							Default        = "#dateformat(now(),client.dateformatshow)#"
							AllowBlank     = "False">	
						
					</td>
					</tr>
					<tr>		
					    <td class="labelmedium" valign="top" style="padding-left:5px;height:25px;padding-top:6px"><cf_tl id="Memo">:</td>
						<td colspan="6">
						
							<textarea totlength="150" class="regular" onkeyup="return ismaxlength(this)" name="Memo" style="font-size:14px;padding:3px;height:55;width:100%"></textarea>	
							  
						</td>	  
					</tr>
				</table>
				</td>
			</tr>	
			
			<tr class="xhide"><td id="submitbox"></td></tr>
			
			<tr>
				<td align="center" id="submitbutton" style="padding-top:2px">
						  
					<input type="button"
				    	 onclick="Prosis.busy('yes');document.getElementById('apply').className = 'hide';ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Contribution/ReallocationSubmit.cfm?rows=#row#&transactionid=#url.transactionid#&processmode=apply&systemfunctionid=#url.systemfunctionid#&contributionlineId=#URL.contributionLineId#','submitbox','','','POST','donorform')" 
						 name="apply" 
						 id="apply"	#cl#
						 value="Apply" 
						 class="button10g" 
						 style="width:160;height:25;font-size:12px">
									 
				</td>
			</tr>	
				
		
		</cfif>
					
		</table>
				
		</cfform>
		
	</td></tr>
		
</table>

</cf_divscroll>
	 
</cfoutput>	