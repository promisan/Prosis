<cfquery name="getBase" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT   *
	  FROM     UserNames
	  WHERE    Account = '#session.acc#'  
</cfquery> 

<cfinvoke component = "Service.Connection.Connection"  
   method           = "setconnection"    
   object           = "UserSupport" 
   ScopeId          = "#systemfunctionid#"
   ControllerNo     = "998"
   ObjectContent    = "#getBase#"
   ObjectIdfield    = "account"
   delay            = "15">	     

<cf_pane id="PendingTicketWidget" search="No">
				
	<cf_paneItem id="#session.acc#" 
	        systemfunctionid = "#systemfunctionid#"  
			source           = "#session.root#/Portal/Topics/Support/TicketView.cfm"
			width            = "95%"
			height           = "auto"		
			Label            = "My Pending Support Tickets"
			ShowPrint		 = "1"			
			PrintCallback 	 = "$('##ticketViewWidgetContainer').attr('style','width:100%;'); $('##ticketViewWidgetContainer').parent('div').attr('style','width:100%;');">		
			
			<!--- AutoRefreshSpan	 = "60000" --->
	
</cf_pane>
