
<cfquery name="Purge" 
  datasource="AppsWorkOrder" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	  DELETE FROM RequestItem
	  WHERE  Requestid = '#url.requestid#'		  
</cfquery>	

<cfparam name="Form.ItemNoAsset"  default="">
<cfparam name="client.ItemSelect" default="">

<cfloop index="itm" list="#client.itemselect#">

    <cfset itm = replace(itm,"'","","ALL")> 
	
	<cfif itm neq "">
					    
		<cfquery name="check" 
		  datasource="AppsWorkOrder" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM   RequestItem
			  WHERE  Requestid = '#url.requestid#'		  
			  AND    ItemNo    = '#itm#' 
		</cfquery>	
		
		<cfif check.recordcount eq "0">
				
			<cfquery name="Insert" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				
		  	  INSERT INTO RequestItem
			    (Requestid,
				 ItemNo,
				 OfficerUserid,
				 OfficerLastName,
				 OfficerFirstName)		 
			  VALUES
			    ('#url.requestid#',
				 '#itm#',
				 '#SESSION.acc#',
				 '#SESSION.last#',
				 '#SESSION.first#')
		    </cfquery>	
		
		</cfif>

	</cfif>
	
</cfloop>	






 