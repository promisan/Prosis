
<cf_screentop height="100%"  jquery="Yes" html="No" layout="webapp" scroll="no" banner="gray">

<cfparam name="Form.account" default="">

<cfquery name="NextCheck" 
datasource="AppsOrganization"
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT    TOP 1 *
	FROM      Ref_EntityActionPublish
	WHERE     ActionPublishNo = '#Form.ActionPublishNo#' 
	AND       ActionCode      = '#Form.ActionCode#' 
	ORDER bY  Created DESC 
</cfquery>	

<cfif Form.account neq "">

	<cfquery name="Users" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT     *
	 FROM       UserNames
	 WHERE      Account IN (#preserveSingleQuotes(Form.Account)#) 
	</cfquery>
	
	<cfset to = "">
	
	<cfloop query="Users">
	   
	    <cfif to eq "">
		   <cfset to = "#emailAddress#">
		<cfelse>
		   <cfset to = "#to#, #emailAddress#">
		</cfif> 
			
		<cfquery name="RegisterMail" 
		  datasource="AppsOrganization"
		  username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
			INSERT INTO OrganizationObjectMail
				(ObjectId, 
				 ActionCode, 
				 Account, 
				 eMailAddress, 
				 eMailType, 
				 OfficerUserId, 
				 OfficerLastName,
				 OfficerFirstName)
			VALUES
				('#Form.ObjectId#',
				 '#Form.ActionCode#',
				 '#Account#', 
				 '#eMailAddress#', 
				 '#Form.Text#', 
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
	 	</cfquery>  
	
	</cfloop>	
		
	<cfif to neq "">	   

		<cfif NextCheck.DueMailCode eq "">	
		
			 <cf_ProcessMailText
				to         = "#to#" 
				text       = "#Form.Text#"
				objectId   = "#Form.ObjectId#"
				actioncode = "#Form.ActionCode#">
	
		<cfelse>
							
			<cfquery name="CheckMail" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			    SELECT    P.ActionCode, M.*
			    FROM      Ref_EntityDocument M INNER JOIN
			              Ref_EntityActionPublish P ON M.DocumentCode = P.DueMailCode
			    WHERE     M.DocumentType    = 'mail' 
			    AND       P.ActionCode      = '#Form.ActionCode#'
				AND       P.ActionPublishNo = '#Form.ActionPublishNo#'  
				AND       M.EntityCode      = '#Form.EntityCode#' 
			</cfquery>
		
			<cfparam name="Form.actionMail" default="">
		
			<cfif CheckMail.recordcount eq "1">
											
				<cf_ProcessMailHolder
				     sendto      = "#to#"
					 actionId    = "#Form.ActionId#"
					 mailobject  = "#CheckMail.DocumentId#">
					
			</cfif>				
			
		</cfif>
	   					
	</cfif>

</cfif>

<script language="JavaScript">   
   try { parent.ProsisUI.closeWindow('wMailDialog') } catch(e) {}	
   try { parent.parent.ProsisUI.closeWindow('wMailDialog') } catch(e) {}	
</script>

