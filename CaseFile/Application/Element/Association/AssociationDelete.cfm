
<!--- save association and refresh screen underlying --->

<cfquery name="Check" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 SELECT    *
	     FROM      ElementRelation
		 WHERE     Elementid      = '#url.elementid1#'
		 AND       ElementidChild = '#url.elementid2#'	
		 UNION ALL
		 SELECT    *
	     FROM      ElementRelation
		 WHERE     ElementIdChild = '#url.elementid1#'
		 AND       Elementid      = '#url.elementid2#'		 
</cfquery>

<cfloop query="Check">
	
	<cfquery name="Logging" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 INSERT INTO ElementRelationLog
    			 (Elementid,
	    		  ElementidChild,
				  RelationCode,
				  RelationMemo,
				  DateExpiration,
				  OfficerUserid,
				  OfficerLastName,
				  OfficerFirstName)
			 VALUES
				 ('#ElementId#',
				  '#ElementIdChild#',
				  '#RelationCode#',
				  '#RelationMemo#',
				  getdate(),
				  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')		 
	</cfquery>
		
	<cfquery name="Clear" 
		datasource="AppsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			 DELETE ElementRelation		
			 WHERE     Elementid      = '#ElementId#'
			 AND       ElementidChild = '#ElementIdChild#'		
	</cfquery>	

</cfloop>

<cfinclude template="AssociationListingDetail.cfm">
