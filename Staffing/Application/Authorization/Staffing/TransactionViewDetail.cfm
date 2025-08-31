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
<cfparam name="url.action" default="0">

<cf_dialogPosition>

<cfif url.action eq "1">
	<cf_screentop height="100%" scroll="Yes" html="No">
	
</cfif>

<cfoutput>

	 <cfquery name="Document" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
	    FROM  EmployeeAction
		WHERE ActionDocumentNo = '#url.ActionReference#'		
	 </cfquery>
			 
	<cfquery name="AssignmentSel" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   PersonAssignment
		WHERE  PersonNo     = '#Document.ActionPersonNo#'
		AND    AssignmentNo = '#Document.ActionSourceNo#' 
	</cfquery>
	
	 <cfquery name="Lines" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT A.ActionId, 
		       A.ActionStatus, 
			   Ass.*, 
			   O.Mission,
			   O.OrgUnitName, 
			   E.IndexNo, 
			   E.LastName, 
			   E.FirstName, 
			   Pos.SourcePostNumber,
			   Pos.PostType,
			   Pos.OrgUnitOperational
	    FROM  EmployeeActionSource A, 		      
		      PersonAssignment Ass, 
			  Organization.dbo.Organization O, 
			  Person E, 
			  Position Pos
		WHERE A.ActionSourceNo   = Ass.AssignmentNo
		 AND  A.ActionSource     = 'Assignment'
		 AND  A.ActionDocumentNo = #url.ActionReference#
		 AND  O.OrgUnit          = Ass.OrgUnit
		 AND  E.PersonNo         = Ass.PersonNo
		 AND  Pos.PositionNo     = Ass.PositionNo
		 <!--- not enabled in case of contract PA --->
		-- AND  Ass.ContractId is NULL
		ORDER BY A.ActionStatus 
	   </cfquery>
	   
	   <cfset st = 'z'>
	   	   
	   <table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
	   
	   <cfoutput>
	   
	   <script>
	     function revert() {
			 ptoken.location('#SESSION.root#/staffing/application/authorization/staffing/TransactionCancel.cfm?actionreference=#url.ActionReference#')
		 }
	   </script>
	   
	   </cfoutput>	   
	 	  	    
	   <tr>
		
		<td align="left" height="30">
			
			<cfif assignmentSel.assignmentStatus eq "0" and url.action eq "0">
				<cf_tl id="Cancel" var="1">
				<cfoutput>
					<input class="button10s"  style="width:110" type="button" onclick="revert()" name="Delete" value="<cfoutput>#lt_text#</cfoutput>">
				</cfoutput>
			</cfif>
					
	  </td></tr>
	   
	   <tr><td width="100%">	
	   
		   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			 
			<TR class="line">
		    <TD></TD>
			<TD class="labelit"><cf_tl id="Employee"></TD>
			<TD class="labelit"><cf_tl id="PostNo"></TD>
		    <TD class="labelit"><cf_tl id="Effective"></TD>
		    <TD class="labelit"><cf_tl id="Expiration"></TD>
			</TR>
						
		    <cfloop query="Lines">
				    	 	 
				 <cfif st neq Lines.ActionStatus>
				 
			    	 <cfif Lines.ActionStatus eq "0" or Lines.ActionStatus eq "1">
					 
					 	<cfquery name="span" dbtype="query">
								SELECT *
								FROM Lines
								WHERE ActionStatus IN ('0','1')
								</cfquery>
			    		
				    	 <tr class="line">
						 <td rowspan="#span.recordcount*3#" 
						    align="left" 
							style="min-width:120;font-size:20px;padding-left:10px;border-right:1px solid silver;" 
							class="labelmedium">Proposed</td>
						 <cfset cls = "ffffcf">	
				   
				     <cfelse>
					 
					 	<cfquery name="span" dbtype="query">
								SELECT *
								FROM Lines
								WHERE ActionStatus not IN ('0','1')
								</cfquery>
			    		 
			     		 				 
					     <tr class="line">
						 <td rowspan="#span.recordcount*3#" 
						   align="left" style="min-width:120;font-size:20px;border-right:1px solid silver;padding-left:10px;" class="labelmedium">Prior						 
						 
						 </td>
						 <cfset cls = "f4f4f4">
						 
						 
					 </cfif>
					 
				 <cfelse>	 
				 
			    	  <tr>
			         			          	 
				 </cfif>
			     
				   <td colspan="1" align="left" bgcolor="#cls#" class="labelit" style="padding-left:4px">
				       <A HREF ="javascript:EditPerson('#PersonNo#')">#IndexNo# #FirstName# #LastName#&nbsp;</a></font></td>
				   </td>
								 
				   <td bgcolor="#cls#" class="labelit">
					 
					<cfinvoke component="Service.Access"  
					    method         = "position" 
					    orgunit        = "#OrgUnit#" 
					    role           = "'HRPosition'"
					    posttype       = "#PostType#"
					    returnvariable = "accessPosition"> 
			 
					 <cfif AccessPosition eq "EDIT" or AccessPosition eq "ALL">
			 		 	<A HREF ="javascript:EditPost('#PositionNo#')"><cfif sourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionNo#</cfif></a>
					 <cfelse>
					   	 <cfif sourcePostNumber neq "">#SourcePostNumber#<cfelse>#PositionNo#</cfif>
					 </cfif>
					 	  
					 </td>	 
				     <td bgcolor="#cls#" class="labelit">#Dateformat(DateEffective, CLIENT.DateFormatShow)# [#Incumbency#%]</td>
				     <TD bgcolor="#cls#" class="labelit">#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</A></TD>
					 </tr>
					 
					 <tr class="line">					   
					   <td colspan="2" bgcolor="#cls#" class="labelit" style="padding-left:4px">#FunctionDescription#</td>
					   <td colspan="3" bgcolor="#cls#" class="labelit">#OrgUnitName#</td>
					 </tr>
				     <td></td>
				 </tr>
				 
				 				 
			 <cfset st = Lines.ActionStatus>
		     
		   </cfloop> 
		        
	    </table>
   </td></tr>
    
   <!--- old code --->
   	  
   <cfparam name="URL.Lay" default="details">
   <cfparam name="URL.action" default="0">         			
			 
   <cfif URL.Lay eq "Details" and url.action eq "0">
         
	   <cfquery name="Followup" 
	    datasource="AppsEmployee" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT   *
	    FROM     EmployeeActionFlow A
		WHERE    A.ActionDocumentNo = '#url.ActionReference#'
		ORDER BY Created DESC
	   </cfquery>
	   
	   <tr><td colspan="1">
	      
	   <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	   	
	   <tr>
	    <TD class="labelit">Class</TD>
	    <TD class="labelit">Date</TD>
		<TD class="labelit">Officer</TD>
	    <TD class="labelit">Source</TD>		
		<TD class="labelit">Memo</TD>
	    </TR>
		  
	   <cfloop query="Followup">
	       
	 	 <tr>
	       <td width="10%">#ActionClass#</A></td>
	       <TD width="10%">#Dateformat(ActionDate, CLIENT.DateFormatShow)#</A></TD>
		   <TD width="20%">#OfficerFirstName# #OfficerLastName#</TD>
		   <TD width="20%">#ActionDescription#</TD>		  
	       <td width="40%">#ActionDescription#</td>
		   <td></td>
		 </tr>
		     
	   </cfloop> 
	    
	    </table>
	   
   </cfif>   
   
   <!--- ------------------ --->
   <!--- check for workflow --->
   <!--- ------------------ --->
      
   <cfquery name="Object" 
	 datasource="AppsOrganization"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT *
	 FROM   OrganizationObject O 
	 WHERE  O.EntityCode   = 'Assignment' 
	 AND    O.Operational  = 1
	 AND    O.ObjectKeyValue1 = '#Document.ActionSourceNo#' 
   </cfquery>

	<!--- JM on JUNE 30TH I changed 
			   <cfif Object.recordcount gte "1">
		 Select * from Ref_EntityMission
		Where EntityCode='Assignment'
		AND Mission='OIOS'
		AND WorkflowEnabled='1'
	----->
	
   <cfif Object.recordcount gte "1">
   
   		<cf_actionListingScript>
		<cf_FileLibraryScript>
		
		<cfoutput>													
		<input type="hidden" 
		   name="workflowlink_#Document.ActionSourceNo#" 
		   id="workflowlink_#Document.ActionSourceNo#" 		   
		   value="#SESSION.root#/Staffing/Application/Authorization/Staffing/TransactionViewDetailWorkflow.cfm">		
	   
	    </cfoutput>	
		
        <tr><td>

			<cfdiv id="#Document.ActionSourceNo#">
				<cfset url.ajaxid = Document.ActionSourceNo>
				<cfinclude template="TransactionViewDetailWorkflow.cfm">
			</cfdiv> 
						
		</td></tr>	
	   
   <cfelse>
     
   	   <!--- old mode --->
   
   	   <cfparam name="actionStatus" default="1">	
	 	 	     		  
	   <cfif ActionStatus eq "0">
	   
	   		<cfinvoke component="Service.Access"  
		   	  method    =   "staffing" 
			  orgunit   =   "#Lines.OrgUnitOperational#" 
		   	  posttype  =   "#Lines.PostType#"
		      returnvariable="accessStaffing">	
		   
		   <cfif AccessStaffing eq "EDIT" or AccessStaffing eq "ALL">
	   		  			  
			   <tr>
			     <td colspan="1" align="center" height="45">
				 
				     <table class="formspacing">
					 <tr>
					 <td><input type="button" 
					          value="Revoke" 
							  style="width:120px;height:24px;" 
							  class="button10g" 
							  onClick="processaction('8','reject','#SearchResult.ActionDocumentNo#','#SearchResult.ActionSource#')"></td>
					 <td><input type="button" 
					       value="Approve"  
						   style="width:120px;height:24px;" 
						   class="button10g" 
						   onClick="processaction('1','approve','#SearchResult.ActionDocumentNo#','#SearchResult.ActionSource#')">					 
					 </td>
					 </tr>
					 </table>
			  	  
			   </td>
			   </tr>
			   <tr><td colspan="1" class="line"></td></tr>
		      
		   </cfif>
	   
	   </cfif>        
  
    </cfif>
     
  	 </td>
   	</tr>     
   </table>
      
</cfoutput>   
  