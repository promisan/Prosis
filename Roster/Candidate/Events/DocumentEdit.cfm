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
<cf_screenTop height="100%" label="Candidate Event" scroll="yes" layout="webapp">

<cf_textareascript>

<cfoutput>

<cfparam name="URL.ID" default="{00000000-0000-0000-0000-000000000000}">	

<cfset URL.ID = "#Replace(URL.ID," ","","ALL")#"> 

<cfquery name="Object" 
 datasource="AppsOrganization"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM   OrganizationObject		
   WHERE  ObjectKeyValue4 = '#URL.ID#' 
   AND    Operational = '1'
</cfquery>

<cfif Object.EntityStatus eq "0" or Object.EntityStatus eq "">
	<cfparam name="URL.Mode" default="Edit">	
<cfelse>
    <!--- 1,9 --->
	<cfset URL.Mode =  "Finished">
</cfif>	

<cf_DialogStaffing>

<script language="JavaScript">
		
	function ask() {
	if (confirm("Do you want to save this event ?")) {
		return true 
	}	
	return false	
	}	
	
	function edit()   {	
	    window.location = "DocumentEdit.cfm?Mode=Edit&ID=#URL.ID#"
	}

	</script>

</cfoutput>

<cfquery name="Document" 
 datasource="AppsSelection"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM   ApplicantEvent		
   WHERE  EventId = '#URL.ID#' 
</cfquery>

<cfif Document.recordcount eq "0" and URl.ID neq "{00000000-0000-0000-0000-000000000000}">

	<br>
	&nbsp;Problem, invalid key
	<cfabort>

</cfif>

<cfif Document.recordcount eq "1">
	<cfset person = Document.PersonNo>
<cfelse>
	<cfset person = URL.PersonNo>
</cfif>

<cfquery name="Category" 
 datasource="AppsSelection"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM Ref_EventCategory
</cfquery>

<cfquery name="Status" 
 datasource="AppsSelection"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM Ref_PersonStatus		
</cfquery>

<cfquery name="Candidate" 
 datasource="AppsSelection"
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
   SELECT *
   FROM   Applicant		
   WHERE  PersonNo = '#Person#' 
</cfquery>

<cfif URL.Mode eq "Edit">

	<cfquery name="Check" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM ApplicantAssessment
			WHERE PersonNo = '#Person#'
			AND Owner 	= '#Document.Owner#'
	</cfquery>
	
	<cfif Check.recordcount eq "0" and Document.Owner neq "">
	
		<cfquery name="Insert" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			INSERT INTO ApplicantAssessment
			       (PersonNo, 
				    Owner,
					OfficerUserName, 
					OfficerLastName, 
					OfficerFirstName)
			VALUES ('#Person#',
			        '#Document.Owner#',
			     	'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#')
		</cfquery>
	
	</cfif>

</cfif>

