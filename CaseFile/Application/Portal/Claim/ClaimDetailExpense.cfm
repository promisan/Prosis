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

<cfparam name="url.objectId" default="">
<cfparam name="url.mode" default="regular">
<cfparam name="url.box" default="costcontainer">
		  
<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     *
	FROM       OrganizationObject
	WHERE      ObjectId = '#URL.ObjectId#' OR ObjectKeyValue4 = '#URL.ObjectId#' 
</cfquery>

<cfif Object.Recordcount gte "1">
	
	<cfset objectId = Object.ObjectId>
	
	<cfquery name="Listing" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   C.*, L.*, 
			         U.FirstName AS OwnerFirstName, 
					 U.LastName AS OwnerLastName,
					 GL.GLAccount AS PayrollGLAccount
	       FROM      OrganizationObjectActionCost C LEFT OUTER JOIN
                     System.dbo.UserNames U ON C.OwnerAccount = U.Account LEFT OUTER JOIN
                     Accounting.dbo.TransactionLine L ON C.ObjectCostId = L.ReferenceId LEFT OUTER JOIN
                     Employee.dbo.PersonGLedger GL ON U.PersonNo = GL.PersonNo 
			WHERE    C.ObjectId = '#ObjectId#'							
			ORDER BY DocumentDate
	</cfquery>	
	
	<cfif url.mode eq "regular">
	  <cfset col = 12>
	<cfelse>
	  <cfset col = 11>  
	</cfif>
			
	<table width="100%" align="center"  cellspacing="0" cellpadding="0">
			
		<cfif Listing.recordcount gt "0">
				
		<tr>
		<td height="21" width="25"></td>
		<td height="21" width="25"></td>
		<td height="21" width="25"></td>
		<td></td>
		<td><cf_tl id="Date"></td>		
		<td><cf_tl id="Description"></td>
		<td><cf_tl id="Name"></td>		
		<td><cf_tl id="Qty"></td>
		<td><cf_tl id="Curr">.</td>
		<td align="right"><cf_tl id="Amount"></td>		
		<td width="10"></td>
		</tr>
		<tr><td height="1" colspan="<cfoutput>#col#</cfoutput>" bgcolor="C0C0C0"></td></tr>	
		
		<cfelse>
		
		<tr><td colspan="<cfoutput>#col#</cfoutput>" align="center"><b><cf_tl id="No expenditure recorded"></b></td></tr>
		
		</cfif>
		
		<cfset row = 0>
		<cfset pst = 0>		
				
	    <cfoutput query="Listing">
		 
				 
				<tr id="r#row#">
				
				<td align="center" width="30">
				
				 <!--- invoiced to GL --->
				 <cfif ReferenceId neq "">						 				 
				 	
				     <img src="#Client.VirtualDir#/Images/paid.gif" 
				   	 alt="invoiced" 
					 border="0"
					 align="absmiddle">							
									 
				 <cfelseif ActionStatus eq "1">
				 
					 <img src="#Client.VirtualDir#/Images/check_mark2.gif" 
					 alt="cleared" border="0" align="absmiddle">
					 
				 </cfif>
				
				</td>
												
				<TD height="23" width="20" align="center"></TD>				
				<td width="20"></td>				
				<td width="20"></td>
				<td width="140">#dateformat(DocumentDate,CLIENT.DateFormatShow)# 
				<cftry>#timeformat(DocumentDate,"HH:MM")#<cfcatch></cfcatch></cftry></td>	
				<td width="25%">#Description#</td>
				<td width="15%">#OwnerFirstName# #OwnerLastName#</td>											
				<td width="120">#DocumentQuantity#<cfif DocumentType eq "work">h @ #numberFormat(documentrate,"__.__")#</cfif></td>	
				<td width="40">#DocumentCurrency# </td>		
				<td width="10%" align="right">#numberformat(InvoiceAmount,"__,__.__")#</td>
				<td width="30" align="center"></td>
				</tr>					
									
				<tr><td colspan="3"></td><td colspan="#col-3#">			
					
					<cf_filelibraryN
						DocumentPath="#Object.EntityCode#"
						SubDirectory="#objectcostid#" 
						Filter=""	
						color="F4FBFD"			
						Width="100%"						
						inputsize = "340"
						format="PDF"
						loadscript="No"
						insert="no"
						Remove="no">	
					
					</td>
				</tr>			
				
				<cfif currentrow neq recordcount>
					<tr><td height="1" colspan="#col#" bgcolor="d0d0d0"></td></tr>		
				</cfif>
																				
		</cfoutput>
				
	</table>

</cfif>

