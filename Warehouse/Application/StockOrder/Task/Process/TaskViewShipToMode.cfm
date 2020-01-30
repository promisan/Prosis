
<cfquery name="update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   UPDATE    RequestTask
   SET ShipToMode = '#url.mode#'
   WHERE     Taskid = '#url.taskid#'  
</cfquery>

<cfquery name="get" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT    *
   FROM      RequestTask
   WHERE     Taskid = '#url.taskid#'  
</cfquery>

<cf_compression>

<cfoutput>
						
<cfif get.ShipToMode eq "Deliver">

	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Collect','f#taskid#_shiptomode')">						
	<font color="0080C0">COLLECTION</font>
	</a>
	
<cfelse>

	<a href="javascript:ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/task/process/taskViewShipToMode.cfm?taskid=#taskid#&mode=Deliver','f#taskid#_shiptomode')">												
	<font color="0080C0">DELIVERY</font>
	</a>

</cfif>		

</cfoutput>