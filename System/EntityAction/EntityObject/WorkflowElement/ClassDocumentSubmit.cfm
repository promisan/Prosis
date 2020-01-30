<cf_compression>

<cfparam name="url.lo"  default="0">
<cfparam name="url.lan"  default="0">
<cfparam name="url.fil" default="">
<cfparam name="url.frc" default="0">

<cfif url.op eq "true">
	<cfparam name="operational" default="1">
<cfelse>
    <cfparam name="operational" default="0">
</cfif>

<cfif url.frc eq "true">
	<cfparam name="force" default="1">
<cfelse>
    <cfparam name="force" default="0">
</cfif>

<cfif url.publishNo eq "">

	<cfquery name="Check" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * FROM Ref_EntityClassActionDocument
		  WHERE   EntityCode     = '#URL.EntityCode#'
		  AND     EntityClass    = '#URL.EntityClass#'
		  AND     ActionCode     = '#URL.ActionCode#'
	   	  AND     DocumentId     = '#URL.ID2#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO Ref_EntityClassActionDocument
				  (EntityCode, 
				   EntityClass, 
				   ActionCode, 
				   DocumentId, 
				   DocumentLanguageCode,
				   ObjectFilter, 
				   ForceDocument,
				   ListingOrder, 
				   Operational)
			  VALUES
				  ('#URL.EntityCode#',
				   '#URL.EntityClass#',
				   '#URL.ActionCode#',
				   '#URL.ID2#',
				   '#url.lan#',
				   '#url.fil#',
				   '#url.frc#',
				   '#url.lo#',
				   '#Operational#')		
		</cfquery>
	
	<cfelse>
		
		<cftry>
						
			<cfquery name="Update" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE Ref_EntityClassActionDocument
				  SET    ListingOrder         = '#url.lo#',
				         Objectfilter         = '#url.fil#', 
						 DocumentLanguageCode = '#url.lan#',
						 ForceDocument        = '#force#',
				         Operational          = '#Operational#' 
				  WHERE  ActionCode           = '#URL.ActionCode#'
				  AND    EntityCode           = '#URL.EntityCode#'
				  AND    EntityClass          = '#URL.EntityClass#'
			   	  AND    DocumentId           = '#URL.ID2#'
			</cfquery>
			
												
			<cfcatch>
			
				<script>alert("Please enter a valid order.")</script>		
								
			</cfcatch>
		
		</cftry>
	
	</cfif>
	
<cfelse>
	
	<cfquery name="Check" 
		  datasource="AppsOrganization" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT * FROM Ref_EntityActionPublishDocument
		  WHERE  ActionCode     = '#URL.ActionCode#'
		  AND    ActionPublishNo = '#URL.PublishNo#'
	   	  AND    DocumentId  = '#URL.ID2#'
	</cfquery>
	
	<cfif Check.recordcount eq "0">
	
		<cfquery name="Insert" 
			  datasource="AppsOrganization" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO Ref_EntityActionPublishDocument
			  (ActionPublishNo, ActionCode,DocumentLanguageCode, DocumentId, ListingOrder, Operational)
			  VALUES
			  ('#URL.PublishNo#','#URL.ActionCode#','#url.lan#','#URL.ID2#','#url.lo#','#Operational#')		
		</cfquery>
	
	<cfelse>
		
		<cftry>
		
			<cfquery name="Update" 
				  datasource="AppsOrganization" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  UPDATE  Ref_EntityActionPublishDocument
				  SET     ListingOrder = '#url.lo#',
				          Operational = '#Operational#',
						  DocumentLanguageCode = '#url.lan#',
						  ForceDocument = '#force#',
  						  Objectfilter = '#url.fil#'
				  WHERE   ActionCode     = '#URL.ActionCode#'
				  AND     ActionPublishNo = '#URL.PublishNo#'
			   	  AND     DocumentId  = '#URL.ID2#'
			</cfquery>
			
			<cfcatch>
			
				<script>alert("Please enter a valid order")</script>
				
			</cfcatch>
		
		</cftry>
	
	</cfif>

</cfif>	



  