<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	
	<tr><td valign="top" style="padding:20px">
	
	<cfform action="DocumentEditSubmit.cfm?ID=#URL.ID#&PersonNo=#PersonNo#" method="post">
	
	<table width="99%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				 
			   <tr  class="labelmedium">
			    <td height="20">Event date:</td>
				<td>
					<table width="100%" cellspacing="0" cellpadding="0">
					<tr>
					<td>
					
					<cfif URL.Mode eq "Edit" or URL.Mode eq "Add">
					 
					    <cfif Document.EventDate eq "">
						  <cfset evd = now()>
						<cfelse>
						  <cfset evd = Document.EventDate>  
						</cfif>
					
						 <cf_intelliCalendarDate9
							FieldName="EventDate" 
							class="regularxl"
							Default="#DateFormat(evd,CLIENT.DateFormatShow)#"
							AllowBlank="False">	
						
					<cfelse>
					
						<cfoutput>#DateFormat(Document.EventDate,CLIENT.DateFormatShow)#</cfoutput>
					
					</cfif>	
				   </td>
				   <td colspan="2" height="30" align="right">
				     <cfif Document.recordcount eq "1" and URL.Mode neq "Finished" and URL.Mode neq "Edit">
				     <input type="button" name="Edit" value="Edit" class="button10g" onClick="javascript:edit()"> 
					
					 </cfif>
					 &nbsp;  
				    				 			
				   </td></tr>
				   </table>
			   </tr>		   
			   					  			
			   <tr class="labelmedium">
			    <td height="20" width="15%">Candidate:</td>
				<td>
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
				<tr class="labelmedium">
				    <td>
					<cfoutput query="Candidate">#FirstName# #LastName# <a href="javascript:ShowCandidate('#PersonNo#')"><font color="0080C0">[see details]</font></a></cfoutput>					
					&nbsp;
					<cfoutput query="Candidate">#DateFormat(DOB,CLIENT.DateFormatShow)#</a></cfoutput>
					</td>
				</tr>	
				</table>
				</td>
			   </tr>
			   									   
			    <tr class="labelmedium">
			    <td height="20" width="100">Event category:</td>
				<td>
				<table width="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td>
				
				<cfif URL.Mode eq "Edit" or URL.Mode eq "Add">
				
					<select name="EventCategory" class="regularxl">
					   <cfoutput query="Category">
					    <option value="#Code#" <cfif Code eq "#Document.EventCategory#">selected</cfif>>#Description#</option>
					   </cfoutput>
					</select>
					
				<cfelse>
				
					<cfquery name="Category" 
					 datasource="AppsSelection"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					   SELECT *
					   FROM Ref_EventCategory
					   WHERE Code = '#Document.EventCategory#'
					</cfquery>
					
					<cfoutput>#Category.Description#</cfoutput>
						    
				</cfif>
			   </td>
			   <td width="15%" align="right">Proposed tag:</td>
				<td>
				
				<cfif URL.Mode eq "Edit" or URL.Mode eq "Add">
				
				<select name="PersonStatus" class="regularxl">
					<cfoutput query="Status">
					<option value="#Code#" <cfif #Code# eq "#Document.PersonStatus#">selected</cfif>>#Description#</option>
					</cfoutput>
				</select>
				
				<cfelse>
				
				<cfquery name="Status" 
					 datasource="AppsSelection"
					 username="#SESSION.login#" 
					 password="#SESSION.dbpw#">
					   SELECT *
					   FROM Ref_PersonStatus
					   WHERE Code = '#Document.PersonStatus#'
					</cfquery>
					
					<cfoutput>#Status.Description#</cfoutput>
				
				</cfif>
				
				</td>
				 <td width="100">Owner:</td>
				 
				 <td>
				 
				 <cfif URL.Mode eq "Edit" or URL.Mode eq "Add">
				 
				 <cfif SESSION.isAdministrator eq "Yes" or SESSION.isOwnerAdministrator neq "No">
	
					<cfquery name="Owner" 
					datasource="AppsSelection" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					   SELECT Owner
					   FROM   Ref_ParameterOwner
					   WHERE  Operational = 1
					</cfquery>
		
				<cfelse>
	
					<cfquery name="Owner" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT    DISTINCT GroupParameter as Owner
						FROM      OrganizationAuthorization
						WHERE     UserAccount = '#SESSION.acc#' 
						AND       Role IN ('CandidateClear')
						AND       GroupParameter IN (SELECT Owner FROM Applicant.dbo.Ref_ParameterOwner)
					</cfquery>
	
				</cfif>
							
				<select name="Owner" class="regularxl">
				<cfoutput query="Owner">
				<option value="#Owner#">#Owner#</option>
				</cfoutput>
				</select>
				
				<cfelse>
				
				<cfoutput>#Document.Owner#</cfoutput>
				
				</cfif>
				 
				 </td>
			   </tr>
			   </table>
			   </td></tr>
						  			 
			   <tr><td height="2"></td></tr>
			   <td colspan="2" align="center" height="90%">			   
							 					
				<cfif URL.Mode eq "Edit" or URL.Mode eq "Add">
				
					<table width="100%" height="100%" align="center" cellpadding="0" cellspacing="0">
					<tr><td style="padding-left:2px">
										
				  <cf_textarea name="eventmemo" id="eventmemo"                                            
					   height         = "300"
					   toolbar        = "full"
					   resize         = "0"
					   color          = "ffffff"><cfoutput query="Document">#EventMemo#</cfoutput></cf_textarea>
										
					</td></tr>
					</table>
										
				<cfelse>
				    
					<table width="99%" height="98%" border="0" cellspacing="0" 
						cellpadding="0" bgcolor="F6f6f6" class="formpadding">
					  <tr><td style="padding:4px;border: 1px dotted gray;font-size:14px ">
						<cfoutput query="Document">#EventMemo#</cfoutput>
					  </td></tr>
					</table>	
				
				</cfif>	
						
				</td>
			   </tr>
			   
			    <cfif URL.Mode neq "Add">
	   
				 <tr><td colspan="2" height="30">
							
				   <cfset link = "Roster/Candidate/Events/DocumentEdit.cfm?#CGI.QUERY_STRING#">
					
				   <cf_ActionListing 
				    EntityCode       = "EntCandidate"
					EntityClass      = "Standard"
					EntityGroup      = ""
					EntityStatus     = ""
					OrgUnit          = ""
					PersonNo         = "#Person#"
					ObjectReference  = "#Person#"
					ObjectKey1       = "#Person#"
				    ObjectKey4       = "#Document.EventId#"
					ObjectURL        = "#link#">
								   	   
				   </td></tr>
				  
				   <tr>
				  
				   <td width="100%" colspan="2" height="100%">
				 
				   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
				   	   
			   </cfif>
			   			   			   
			   <cfif URL.Mode eq "Edit" or URL.Mode eq "Add">
			   
			   <tr class="line"><td  height="30" colspan="2" align="center">
		  	    	<input class="button10g" type="reset"  name="Reset" value="Reset">
					<input class="button10g" type="button" name="Close" value="Close" onclick="window.close()">	
					<input class="button10g" type="submit" name="Submit" value="Save">				   
			       </td>
			   </tr>	 
			   
		       </cfif>				  	   
		      	  		
	   <cfif URL.Mode neq "Edit">
	        </table>		   
	   </cfif>
	   
	   </cfform>
	   
	</table>
	</td></tr>
	</table>

<cf_screenbottom layout="innerbox">	

<cfset ajaxonload("initTextArea")>
