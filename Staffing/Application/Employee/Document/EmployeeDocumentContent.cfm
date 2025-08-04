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

<cfparam name="url.status" default="0">
<cfparam name="url.id"    default="">
<cfparam name="Object.ObjectId"    default="">

<cfif Object.ObjectId neq "">
	
	<cfquery name="get" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    A.EmployeeNo, A.IndexNo, DC.PersonNo
		FROM      Vacancy.dbo.DocumentCandidate AS DC INNER JOIN
		          Applicant.dbo.Applicant AS A ON DC.PersonNo = A.PersonNo
		WHERE     DC.DocumentNo = '#Object.ObjectKeyValue1#' 
		AND 	  DC.PersonNo = '#Object.ObjectKeyValue2#'
	</cfquery>
	
	<cfif get.EmployeeNo neq "">
	
		<cfset url.id = get.EmployeeNo>
		
	<cfelse>
	
		<table><tr class="labelmedium"><td style="padding-top:10px">Candidate does not have a staff profile yet.</td></tr></table>	
	
	</cfif>
	
<cfelse>

	<cfinclude template="EmployeeDocumentContentScript.cfm">	
	
</cfif>	
	
<!--- Query returning search results --->
<cfquery name="Parameter" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Parameter
</cfquery>

<cfif URL.Status eq "0">
      <cfset condition = "">
<cfelseif URL.Status eq "1">
      <cfset condition = "AND (L.DateExpiration > #now()# or L.DateExpiration is NULL)">
<cfelse>	  
	  <cfset condition = "AND L.DateExpiration < #now()#">
</cfif>

<!--- Query returning search results --->

<cfquery name="Holder" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    DISTINCT DependentId
    FROM      PersonDocument
	WHERE     PersonNo = '#URL.ID#' 
	ORDER BY  DependentId	
