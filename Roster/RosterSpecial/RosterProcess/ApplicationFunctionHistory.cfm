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
 
<cfquery name="History" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT A.*, 
	       R.ActionCode, 
		   R.ActionSubmitted, 
		   R.OfficerUserId, 
	       R.OfficerUserLastName, 
		   R.OfficerUserFirstName, 
		   R.ActionEffective, 
	       R.ActionStatus, 
		   R.ActionRemarks, 
		   R.Created, 
		   R1.Meaning, 
		   R1.EntityClass,
		   M.MailId,
		   M.MailStatus
	FROM   ApplicantFunctionAction A INNER JOIN
           RosterAction R ON A.RosterActionNo = R.RosterActionNo INNER JOIN
           Ref_StatusCode R1 ON R.ActionCode = R1.Id AND A.Status = R1.Status LEFT OUTER JOIN
           ApplicantMail M ON A.ApplicantNo = M.ApplicantNo AND A.FunctionId = M.FunctionId AND A.RosterActionNo = M.RosterActionNo
	WHERE 
	   <!--- AND A.Status <> '0' --->
	   R1.Owner       =  '#url.Owner#'
	   AND A.ApplicantNo  =  '#URL.ID#'  
	   AND A.FunctionId   =  '#URL.ID1#'	   
	ORDER BY R.ActionSubmitted DESC, A.RosterActionNo DESC
</cfquery>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding navigation_table">

<tr><td height="5"></td></tr>

<!---
<tr><td height="20" colspan="6" align="left" bgcolor="ffffff" style="padding-left:10px">

	<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/info2.gif"
	    alt=""
	    border="0"
    	align="absmiddle">&nbsp;<font face="Verdana" color="808080">Prior Roster actions performed for this candidate</td>
</tr>
--->

<tr class="labelmedium2 line">
   	<td width="130" style="padding-left:10px"><cf_tl id="Officer"></td>
   	<TD><cf_tl id="Timestamp"></TD>
	<TD><cf_tl id="Process action"></TD>
	<td><cf_tl id="Applied"></td>
	<TD><cf_tl id="Roster Action"></TD>	
	<td align="right"><cf_tl id="Confirmation"></td>
</TR>
   
    <cfif history.recordcount eq "0">
	
	<tr class="labelmedium"><td colspan="6" align="center" style="padding-top:5"><font color="808080">No prior roster action history found</font></td></tr>
	
	</cfif>
	
    <cfoutput query="History">
 	  
     <TR class="line labelmedium2 navigation_row" style="height:20px">
     <td style="padding-left:10px">#OfficerUserFirstName# #OfficerUserLastName#</td>
     <TD>#DateFormat(ActionSubmitted, CLIENT.DateFormatShow)# #TimeFormat(ActionSubmitted, "HH:MM")#</TD>
     <TD><cfif status eq "3"><font color="008000"></cfif>#Status# - #Meaning#</font></TD>
	 <td>#DateFormat(StatusDate, CLIENT.DateFormatShow)#</b></td>
	 <TD style="padding-left:4px">#RosterActionNo#</TD>
    
	 <td style="padding-right:3px" align="right">
	 
	 	<cfif mailid neq ""> 
		
		        <table>
				<tr>
				<td>
		
				<cfif mailstatus eq "9"><font color="FF0000">Mail [not sent]<cfelse>Mail</cfif>
				
				<td>
				
				<td style="padding-left:3px">
				
				  <img src="#SESSION.root#/Images/icon_expand.gif" 
					id="d#CurrentRow#Min" alt="" border="0" 
					align="absmiddle" class="regular" style="cursor: pointer;" 
					onClick="memo('d','#CurrentRow#')">
							
					<img src="#SESSION.root#/Images/icon_collapse.gif" 
					id="d#CurrentRow#Exp" alt="" border="0" 
					align="absmiddle" class="hide" style="cursor: pointer;" 
					onClick="memo('d','#CurrentRow#')">						
				
			     </td>
				 </tr>
				 </table>
													
		</cfif>
	
	</td>
	
    </TR>
	
	<cfif actionRemarks neq "">
	
	<tr class="labelmedium2 navigation_row_child line" style="height:15px">
	    <td></td>
	    <TD colspan="5"><font color="408080">#ActionRemarks#</TD>
	</tr>
	
	</cfif>
	 
	 <cfquery name="Decision" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  R.*, A.Remarks
			FROM    ApplicantFunctionActionDecision A INNER JOIN
	                Ref_RosterDecision R ON A.DecisionCode = R.Code
			WHERE 	A.ApplicantNo = '#URL.ID#'  
			   AND  A.FunctionId = '#URL.ID1#'	
			   AND  A.RosterActionNo = '#History.RosterActionNo#'
		</cfquery>
		
		<cfloop query="decision">
		
			<tr class="labelmedium navigation_row_child">
			<td></td>
			<td></td>
			<td colspan="5">#DescriptionMemo#</td>
			</tr>
			
			<cfif Remarks neq "">
				<tr>
				<td></td>
				<td></td>
				<td colspan="5" style="padding-left:5px"><img src="#client.root#/images/join.gif" 
				  style="vertical-align:middle;"><font color="808080">#Remarks#</td>
				</tr>
			</cfif>
			
		</cfloop>
		
		<cfif mailid neq "">
					
			<cfquery name="Mail" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT M.*
			    FROM   ApplicantMail M
				WHERE  M.ApplicantNo = '#ApplicantNo#'
				AND    M.FunctionId = '#FunctionId#'
				AND    RosterActionNo = '#RosterActionNo#' 	
			</cfquery>
			
			<tr class="labelmedium navigation_row_child">
			    <td height="3" colspan="7" id="d#currentrow#" class="hide" style="padding:6px">	
				<table width="99%" align="center" bgcolor="ffffcf">
					<tr><td colspan="2" style="padding:7px;border:1px solid gray">#Mail.MailBody#</td></tr>
				</table>
				</td>
			</tr>					
					
		
		</cfif>		
				
		<!--- check here if workflow needs to be shown --->
				
		<cfif EntityClass eq "">
		
		<!--- if a workflow exists we deactivate it here --->
		
			<cfquery name="Set" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				UPDATE Organization.dbo.OrganizationObject 
			    SET    Operational = 0
				WHERE  ObjectKeyValue4 = '#rosterActionId#'				
			</cfquery>	
		
		<cfelse>
		
		    <tr><td style="padding:4px" colspan="7">
			
			<table width="98%" align="center">
			
			  <input type="hidden" 
	          name="workflowlink_#rosterActionId#" id="workflowlink_#rosterActionId#" value="ApplicantFunctionWorkflow.cfm"> 
			  
			<cfset url.ajaxid = rosteractionid>
		
			<tr><td width="96%" 
			   style="padding:4px;border:1px dotted silver" 
			   align="center" 
			   id="#rosterActionId#">
			   			
				<!--- Considerations
				
				  a. prevent the workflow if the action is superseded by a later roster action already 
				  which make the workflow obsolete : DONE
				  b. prevent change of status if the last action is still in a workflow : PENDING --->
				  
				<cfif currentrow neq "1">  
					<cfset url.terminate = "1">
				<cfelse>
					<cfset url.terminate = "0">	
				</cfif>	
				  
			    <cfinclude template="ApplicantFunctionWorkflow.cfm">
											
			</td></tr>
			
			</table></td></tr>
			
		</cfif>
		
			 
    </cfoutput>

</table>

<cfset ajaxonload("doHighlight")>
