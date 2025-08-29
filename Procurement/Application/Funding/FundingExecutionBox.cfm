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
<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_ParameterMission
	WHERE    Mission = '#URL.Mission#'
</cfquery>	

<table style="width:99%">

	<tr class="line fixrow labelmedium2" style="background-color:transparent;important!">
    				
	<td height="20" width="100%">
	
	       <table style="width:304">
		     <tr>
			 <td id="findbox" class="hide">
	
	          <cfinvoke component = "Service.Presentation.TableFilter"  
				   method           = "tablefilterfield" 
				   name             = "find"				  
				   filtermode       = "direct"
				   style            = "font:20px;height:25;width:170"
				   rowclass         = "filterrow"
				   rowfields        = "filtercontent">	
								   
				   </td>
			    </tr>
   		   </table>
							
	<cfquery name="Edition" 
	    datasource="AppsProgram" 
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	       SELECT *
	       FROM   Ref_AllotmentEdition
		   WHERE  EditionId = '#URL.EditionId#' 
	</cfquery>
	
	</td>
	
	<cfset spc = 21>		
	<cfset stc = "font-size:12px;padding-right:1px;border-top:0px solid silver;border-left:1px solid Gray;padding-bottom:2px">	
	
	<cfoutput>
	
	<td align="center" style="#stc#;background-color:CEF1F4"><cf_space spaces="#spc#">
	
	 <cf_tl id="Requested" var="tRequested">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "cola1" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Requested"
		 displaytext      = "#tRequested#<br>(a1)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
		 		
	</td>
	<cfif Edition.AllocationEntryMode lte "1">		
	
	 <td align="center" style="#stc#;background-color:D9FFD9">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Released" var="tReleased">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "cola2" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Released Funds"
		 displaytext      = "#tReleased#<br>(a2)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 
			
	<cfelse>
	
	 <td align="center" style="#stc#;background-color:D9FFD9">
	 			 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Released" var="tReleased">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "cola2" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Allocated Funds"
		 displaytext      = "#tReleased#<br>(a2)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 
			
	</cfif>
	
	<cfif url.mission neq "STL">		 
	
	 <td align="center" style="#stc#;background-color:ffffff">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Pipeline" var="tPipeline">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "colb0" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Requests in Pipeline"
		 displaytext      = "#tPipeline#<br>(b0)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 
	 
	 </cfif>
	 
	 <td align="center" style="#stc#" style="background-color:ffffaf">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Approval" var="tApproval">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "colb1" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Requests Approved"
		 displaytext      = "#tApproval#<br>(b1)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 
	 
	 <td align="center" style="#stc#" style="background-color:ffffaf">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Purchase" var="tPurchase">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "colb2" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Requests under Purchase"
		 displaytext      = "#tPurchase#<br>(b2)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 
	
	<td align="center" style="#stc#" style="background-color:eeeeaf">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Unliquid." var="tUnliquidated">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "cold" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Unliquidated Obligations"
		 displaytext      = "#tUnliquidated#<br>(d)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 		
	
	<td align="center" style="#stc#;background-color:eeeeaf">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Disbursed" var="tDisbursed">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "cole" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Disbursed Obligations"
		 displaytext      = "#tDisbursed#<br>(e)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
		 
	 </td>	 		
	
	 <!--- UN OICT only as per request of segolene --->
	<cfif url.mission eq "OICT" or url.mission eq "DM_FMS">		   
		<td align="center" bgcolor="B7DBFF" style="#stc#"><cf_space spaces="#spc#"><cf_tl id="IMIS"><br>
		 <cfif url.view eq "fund">			  
			  <a href="javascript:imis('#expenditure.accountperiod#','#url.value#','','','#url.editionid#','#url.mission#','','')">[...]</a>			
		  </cfif>
		</td>						
	<cfelse>
	
	<td align="center" style="#stc#;background-color:eeeeaf">
	 
	 <cf_space spaces="#spc#">
	 <cf_tl id="Committed" var="tCommitted">
	 
	 <cf_helpfile code = "Procurement" 
		 class            = "Execution"
		 id               = "colde" 
		 styleclass       = "labelit"
		 color            = "black"
		 name             = "Committed Funds"
		 displaytext      = "#tCommitted#<br>(d+e)"
		 mode             = "dialog"
		 display          = "Text"
		 align			  = "center">
	 </td>	 		
	
	</cfif>
	
	<cfif Parameter.FundingCheckCleared eq "0">
	<td align="center" style="#stc#;background-color:CEF1F4"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a1-b12de</td>	
	<cfelse>
	<td align="center" style="#stc#;background-color:D9FFD9"><cf_space spaces="#spc#"><cf_tl id="Balance"><br>a2-b12de</td>	
	</cfif>		
	
	<!--- added 11/6/2011 --->			
	<td align="center" style="#stc#;background-color:e8e8e8;border-right:1px solid silver"><cf_space spaces="#spc#"><cf_tl id="Execution"><br>[f]</td>	
			
	</cfoutput>
			
	</tr>
									
	<cfinclude template="FundingExecutionData.cfm">						
				
</table>