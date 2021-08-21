
<cfparam name="URL.SubmissionEdition" default="">



<!--- insert header --->

<cfquery name="qEdition" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Ref_SubmissionEdition
		WHERE 	SubmissionEdition = '#URL.SubmissionEdition#'		
</cfquery>

<cftransaction>

<cf_assignid>
<cfset vBroadcastId = rowguid>

<cfquery name="Broadcast" 
   datasource="AppsSelection" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      
	  INSERT INTO System.dbo.Broadcast
		  (BroadcastId,
		   BroadcastClass,
		   BroadcastReference, 
		   BroadCastRecipient,
		   BroadCastSubject,
		   BroadcastFrom,
		   BroadcastReplyTo,
		   BroadcastPriority,
		   BroadcastFailTo,
		   BroadCastMailerId,
		   OfficerUserId,
		   OfficerLastName,
		   OfficerFirstName)
	  VALUES ('#vBroadcastId#',
		  'Mail', 
		  '#URL.SubmissionEdition#',
		  'EditionCustom',
		  '#qEdition.EditionDescription# Custom Broadcast',
		  '#client.eMail#',
		  '#client.eMail#',
		  '3',
		  '#client.eMail#',
		  '#SESSION.acc#',
		  '#SESSION.acc#',
		  '#SESSION.last#',
		  '#SESSION.first#')
</cfquery>

<cfif url.mode eq "Prior">

	<cfquery name="qSelect" 
	   datasource="AppsSelection" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT    DISTINCT SEO.SubmissionEdition,SEO.OrgUnit, O.OrgUnitName, OA.eFaxNo as EmailAddress
		FROM      Ref_SubmissionEditionOrganization SEO 
				  INNER JOIN Organization.dbo.OrganizationAddress OA ON OA.OrgUnit = SEO.OrgUnit 
				  INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = SEO.OrgUnit 
				  INNER JOIN Ref_SubmissionEditionAddressType SEAT ON SEO.SubmissionEdition = SEAT.SubmissionEdition AND SEAT.AddressType = OA.AddressType
		WHERE     SEO.SubmissionEdition	= '#URL.SubmissionEdition#'
		AND 	  SEO.Operational	   = '1'
		AND 	  SEAT.Operational 	   = '1'
		AND 	  eFaxNo IS NOT NULL
		
		UNION 
		
		SELECT    DISTINCT  SEO.SubmissionEdition,SEO.OrgUnit, O.OrgUnitName, A.eMailAddress
		FROM      Ref_SubmissionEditionOrganization SEO 
				  INNER JOIN Organization.dbo.OrganizationAddress OA ON OA.OrgUnit = SEO.OrgUnit 
				  INNER JOIN Organization.dbo.Organization O ON O.OrgUnit = SEO.OrgUnit 
				  INNER JOIN Ref_SubmissionEditionAddressType SEAT ON SEO.SubmissionEdition = SEAT.SubmissionEdition AND SEAT.AddressType = OA.AddressType
				  INNER JOIN System.dbo.Ref_Address A ON A.AddressId = OA.AddressId
		WHERE     SEO.SubmissionEdition	= '#URL.SubmissionEdition#'
		AND 	  SEO.Operational 	  = '1'
		AND 	  SEAT.Operational 	  = '1'
		AND 	  A.EmailAddress IS NOT NULL	
		ORDER BY  SEO.SubmissionEdition,SEO.OrgUnit		
	</cfquery>
	
	<cfoutput query="qSelect" group="OrgUnit">				   
												   
			<cfoutput>
			
				<!--- we prevent resending to the same address of the mail status = 1 --->				
				
				<cfset address= LCase(eMailAddress)>
				
				<cfif isValid("eMail",address) or isValid('regex',address,'[a-z]+@[0-9]+@fax')>
				
						<cf_assignid>
						
						<cfset vRecipientId = rowguid>
						
						<!--- we record the recipinent --->
	
						<cfquery name="qContact" 
						   datasource="AppsSelection" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
							SELECT  DISTINCT TOP 1 Contact 
							FROM    Organization.dbo.OrganizationAddress OA INNER JOIN 
								    System.dbo.Ref_Address A ON A.AddressId = OA.AddressId 
							WHERE   OrgUnit = '#OrgUnit#'
							AND     Contact IS NOT NULL
							AND 	OA.eFaxNo = '#EmailAddress#' OR A.eMailAddress = '#EmailAddress#'
						</cfquery>				
						
						<cfquery name="BroadcastRecipients" 
						   datasource="AppsSelection" 
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">
						   INSERT INTO System.dbo.BroadcastRecipient (
									RecipientId,
									BroadcastId, 
									RecipientCode, 
									RecipientName,
									eMailAddress, 										
									RecipientLastName,
									RecipientFirstName)								
						   VALUES ('#vRecipientId#',
						   		   '#vBroadcastId#',
						           '#orgunit#',
								   '#orgunitname#',
								   '#eMailAddress#',
						           '#LEFT(qContact.Contact,100)#',
								   '') 									   
						</cfquery>			
	
				</cfif>				
				
			</cfoutput>
			
	</cfoutput>		
		
<cfelse>
	
	<cfquery name="Recipient" 
		   datasource="AppsSelection" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			   INSERT INTO System.dbo.BroadcastRecipient
				        (BroadcastId, 
						RecipientCode, 
						eMailAddress, 
						RecipientName,
						RecipientLastName)			
				SELECT  DISTINCT '#vBroadcastId#',
			            S.OrgUnit,
					    M.eMailAddress,			 
					    O.OrgUnitName,
					    M.RecipientName		
				FROM    Ref_SubmissionEditionPublish S INNER JOIN
			            Ref_SubmissionEditionPublishMail M ON S.SubmissionEdition = M.SubmissionEdition AND S.OrgUnit = M.OrgUnit INNER JOIN
			            Organization.dbo.Organization O ON S.OrgUnit = O.OrgUnit		  
			    WHERE   M.eMailAddress <> ''
			    AND     S.SubmissionEdition = '#URL.SubmissionEdition#'
			    AND     M.ActionStatus = '1'
		</cfquery>

</cfif>

</cftransaction>

<cfparam name="url.mid" default="">
<cflocation addtoken="No" url="BroadCastView.cfm?id=#vBroadcastId#&mid=#url.mid#">

