

<!--- disabled mail by hann 5/15/2013 --->

<cfquery name="Batch"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseBatch
		WHERE    BatchNo = '#URL.BatchNo#'
</cfquery>

<cfquery name="Check"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemWarehouseLocationTransaction 
	WHERE    Warehouse       = '#Batch.warehouse#'
	AND      Location        = '#Batch.Location#'
	AND      ItemNo          = '#Batch.itemno#'
	AND      UoM             = '#Batch..uom#'
	AND      TransactionType = '#Batch.TransactionType#'
</cfquery>
 
<cfif check.notification eq "1">

	<cfquery name="getWarehouse"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Warehouse
		WHERE    Warehouse = '#Batch.Warehouse#'
   </cfquery>

	<cfquery name="getLocation"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     WarehouseLocation
		WHERE    Warehouse = '#Batch.Warehouse#'
		AND      Location  = '#Batch.Location#'
	</cfquery>
 	 
	<cfquery name="getBatch" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   SELECT   *
	   FROM     ItemTransaction
	   WHERE    TransactionBatchNo = '#url.BatchNo#' 
	</cfquery>
	
	<cfoutput>	
																			
	<cfsavecontent variable="body">		
		<font face="Verdana" size="4" color="gray"><b><u>#getWarehouse.WarehouseName# NOTIFICATION</u></b></font>		
		<br>
		<font face="Verdana" size="3" color="gray">Location:<b>#getLocation.Description#</u></b></font>		
		<br>
		<font face="Verdana" size="3" color="gray">Date:<b>#dateformat(Batch.TransactionDate,client.dateformatshow)#</b></font>
		<br><br>
		<cfif url.action eq "confirm">		
			<font face="Verdana" size="2">A transaction batch under No: <b>#url.BatchNo#</b> with #getBatch.recordcount# line(s) has been CLEARED.</font>
		<cfelse>
			<font face="Verdana" size="2" color="FF0000">A transaction batch under No: <b>#url.BatchNo#</b> with #getBatch.recordcount# line(s) has been DENIED.</font>	
		</cfif>
		<br><br>					
	</cfsavecontent>
	
	</cfoutput>
	
	<cfif getWarehouse.eMailAddress neq "">
	  <cfset ccemail = mission.eMailAddress>
	<cfelse>
	  <cfset ccemail = "">  
	</cfif>
						
	<cf_mailsend 
			class="Batch" 
	        subject="#ucase('#SESSION.welcome# CONFIRMATION')#" 
			referenceid="#url.BatchNo#" 
	        ToClass="User" 
			CC="#ccemail#"		 
			SaveMail="1"
			To="#session.acc#" 												
			bodycontent="#body#">						
				 
</cfif>		
 