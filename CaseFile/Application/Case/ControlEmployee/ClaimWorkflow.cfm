
		<cfquery name="Claim" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  Claim
			WHERE ClaimId = '#URL.ajaxid#'	
		</cfquery>
		
		
		
		<cfquery name="Object" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM  OrganizationObject
			WHERE ObjectKeyValue4 = '#URL.ajaxid#'	
		</cfquery>

		<cfif Claim.HistoricClaim eq "0" or Object.recordcount eq "1">
		
			<cfif claim.recordcount eq "1">
			
				<cfquery name="Class" 
				datasource="AppsCaseFile" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    SELECT *
				    FROM  Ref_ClaimTypeClass
					WHERE ClaimType = '#claim.claimtype#'
					AND   Code      = '#claim.claimtypeclass#'			
				</cfquery>
				
				<cfif class.entityclass neq "">
		
					<cfset link = "CaseFile/Application/Case/CaseView/CaseView.cfm?claimid=#Claim.claimId#">
					
					<cf_ActionListing 
						EntityCode       = "Clm#Claim.ClaimType#"
						EntityClass      = "#class.entityclass#"
						EntityGroup      = ""
						EntityStatus     = ""
						Mission          = "#claim.mission#"
						OrgUnit          = "#claim.orgunit#"
						PersonNo         = "" 
						PersonEMail      = "#Claim.ClaimantEmail#"
						ObjectReference  = "Insurance Claim: #Claim.DocumentNo#"
						ObjectReference2 = ""
						ObjectKey4       = "#Claim.ClaimId#"
						ObjectURL        = "#link#"
						Show             = "Yes"
						AjaxId           = "#Claim.ClaimId#"
						Toolbar          = "#tool#"
						Framecolor       = "ECF5FF">
					
				  </cfif>	
									
			</cfif>	
			
		<cfelse>
			
				<cfquery 
					name="qStatus" 
					datasource="AppsCaseFile" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  *
						FROM         Ref_Status
						Where statusClass='clm'
						order by ListingOrder
				</cfquery>

			<cfoutput>
			
					<table width="97%"
				       border="1"
				       cellspacing="0"
				       cellpadding="0"
					   class="formpadding"
				       align="center"
				       bordercolor="C0C0C0">
	   
					   <tr><td colspan="2" height="6"></td></tr>

					<cfform action="#SESSION.root#/CaseFile/Application/Case/ControlEmployee/ClaimHistoricSubmit.cfm?ClaimId=#Claim.ClaimId#" 
					    method="POST" 
						name="historic">						   
					
					    <tr bgcolor="FFFFFF">
							<td  height="30" width="10%"><cf_tl id="Status">:</td>
							<td  height="30">
						    <select name="status">
						      <cfloop query="qStatus">
							  	<cfif #qStatus.Status# eq #claim.ActionStatus#>
								    <option value="#qStatus.Status#" selected>#qStatus.Description#</option>
								<cfelse>
								    <option value="#qStatus.Status#">#qStatus.Description#</option>
								</cfif>
							  </cfloop>
							</select>				
			
							</td>
						</tr>
						<tr bgcolor="FFFFFF">
							<td height="30" colspan="4" align="center">
							   <input type="submit" 
						        value="Save" 
								class="button10s" 
								style="width:120">
							</td>
						</tr>
		
				</cfform>
				
			</table>	
	
		</cfoutput>	

					
		</cfif>
