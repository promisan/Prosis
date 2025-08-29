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
<cfparam name="url.systemfunctionid" default="">

<cfif qLines.ActionStatus eq -1>
	<!--- it is a log line --->
	<cfset cl = "_log">
<cfelse>
	<cfset cl = "">	
</cfif>

<cfoutput>

	<cfif mode neq "log"> 
	
		<td class="n_contribution  labelit" style="padding-left:20px;height:22">		
		   <cf_img icon="expand" toggle="Yes" state="close" onclick="expand_earmark('#qLines.ContributionLineId#')">	
		</td>
	
		<td class="n_contribution labelit" style="padding-right:5px">	
			
		    <cfif qLines.HeaderStatus lt "3" and qLines.ActionStatus eq "0">
		
				<cfquery name="qLinesLog" datasource="AppsProgram"
				username="#SESSION.login#"
				password="#SESSION.dbpw#">
					SELECT *
					FROM ContributionLineLog
					WHERE ContributionLineId = '#qLines.ContributionLineId#'
				</cfquery>	
				
				<cfif qLinesLog.recordcount neq 0>
				    <cf_img icon="log" onclick="expand_log('#qLines.ContributionLineId#')">
				</cfif>
			</cfif>	
		</td>
		
		<td class="n_contribution labelit" style="padding-right:5px">		
		    <cfif qLines.HeaderStatus lt "3" and qLines.ActionStatus eq "0">
			    <cfset attmode = "edit">
			<cfelse>
				<cfset attmode = "view">
			</cfif>		
				<a href="javascript:expand_attachments('#qLines.ContributionLineId#','#attmode#')"  tabindex="9999"><img style="border:0px" height="12" width="12" src="#SESSION.root#/images/Attachment.png" border="0"></a>	
		</td>
	
	<cfelse>
	
		<td class="n_contribution"></td>
		<td class="n_contribution" align="right">		
			<img src="#SESSION.root#/images/join.gif">		
		</td>
	
	</cfif>	
		
	<td class="d_contribution#cl# labelit">
	  <cftry>#Donor#
	  	<cfcatch>
		  #Dateformat(qLines.DateReceived, CLIENT.DateFormatShow)#
		  </cfcatch>
	  </cftry>
		
	</td>	
	
	<td class="d_contribution#cl# labelit">
		#Dateformat(qLines.DateEffective, CLIENT.DateFormatShow)#
	</td>	
	
	<td class="d_contribution#cl# labelit">
		#Dateformat(qLines.DateExpiration, CLIENT.DateFormatShow)#
	</td>
	
	<td class="d_contribution#cl# labelit">
	
	  <cfif qClass.Execution eq "0">	
	  
	  	#qLines.Reference# 
		
	  <cfelse>
	    
	  <a href="javascript:OpenContribution('#url.systemfunctionid#','#qLines.ContributionLineId#')">
	     <font color="0080C0">
		 #qLines.Reference# 
		 </font>
	  </a>	 
	  
	  </cfif>
		
	</td>

	<cfif qClass.Execution eq "0">		
	<td class="d_contribution#cl# labelit">
	   <a href="javascript:OpenContribution('#url.systemfunctionid#','#qLines.ParentContributionLineId#')">
	     <font color="0080C0">
		 #qLines.ParentReference#
		 </font>
		 </a>
	</td>	
	</cfif>
	
	<td class="d_contribution#cl# labelit">	
		#qLines.Fund#						
	</td>
	
	<td class="d_contribution#cl# labelit">		
		#qLines.Currency#				
	</td>
	
	<td class="d_contribution#cl#  labelit" style="text-align:right">	
		#Numberformat(qLines.Amount,"__,___.__")#		
	</td>	
		
	<cfif mode neq "log"> 
	
		<td style="padding-left:8px;padding-top:2px" align="center">
					
		    <cfif qLines.HeaderStatus lt "3" and qLines.ActionStatus eq "0">
			
			     <cf_img icon="edit" navigation="Yes" onclick="editRowDialog('#url.systemfunctionid#', '#qLines.ContributionId#','#qLines.ContributionLineId#')">
				 				    
			</cfif>
			
		</td>
		
		<td style="padding-right:4px;padding-top:1px" align="center">	
		
			<cfif qLines.HeaderStatus lt "3" and qLines.ActionStatus eq "0">
			
				<cfquery name="qCheck" 
					    datasource="AppsProgram" 
						username="#SESSION.login#"
						password="#SESSION.dbpw#">
						SELECT * 
						FROM   ProgramAllotmentDetailContribution
						WHERE  ContributionLineId = '#qLines.ContributionLineId#'		   
				</cfquery>	
				
				<cfif qCheck.recordcount eq 0>				
					<cf_img icon="delete" onclick="remove('#qLines.ContributionLineId#')">
				</cfif>	
			</cfif>
		</td>		
		
	<cfelse>
	
		<td class="n_contribution"></td>
		<td class="n_contribution"></td>	
		
	</cfif>
					
</cfoutput>