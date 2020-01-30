
<cfif #URL.action# neq "delete">

		<!--- validation of inputted values --->
		
		<cfset msg = "">
			
		<cfset dateValue = "">
		
		
		
					
		
		
		<cfif #URL.Comments# eq  "">
		
			<cfset msg = "#msg# - Please enter The comments">
		
		</cfif>	
						<!---
		<cfif #URL.Description# eq "">
		
			<cfset msg = "#msg# - Please Enter a Description">
					
		</cfif>	
							--->
		<cfif #msg# neq "">
		
			<cfoutput><table width="100%" align="center">
			<tr bgcolor="red">
			<td align="center" style="border: 1px solid Gray;">
			<font color="FFFFFF">#msg#</td>
			</tr>
			</cfoutput>
		
		<cfelse>
			
			<cfif URL.action eq "insert"> 
			
				<cfquery name="Verify" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  ClaimAuditline
				where claimidauditid ='#URL.claimidauditid#'
				and seq_num ='#URL.seq_num#'
				
				</cfquery>
				<!---and seq_num ='#URL.seq_num#'
				
				--->
				
			
			   <cfif #Verify.recordCount# is 1>
			   
				<table width="100%" align="center">
				<tr bgcolor="red">
				<td align="center" style="border: 1px solid Gray;">
				<font color="FFFFFF">A record with this information has been registered already!</td>
				</tr>
				<cfabort>
							   				 			  
			   <cfelse>
			   <!---
			   SELECT max(seq_num)+1 as max_seq_num
				FROM  ClaimAuditline
				where claimidauditid ='#URL.claimidauditid#'
				old query
			   --->
			   
			   <cfquery name="getmax" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT     MAX(ISNULL(ADTL.seq_num, 0)) + 1 AS max_seq_num
					FROM         ClaimAuditLine AS ADTL RIGHT OUTER JOIN
                      ClaimAudit AS ADT ON ADTL.ClaimidAuditid = ADT.ClaimidAuditid
					WHERE     (ADT.ClaimidAuditid = '#URL.claimidauditid#')
				
				</cfquery>
				<cfoutput query ="getmax"> 
			   <cfset max_seq_number =getmax.max_seq_num>
			   </cfoutput>
					<!---
					SELECT     ClaimidAuditid, seq_num, Comments, Description, Supp_Tvcv_num, created, updated, userid, Supp_rec_num
FROM         ClaimAuditLine AS A
					--->
					<cfquery name="Insert" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ClaimAuditLine
					         (claimidauditid,
							 Comments,
							 Description,
							 Supp_tvcv_num,
							 Supp_rec_num,
							 created,							
							 updated,
							 userid,
							 addt_amount,
							 seq_num
							 )
					  VALUES ('#URL.claimidauditid#',
					          '#URL.Comments#', 
							  '#URL.Description#',
							  '#URL.Supp_tvcv_num#',
							  '#URL.Supp_rec_num#',
							   getdate(),
					    	  getdate(),		  
						  	  '#SESSION.acc#',
							  '#URL.addt_amount#',
							  #max_seq_number#
							  ) 
							  </cfquery>
					  
					  <input type="hidden" name="action" value="1">
															  
			    </cfif>		  
			           
			<cfelse>
			
				<cfquery name="Verify" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT *
				FROM  ClaimAuditline
				where claimidauditid ='#URL.claimidauditid#'
				AND seq_num ='99'
				
				</cfquery>
			<!---
			AND seq_num ='#URL.seq_num#'
			--->
			   <cfif #Verify.recordCount# is 1>
			   
				   <table width="100%" align="center">
					<tr bgcolor="red">
					<td align="center" style="border: 1px solid Gray;">
					<font color="FFFFFF">A record with this information has been registered already!</td>
					</tr>
				   </table>	
				   <cfabort>
			  
			   <cfelse>
			   <cfquery name="getmax" 
				datasource="AppsTravelClaim" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT max(seq_num)+1 as max_seq_num
				FROM  ClaimAuditline
				where claimidauditid ='#URL.claimidauditid#' 
				
				
				</cfquery>
				<cfoutput query ="getmax">
			   <cfset max_seq_number =getmax.max_seq_num>
			   </cfoutput>
			   <cfquery name="Insert" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO ClaimAuditLine
					         (claimidauditid,
							 Comments,
							 Description,
							 Supp_tvcv_num,
							 Supp_rec_num,
							 created,							
							 updated,
							 userid,
							 addt_amount,
							 seq_num
							 )
					  VALUES ('#URL.claimidauditid#',
					          '#URL.Comments#', 
							  '#URL.Description#',
							  '#URL.Supp_tvcv_num#',
							  '#URL.Supp_rec_num#',
							   getdate(),
					    	  getdate(),		  
						  	  '#SESSION.acc#',
							  '#URL.addt_amount#',
							  #max_seq_number#
							  ) 
							  </cfquery>
							  
					<!--- updation part commented jg
					<cfquery name="Update" 
					datasource="AppsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE stFundStatus
					SET FundType       = '#URL.FundType#',
					    Period         = '#URL.Period#',
						DateEffective  = #STR#,
						Status         = '#URL.Status#',
						<cfif URL.pap neq "" and URL.Pap neq "Current">
						DefaultAccount = '#URL.Pap#',
						<cfelse>
						DefaultAccount = NULL,
						</cfif>
						Remarks        = '#URL.Remarks#'
					WHERE ValidationId    = '#URL.id#'
					</cfquery>
					--->
					<input type="hidden" name="action" value="1">
															
				</cfif>	
			
			</cfif>	
		
		</cfif>
		
<cfelse>

	<!--- delete --->
			<!--- JG commented it
	<cfquery name="Delete" 
    datasource="AppsTravelClaim" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
  	DELETE FROM stFundStatus
	WHERE  ValidationId = '#URL.id#'
    </cfquery>
	--->
	<input type="hidden" name="action" value="1">
			
</cfif>		
 

