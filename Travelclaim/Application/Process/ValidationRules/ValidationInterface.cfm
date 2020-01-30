
<!--- retrieve last claim entry for validation --->

<cfquery name="Parameter" 
 datasource="AppsTravelClaim">
 SELECT *
 FROM Parameter
</cfquery>

<cfif FileExists("#Parameter.DocumentLibrary#\Interface\imcp_detail.csv")>
	
	<cffile action="READ" 
	      file="#Parameter.DocumentLibrary#\Interface\imcp_detail.csv" 
		  variable="feedback">
	
	<table width="100%">
	<cfoutput>
		<tr>
		<td>Export</td>
		<td><b>DocNo</td>
		<td><b>ClaimId</td>
		<td><b>ValidationId</td>
		<td>IMIS_TCP</td>
		<td colspan="2">Exception</td>
		<td>Upload</td>
		
		</tr>
		<cfloop index="line" list="#feedback#" delimiters=";">
		<tr>
		<cfset cnt = 0>
		<cfloop index="itm" list="#line#" delimiters="|">
		
		
			<cfset cnt = cnt+1>
									
			<cfif cnt eq "2">
			 <!----
				<cfset docno = right(itm,  len(itm)-3)>
				---->
				<cfset t =len(itm)>
				<cfif t gt 3>
				 	<cfset docno = right(itm,  (len(itm)-3))>
				<cfelse>
					<cfset docno = itm >
				</cfif>
				
				<cfquery name="Claim" 
				 datasource="AppsTravelClaim">
					SELECT * 
					FROM   Claim 
					WHERE  DocumentNo = '#docno#'
				</cfquery>
			
				<cfquery name="Validation" 
				 datasource="AppsTravelClaim">
					SELECT DISTINCT TOP 1 V.ClaimId, V.CalculationId, C.CalculationStamp
					FROM     ClaimValidation V INNER JOIN
					         ClaimCalculation C ON V.ClaimId = C.ClaimId AND V.CalculationId = C.CalculationId
					WHERE    C.ClaimId IN (SELECT ClaimId FROM Claim WHERE DocumentNo = '#docno#')
					ORDER BY C.CalculationStamp DESC
				</cfquery>
				
				<td>#docNo#</td>
				<td>#claim.ClaimId#</td>
				<td>#validation.calculationid#</td>
			
			</cfif>
			
			<cfif cnt eq "3">
			
				<cfif Validation.calculationid neq "">
							
					<cf_ValidationInsert
							ClaimId        = "#Claim.ClaimId#"					
							CalculationId  = "#Validation.calculationid#"
							ValidationCode = "#itm#">
						
				</cfif>		
										
			</cfif>
			
			<cfif cnt eq "5">
			
				<!--- upload denied by IMIS interface --->
		
				<cfif itm eq "0">
											
					<cfif claim.claimid neq "">
										
						<cfquery name="Update" 
						   datasource="AppsTravelClaim">
							UPDATE Claim
							SET ActionStatus = '4i'
							WHERE ClaimId = '#Claim.ClaimId#'		
						</cfquery>
						
						<cfquery name="updateLog"
						   datasource="appsTravelClaim"
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						    INSERT INTO ClaimActionLog
							(ClaimId,ActionStatus,OfficerUserid,OfficerLastName,OfficerFirstName)
							VALUES ('#Claim.ClaimId#', '4i','#SESSION.acc#','#SESSION.last#','#SESSION.first#')							
						</cfquery>
					
					</cfif>
							
				</cfif>
			
			</cfif>				
			<td>#itm#</td>
		</cfloop>
		</tr>
		</cfloop>
	</cfoutput>
	</table>
	
</cfif>	


</body>
</html>
