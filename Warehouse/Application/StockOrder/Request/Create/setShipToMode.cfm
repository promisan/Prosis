
<cfquery name="update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE    RequestHeader
   SET       RequestShipToMode = '#url.mode#'
   WHERE     Mission = '#url.mission#'  
   AND       Reference = '#url.reference#'
</cfquery>



<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      RequestHeader
   WHERE     Mission = '#url.mission#'  
   AND       Reference = '#url.reference#'
</cfquery>

<cfoutput>

<cfif get.RequestShipToMode eq "Deliver">
					
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/request/create/setShipToMode.cfm?mission=#mission#&reference=#reference#&mode=Collect','shiptomode')">						
	<font color="0080C0">COLLECTION</font>
	</a>
		
<cfelse>
	
	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/request/create/setShipToMode.cfm?mission=#mission#&reference=#reference#&mode=Deliver','shiptomode')">												
	<font color="0080C0">DELIVERY</font>
	</a>
	
</cfif>		


<cfquery name="label" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      Ref_ShipToMode
   WHERE     Code = '#url.mode#'    
</cfquery>

	
<script>
	 document.getElementById('shiptomodename').innerHTML = '#label.description#'
</script>	

</cfoutput>