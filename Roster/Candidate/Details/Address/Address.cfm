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
<cfparam name="url.applicantno" default="0">
<cfparam name="url.section" 	default="">
<cfparam name="url.entryScope"  default="Backoffice">
<cfparam name="url.owner" 	    default="">
<cfparam name="url.source" 	    default="Manual">
<cfparam name="url.mission" 	default="">

<!--- Query returning search results --->

<cfquery name="Search" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     A.*,  
		           B.Name, 
				   R.Description as AddressTypeDescription
		FROM       ApplicantAddress A, 
		           System.dbo.Ref_Nation B, 
			       Employee.dbo.Ref_AddressType R
		WHERE      PersonNo        = '#URL.ID#'
		AND        A.Country       = B.Code
		AND        A.AddressType   = R.AddressType
		AND        A.ActionStatus != '9'
		ORDER BY   A.AddressType DESC
</cfquery>

<table width="100%" align="center">
 
   <tr>
    	
	<cfif url.entryscope eq "backoffice">
	
		<td style="height:20;font-size:30px;padding-left:0px" class="labellarge">
	
		<table width="100%">
		
			<tr><td colspan="2" class="labelmedium" style="font-size:25px;padding-left:14px"><cf_tl id="Address and Contacts"></td></tr>	
		
		</table>
		
		</td>
	
	<cfelse>
	
		<td style="height:20;font-size:30px;padding-left:0px" class="labellarge">
	
		<table width="100%">
		
			<tr><td colspan="2" style="padding-left:14px"><cf_navigation_header1 toggle="Yes"></td></tr>	
		
		</table>
		
		</td>
		
	</cfif>	
		
   </tr>
   
   <tr>	
    <td colspan="2" class="labellarge" style="padding-top:9px;padding-left:30px">
	
	    <cfoutput>
		
			<cf_ProfileAccess 
				Scope   = "#url.entryscope#"
				Source  = "#url.source#"
				Owner   = "#url.owner#"
				Section = "#url.section#">				
													   		
	        <cfif accessmode eq "EDIT">			
				<cf_tl id="Add Contact" var="1">
				<a href="javascript:Prosis.busy('yes');ptoken.navigate('#SESSION.root#/Roster/Candidate/Details/Address/AddressEntry.cfm?entryscope=#url.entryscope#&mission=#url.mission#&owner=#url.owner#&section=#url.section#&id=#url.id#','addressbox')"><font color="0080C0"><cf_tl id="#lt_text#"></font></a>			
			</cfif>
			
		</cfoutput>
		
    </td>
   </tr>
 
<tr>    

	<td width="100%" colspan="2" style="padding-left:20px;padding-top:4px" align="center">
	  
		<table border="0" cellpadding="0" cellspacing="0" width="100%" class="formpadding navigation_table">
				
		<TR class="line labelmedium2">		   
		    <td width="1%"></td>
			<TD width="40%"><cf_tl id="Address"></TD>	
			<TD width="10%"><cf_tl id="ZIP"></TD>		
			<TD width="15%"><cf_tl id="Country"></TD>			
			<TD width="25%"><cf_tl id="Contact"></TD>
		</TR>
				
		<cfset last = '1'>
		
			<cfoutput query="Search" group="AddressTypeDescription">
			
			<TR>
											
				<td colspan="7" style="padding-left:20px;height:40px;padding-top:4px;font-size:22px" class="labellarge">#AddressTypeDescription#</td>			
								
			</TR>
			
				<cfoutput>
				
				<TR class="navigation_row labelmedium2">
										
					<td align="right" style="padding-left:20px;padding-top:3px;padding-right:5px">
					    
					   <cfif source eq "Manual">		
						   <cfif accessmode eq "EDIT">
						   		<cf_tl id="Edit" var="1">
						       	<cf_img icon="edit" tooltip="#lt_text#" navigation="Yes" onclick="Prosis.busy('yes');ptoken.navigate('#SESSION.root#/Roster/Candidate/Details/Address/AddressEdit.cfm?applicantno=#url.applicantno#&owner=#url.owner#&mission=#url.mission#&section=#url.section#&entryScope=#url.entryScope#&ID=#URL.ID#&ID1=#AddressId#','addressbox')">	  
							</cfif>
						</cfif>
						
					</td>				
							
					<td>#Address1#, #City#</td>		
					<td>#AddressPostalCode#</td>				
					<td>#Name#</td>					
					<TD>#Contact# #ContactRelationship#</TD>
					
				</TR>
				
				<TR class="navigation_row_child labelmedium2 line" style="height:0px">
						
					<td></td>				
					<td colspan="4" align="left">
					<cfif TelephoneNo is not "">
					  <font size="2"><cf_tl id="Tel">:</font>&nbsp;#TelephoneNo# </b>
					</cfif>
					<cfif FaxNo is not "">
					  <font size="2"><cf_tl id="FaxNo"></font>:&nbsp;#FaxNo#</font>
					</cfif>
					<cfif Cellular is not "">
					  <font size="2"><cf_tl id="Tel">/<cf_tl id="Cel"></font>:&nbsp;#Cellular# </b>
					</cfif>
					</td>
					
				</TR>
				
				</cfoutput>
			
			</cfoutput>
		
		</table>
		
	</td>
</tr>

</table>

<cfset ajaxonload("doHighlight")>
	