</cfquery>

	<table width="97%" align="center">
	  <tr>
	  
 	    <cfoutput>
		
	    <td style="padding:10px 0 10px 30px;height:44px;" class="labelmedium">
	        
	       <img src="<cfoutput>#session.root#/Images/UploadDocuments.png</cfoutput>" height="60" width="60" style="float:left;padding-right: 10px;">
	        <h1 style="float:left;color:333333;font-size:28px;font-weight:200;padding-top:10px;">Register and Upload <strong>Documents</strong></span></h1>
	        <p style="clear: both; font-size: 15px; margin: 1% 0 0 1%;">Declare and attach a copy of document that we require (passport, laissez passer, medical clearance, tests, drivers license).</p>
	        <div class="emptyspace" style="height: 13px;"></div>
	        
		    <table><tr class="labelmedoum2"><td></td>
			<td><input type="radio" class="radiol" name="Status" value="0" onClick="reloadDocument('#url.id#','0')" <cfif URL.Status eq "0">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "0"><b></cfif><cf_tl id="All"></td>
			<td><INPUT type="radio" class="radiol" name="Status" value="1" onClick="reloadDocument('#url.id#','1')" <cfif URL.Status eq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "1"><b></cfif><cf_tl id="Current"></td>
			<td><INPUT type="radio" class="radiol" name="Status" value="2" onClick="reloadDocument('#url.id#','2')" <cfif URL.Status eq "2">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "2"><b></cfif><cf_tl id="Expired"></td>
			</tr></table>
		</td>
					
	    <td align="right" valign="bottom" style="padding-bottom:5px;padding-right:45px">
			<cf_tl id="Add" var="vAdd">
			<input type="button" value="#vAdd#" class="button10g" onClick="issuedocument('#URL.ID#')">&nbsp;
	    </td>
		
		</cfoutput>
		
	  </tr>
	  
	  <tr>
	  <td width="98%" colspan="3" align="center">
	  
		  <table class="formpadding navigation_table" width="94%" align="center">
				
			<TR class="labelmedium2 line fixrow fixlengthlist">
			    <td height="20" align="center"></td>
				<TD><cf_tl id="Document"></TD>		    	
				<td><cf_tl id="Issued"></td>
			    <td><cf_tl id="Effective"></td>
				<TD><cf_tl id="Expiration"></TD>			
				<TD><cf_tl id="Officer"></TD>	
			</TR>
			
		<cfset last = '1'>
		<cfset row = 0>
		
		<cfoutput query="Holder">	
			
			<cfif DependentId neq "">
					
				<cfquery name="Dependent" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
				    FROM   PersonDependent
					WHERE  PersonNo    = '#URL.ID#' 
					AND    DependentId = '#dependentid#'							
				</cfquery>		
				
				<tr class="line labelmedium"><td colspan="7" style="padding-left:20px;font-size:18px" height="30">#Dependent.FirstName# #Dependent.LastName#</td></tr>
							
			</cfif>
			
			<cfquery name="Listing" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT *
			    FROM   PersonDocument L INNER JOIN Ref_DocumentType T ON L.DocumentType = T.DocumentType 
				WHERE  L.PersonNo = '#URL.ID#' 
				<cfif dependentid eq "">
				AND    L.DependentId is NULL 
				<cfelse>
				AND    L.DependentId = '#dependentid#' 
				</cfif>		
				#preserveSingleQuotes(condition)#		
				ORDER BY T.Listingorder, L.DocumentType, L.DateEffective DESC  
			</cfquery>
			
			<cfloop query="Listing">
			
			<cfset row = row+1> 
			
			<cfif DateExpiration lt now() and DateExpiration neq "">
			
				<tr bgcolor="FAE2DA" class="navigation_row labelmedium line fixlengthlist">
				<td align="center" style="padding-top:3px">
				
					<cfif enableRemove eq "1">
				
						<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
						
					<cfelse>
					
						<cfinvoke component  = "Service.Access" 
					      method     = "contract"
						  personno   = "#URL.ID#"	
						  role       = "'ContractManager','PayrollOfficer'"		
						  returnvariable = "access">
					
						<cfif access eq "EDIT" or access eq "ALL">
									
							<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
						
						</cfif>
					
					</cfif>	
				
				</td>	
							
			<cfelse>
			
			<TR class="navigation_row labelmedium line fixlengthlist" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F9F9F9'))#">
			
				<td align="center" style="padding-top:3px">	
							
					<cfif enableRemove eq "1">
				
						<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">
						
					<cfelse>
					
						<cfinvoke component  = "Service.Access" 
						      method     = "contract"
							  personno   = "#URL.ID#"	
							  role       = "'ContractManager','PayrollOfficer'"		
							  returnvariable = "access">
						
							<cfif access eq "EDIT" or access eq "ALL">									
								<cf_img icon="edit" navigation="yes" onClick="edit('#URL.ID#','#DocumentId#')">						
						    </cfif>
					
					</cfif>	
					
				</td>	
				
			</cfif>	
							
				<cfparam name="attNo" default="0">
				
				<TD><a href="javascript:edit('#URL.ID#','#DocumentId#')">#Description# : #DocumentReference#</a></TD>				
				<td>#IssuedCountry#</td>
				<td>#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
				<td>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#</td>			
				<td>#OfficerLastName#</td>
			
			</tr>
			
			<cfif remarks neq "">
			
			<tr>				
				<td></td>
				<TD colspan="5">#Remarks#</TD>
			</tr>
			
			</cfif>
		
			<cf_filelibraryCheck    	
					DocumentPath="#Parameter.DocumentLibrary#"
					SubDirectory="#PersonNo#" 
					Filter="#documenttype#_#left(DocumentId,8)#">
						
			<cfif files gte "1">
				
				<tr>
				
					<td></td>
									
					<td colspan="5">
											  
					  <cf_filelibraryN
							DocumentPath="#Parameter.DocumentLibrary#"
							SubDirectory="#PersonNo#" 
							Filter="#documenttype#_#left(DocumentId,8)#"
							Insert="no"
							box="b#currentrow#"
							Remove="no"
							Listing="yes">							
						
					</td>
				
				</tr>
			
			</cfif>		
					
			</cfloop>
		
		</cfoutput>
		
		</TABLE>
	
	</td>
	</tr>
	
	</table>