
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfparam name="url.Operational"        default="0">
<cfparam name="url.Mission"            default="">
<cfparam name="url.eMailAddress"       default="">
<cfparam name="url.RecipientName"      default="">
<cfif url.operational eq "true">
	 <cfset url.operational = "1">
<cfelse>
	 <cfset url.operational = "0">
</cfif>

<cfif not isValid("email", "#url.eMailAddress#")>

	<cfoutput>
	<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	<tr><td align="center"><font color="FF0000">You entered an invalid eMail address #URL.eMailAddress#</font></td></tr>
	</table>
	</cfoutput>
		
	<cfinclude template="MailList.cfm">

<cfelse>
	
	<!--- check if parent exists --->
	
	<cfquery name="Exist" 
		    datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    SELECT  *
			FROM    Ref_EntityDocument
			 WHERE  DocumentId = '#URL.DocumentId#' 
		</cfquery>
	
	<cfif Exist.recordcount eq "0">
	
			<cfquery name="Insert" 
			     datasource="AppsOrganization" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">				 
			     	INSERT INTO Ref_EntityDocument
			        	 (DocumentId,
						 EntityCode,
						 DocumentType,
						 DocumentCode,
						 DocumentDescription,
						 DocumentTemplate)
				    VALUES ('#url.documentid#',
				    	  '#URL.EntityCode#',
					      'Mail',
					      '#SESSION.acc#','','')
			</cfquery>
	
	
	</cfif>	
	
	<!--- record --->
	
	<cfif URL.ID2 neq "new">
	
		 <cfquery name="Update" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_EntityDocumentRecipient
			  SET    Operational         = '#URL.Operational#',
			         <cfif url.mission eq "">
					 Mission             = NULL,
					 <cfelse>
	 		         Mission             = '#URL.Mission#',
					 </cfif>
					 <cfif url.entityClass neq "">
						EntityClass      = '#url.entityClass#',
					 </cfif>
					 <cfif url.actioncode neq "">
						ActionCode       = '#url.actionCode#',
					 </cfif>					
					 eMailAddress        = '#URL.eMailAddress#',
					 RecipientName       = '#URL.RecipientName#'
			  WHERE  RecipientId   	= '#URL.ID2#'
			   AND   DocumentId 	= '#URL.DocumentId#' 
		</cfquery>
					
	<cfelse>
					
		<cfquery name="Insert" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     	INSERT INTO Ref_EntityDocumentRecipient
				         (DocumentId,
						 Mission,
						 <cfif url.entityClass neq "">
							EntityClass,
						 </cfif>
						 <cfif url.actioncode neq "">
							ActionCode,
						 </cfif>	
						 eMailAddress,
						 RecipientName,
						 Operational)
			     VALUES ('#URL.DocumentId#',
					       <cfif url.mission eq "">
						   NULL,
						   <cfelse>
						   '#URL.Mission#',
						   </cfif>
						   <cfif url.entityClass neq "">
							'#url.entityClass#',
						   </cfif>
						   <cfif url.actioncode neq "">
							'#url.actionCode#',
						   </cfif>	
						  '#URL.eMailAddress#',
						  '#URL.RecipientName#',
				      	  '#URL.Operational#')
		</cfquery>
			   	
	</cfif>

<cfset url.id2 = "new">
<cfinclude template="MailList.cfm">

</cfif>

