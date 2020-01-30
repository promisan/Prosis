
<cfif Form.action eq "new">

		<cfquery name="Insert" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  INSERT INTO Ref_SettlementMission
		         (Code,
			      Mission,
      			  GLAccount,
      			  ListingOrder,
      			  OfficerUserId,
      			  OfficerLastName,
      			  OfficerFirstName,
      			  Created)
		  VALUES ('#Form.Code#',
		          '#Form.Mission#', 
				  '#Form.GLAccount#',
				  '#Form.ListingOrder#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#',
				  getDate())
		</cfquery>

<cfelseif Form.action eq "update">

		<cfquery name="Update" 
		datasource="AppsWorkorder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  UPDATE Ref_SettlementMission
		  SET	 Mission  = '#Form.Mission#',
		  		 GLAccount= '#Form.GLAccount#',
				 ListingOrder='#Form.ListingOrder#'
		  WHERE  Code = '#Form.Code#'
		  AND    Mission = '#Form.MissionOld#'
		</cfquery>


</cfif>

<cfset url.code = Form.code>
<cfinclude template="List.cfm">
