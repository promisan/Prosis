
<cfquery name="getAttachment" datasource="AppsSystem">
		SELECT * 
		FROM   Attachment
		WHERE  Attachmentid = '#url.id#'				
</cfquery>
	
<cfif getAttachment.recordcount eq 1>			

	<cfquery name="getClaim" datasource="AppsCaseFile">
	
		SELECT C.Mission, C.ClaimType 
			FROM   Claim C 
			INNER  JOIN ClaimElement CE ON C.ClaimId = CE.ClaimId
			INNER  JOIN Element E ON CE.ElementId = E.ElementId
			WHERE  E.ElementId = '#getAttachment.reference#'
			
			UNION 
						
			SELECT  C.Mission, C.ClaimType
			FROM    ElementRelation ER INNER JOIN
                    ClaimElement CE ON ER.ElementId = CE.ElementId INNER JOIN
                    Claim C ON CE.ClaimId = C.ClaimId
			WHERE   ER.RelationId = '#getAttachment.reference#'
	
	</cfquery>	
	
	<cfset show = 0 >
	
	<cfloop query="getClaim">
		
		<cfinvoke component="Service.Access"  
   		 method="CaseFileManager" 
	     mission="#mission#" 
		 claimtype="#claimtype#"
	     returnvariable="access">

			<cfif access eq "READ" or access eq "EDIT" or access eq "ALL">
				<cfset show= show+1>
			</cfif>
		
	</cfloop>

	<cfif show gt 0 >
		
		<cflocation addtoken="No" url = "#SESSION.root#/Tools/Document/FileRead.cfm?id=#url.id#">	
		
	<cfelse>
	
		<table width="100%">
		<tr>
			<td height="40"></td>
		</tr>
		<tr>
				<td align="center" width="100%">
					<cf_tl id="Your profile does not allow you to view this record.">
				</td>
			</tr>
		</table>
	</cfif> 
	
</cfif>