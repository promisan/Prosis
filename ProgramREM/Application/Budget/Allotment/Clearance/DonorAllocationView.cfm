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

<!--- show all donor lines in base currency with 
     line action status = 1
	 not earmarked or earmarked within the scope of this program
	 effective period overlaps with the period of the edition
	 fund of the line 	 
 --->
 
<cf_DialogREMProgram>

<cfparam name="URL.scope" default="">
<cfparam name="URL.ContributionLineId" default="">

<cf_screentop height="100%" 
     line="no" 
	 jquery="Yes" 
	 label="Contribution Allocation" 
	 scroll="yes" 
	 close="parent.ColdFusion.Window.destroy('mydialog',true)"
	 bannerforce="Yes" 
	 layout="webapp" 
	 banner="green">
   	
<table width="95%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfoutput>

 <cfquery name="get" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
		SELECT     P.Mission, 
		           P.ProgramCode, 
				   P.ProgramName,
		           PA.Fund, 
				   PA.ObjectCode,
				   PA.Amount,
				   Per.Period, 
				   Per.DateEffective, 
				   Per.DateExpiration
		FROM       ProgramAllotmentDetail PA INNER JOIN
                   Program P ON PA.ProgramCode = P.ProgramCode INNER JOIN
                   Ref_AllotmentEdition R ON PA.EditionId = R.EditionId INNER JOIN
                   Ref_Period Per ON R.Period = Per.Period
		WHERE      PA.TransactionId = '#url.transactionid#'	 
</cfquery> 	 

<cfif get.recordcount eq "0">

	<!--- multiple period : CMP mode --->
	<tr><td colspan="2" align="center" class="labelmedium"><font color="FF0000">Option is not supported for continuous period, please contact your administrator.</td></tr>
	<cfabort>

</cfif>

<tr>
	<td height="10" colspan="2">
	
		<table width="100%" align="center">
				    
			<tr class="labelit line">
			    <td style="width:130;padding-left:4px">Program: <b>#get.ProgramCode#</b></td>
			    <td style="width:130;padding-left:10px">Allocation: <b>#get.Period#</b></td>
				<td style="width:80;padding-left:10px">Fund: <b>#get.Fund#</b></td>
					
			<cfquery name="Object" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
				FROM Ref_Object
				WHERE Code = '#get.ObjectCode#'
			</cfquery>
			
				<td style="padding-left:80px"><cf_tl id="Object">: <b>#Object.Code# #Object.Description#</b></td>				
				<td style="padding-left:100px"><cf_tl id="Amount">:</td>
				<td style="font-size:19px" align="right"><b>#numberformat(get.Amount,",.__")#</b></td>
			</tr>	
			
		</table>
	
	</td>
</tr>

</cfoutput>

<tr><td height="5" colspan="1">

	<cf_presentationscript>
	
		<cfinvoke component = "Service.Presentation.TableFilter"  
		   method           = "tablefilterfield" 
		   name             = "linesearch"				  
		   filtermode       = "direct"
		   style            = "font:18px;height:25;width:120"
		   rowclass         = "clsdonor"
		   rowfields        = "ccontent"
		   displayValue		= "block">			
	
	</td>
	
	<td colspan="1" style="padding-right:4px" align="right" class="labelmedium"><cf_tl id="Available Contributions"></td>
	
</tr>	
	
<tr><td colspan="2" class="line"></td></tr>

<tr><td colspan="2" valign="top" height="100%" width="100%">
	
	<form name="donorform" id="donorform" style="height:100%">
	
		<table width="100%" border="0" height="100%">
		
		<tr><td height="100%" valign="top">
		
		    <cf_divscroll style="height:100%">
	
			<table width="100%" cellspacing="0" cellpadding="0" class="navigation_table formpadding">
				
			<tr class="labelit line">	
			    <td height="20" width="30"></td>
				<td width="30%"><cf_tl id="Contribution"></td>
				<td width="90"><cf_tl id="Expiration"></td>
				<td width="100" align="right"><cf_tl id="Original"></td>
				<td width="80"  align="right" style="padding-top:3px"><cf_tl id="Overdraw"></td>
				<td width="80"  align="right" style="padding-top:3px"><cf_tl id="Adjusted"></td>
				<td width="100" align="right"><cf_tl id="Amount"></td>
				<td width="100" align="right"><cf_tl id="Allocated"></td>
				<td width="100" align="right"><cf_tl id="Balance"></td>
				<td width="100" align="right"><cf_tl id="Allocation"></td>	
			</tr>
							
			 <cfset processmode = "entry"> 		 
			 <cfset total = 0> 
			 <cfinclude template="DonorAllocationViewLines.cfm">	
				 
			</td></tr>	
			
			</table>	
		
		    </cf_divscroll>
		
		</td>
		
		</tr>
	
	    <cfif get.Amount eq "">
			<cfset base = "0">
		<cfelse>
			<cfset base = get.Amount>
		</cfif>
	
		<cfif abs(total-base) lt 0.1>
			<cfset cl = "">				
		<cfelse>
			<cfset cl = "hide">		
		</cfif>
	 
	 	<cfif processmode neq "Amendment">
		
			<tr><td colspan="2" class="line"></td></tr>		
							
			<tr>
						
			  <td colspan="2" height="30" style="padding-left:20px">
			  
			  	    <cfoutput>
			  
			  		<table class="formpadding">					
						<tr>
						
						<td style="padding-left:10px">
									<input class="radiol" type="checkbox" id="applytoall" name="applytoall"  value="1">
						</td>	
						<td class="labelmedium" style="padding-left:10px;padding-right:10px">Apply to all pending lines</td>
							
						<td>
																			  
							<input type="button"
						    	 onclick="ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Allotment/Clearance/DonorAllocationSubmit.cfm?transactionid=#url.transactionid#&processmode=undo&contributionlineId=#URL.contributionLineId#','submitbutton','','','POST','donorform')" 
								 name="Undo" 
								 value="Remove" 
								 class="button10g" 
								 style="width:140;height:25">
																				 
						</td>
												
						<td id="submitbutton">
												
							<table cellspacing="0" cellpadding="0" id="apply" class="#cl#">
							
							<tr>							
														
							<td>
																						  
								<input type="button"
							    	 onclick="ColdFusion.navigate('#session.root#/ProgramREM/Application/Budget/Allotment/Clearance/DonorAllocationSubmit.cfm?transactionid=#url.transactionid#&processmode=apply&contributionlineId=#URL.contributionLineId#','submitbutton','','','POST','donorform')" 												
									 value="Apply" 		
									 class="button10g" 										 
									 style="width:140;height:25">
								 
							</td>	
												
							</tr>
							</table>
						
						</td>
												
					</tr>					
					</table>	
					
					</cfoutput>
					 													 
			  </td>			  
			</tr>
									
		 </cfif>	
				
	</table>
	
	</form>
	
	</td></tr>
	
</table>	
	 
	  