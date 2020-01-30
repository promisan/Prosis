
<cfparam name="Form.Operational"     default="0">
<cfparam name="Form.Description"     default="">
<cfparam name="Form.TrackingOrder"   default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="AppsPurchase" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_TransportTrack
		  SET    Operational         = '#Form.Operational#',
 		         Description         = '#Form.Description#',
				 TrackingOrder       = '#Form.TrackingOrder#'
		  WHERE  TrackingId   = '#URL.ID2#'
	</cfquery>
	
	<cfset url.id2 = "">
				
<cfelse>
		
			<cfquery name="Insert" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_TransportTrack
			         (TransportCode,
					 Description,
					 TrackingOrder,
					 Operational)
			      VALUES ('#URL.Code#',
				      '#Form.Description#',
					  '#Form.TrackingOrder#',
					  '#Form.Operational#')
			</cfquery>
			
	<cfset url.id2 = "new">
			   	
</cfif>


<cfoutput>
  <script>
    ColdFusion.navigate('List.cfm?Code=#URL.Code#&ID2=new','#url.code#_list')	
  </script>	
</cfoutput>

