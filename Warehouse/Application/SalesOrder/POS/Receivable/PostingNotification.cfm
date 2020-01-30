<cfquery name="qBatch" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
		SELECT  *
		FROM   WarehouseBatch
		WHERE  BatchId = '#batchid#'
</cfquery>	


<cfquery name="qWarehouse" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT * 
	FROM   Warehouse
	WHERE  Warehouse = '#qBatch.Warehouse#' 	
</cfquery>	


<cfif qWarehouse.emailAddress neq "">

	<cfquery name="Parameter" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#'  
	</cfquery>
	
	<cfif not DirectoryExists("#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\")>
	
		   <cfdirectory 
		     action="CREATE" 
	            directory="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\">
	
	</cfif>
	
	<cfset url.templatepath = "/warehouse/inquiry/print/BatchDistribution/Batch.cfr">
	
		
	<cfset rep=replace(url.templatepath,"/","\","ALL")>
			
	<cfset FileNo = round(Rand()*100)>
	<cfset attach = "ORDER_#qBatch.BatchNo#_#FileNo#.pdf">
	
	<cfset vpath="#SESSION.rootPath#CFRStage\User\#SESSION.acc#\#attach#">		
	
			
	<cfreport 
		   template     = "#SESSION.rootPath##rep#" 
		   format       = "PDF" 
		   overwrite    = "yes" 
		   encryption   = "none"
		   filename     = "#vPath#">
			
			<!--- other variables --->					
			<cfreportparam name = "root"            value="#SESSION.root#">
			<cfreportparam name = "logoPath"        value="#Parameter.LogoPath#">
			<cfreportparam name = "logoFileName"    value="#Parameter.LogoFileName#">
			<cfreportparam name = "system"          value="#SESSION.welcome#">	
			<cfreportparam name = "ID"              value="#qBatch.BatchNo#"> 			
			<cfreportparam name = "dateformatshow"  value="#CLIENT.DateFormatShow#"> 
			
	</cfreport>	
	
	<cfif Parameter.SystemContactEmail neq "">
		<cfmail
				FROM        = "#Parameter.SystemContactEmail#"
				TO          = "#qWarehouse.emailAddress#"			
				subject     = "BatchNo : #qBatch.BatchNo#" 
				replyto     = "#Parameter.SystemContactEmail#"
				FAILTO      = "#Parameter.SystemContactEMail#"
				mailerID    = "Messenger"
				TYPE        = "html"
				spoolEnable = "No"                                        
				wraptext    = "100">					
		 			
		 			<cfmailparam file = "#vpath#">
			
		</cfmail>	
	</cfif>

</cfif>