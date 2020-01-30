
<cfparam name="Form.AssetId"  default="">
<cfparam name="Form.Memo"     default="">
	
<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsCaseFile" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE   ClaimAsset 
			  SET  Assetid = '#Form.AssetId#', 				 				 
				   Memo                 = '#Form.Memo#'		 
			 WHERE ClaimId= '#URL.ClaimId#' 
			 AND   Assetid = '#URL.ID2#'
	 </cfquery>
		
	 <cfset url.id2 = "">
	 <cfinclude template="Line.cfm">	
			
<cfelse>
		
	<cfquery name="Insert" 
	    datasource="AppsCaseFile" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	     INSERT INTO ClaimAsset 
		         (ClaimId,				 
				 AssetId,									
				 Memo,				
				 OfficerUserId,
				 OfficerLastname,
				 OfficerFirstName)
	      VALUES
			     ('#URL.claimid#',				
				  '#Form.AssetId#',				 
				  '#Form.Memo#',	
		      	  '#SESSION.acc#',
				  '#SESSION.last#',
				  '#SESSION.first#')
	</cfquery>
			
	<cfset url.id2 = "">
	<cfinclude template="Line.cfm">	
		   	
</cfif>