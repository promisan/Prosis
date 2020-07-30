
<cfparam name="url.status" default="0">
<cfparam name="url.id"    default="">

<cfinclude template="EmployeeDocumentDetailScript.cfm">

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
	        
		    <table><tr><td></td>
			<td><input type="radio" class="radiol" name="Status" value="0" onClick="reloadDocument('#url.id#','0')" <cfif URL.Status eq "0">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "0"><b></cfif><cf_tl id="All"></td>
			<td><INPUT type="radio" class="radiol" name="Status" value="1" onClick="reloadDocument('#url.id#','1')" <cfif URL.Status eq "1">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "1"><b></cfif><cf_tl id="Current"></td>
			<td><INPUT type="radio" class="radiol" name="Status" value="2" onClick="reloadDocument('#url.id#','2')" <cfif URL.Status eq "2">checked</cfif>></td><td style="padding-left:4px;padding-right:10px" class="labelmedium"><cfif URL.Status eq "2"><b></cfif><cf_tl id="Expired"></td>
			</tr></table>
		</td>
					
	    <td align="right" valign="bottom" style="padding-bottom:5px;padding-right:28px">
			<cf_tl id="Add" var="vAdd">
			<input type="button" value="#vAdd#" class="button10g" onClick="javascript:issuedocument('#URL.ID#')">&nbsp;
	    </td>
		
		</cfoutput>
		
	  </tr>
	  
	  <tr>
	  <td width="96%" colspan="3" align="center">
	  
		  <table class="formpadding navigation_table" width="94%" align="center">
				
			<TR class="labelmedium line fixrow">
			    <td style="min-width:60px" height="20" align="center"></td>
				<TD width="60%"><cf_tl id="Document"></TD>		    	
				<td style="min-width:120px"><cf_tl id="Issued"></td>
			    <td style="min-width:90px"><cf_tl id="Effective"></td>
				<TD style="min-width:90px"><cf_tl id="Expiration"></TD>			
				<TD style="min-width:150px"><cf_tl id="Officer"></TD>	
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
			
				<tr bgcolor="FAE2DA" class="navigation_row labelmedium line">
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
			
			<TR class="navigation_row labelmedium line" bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F9F9F9'))#">
			
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
				
					<td align="center" valign="top">
					<!---
					<img src="#SESSION.root#/Images/join.gif" alt="" border="0" align="middle">
					--->
					</td>
					<td></td>
					<td colspan="4">
											  
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