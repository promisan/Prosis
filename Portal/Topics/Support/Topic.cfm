<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
			width            = "98%"
			height           = "auto"		
			Label            = "My Pending Support Tickets"
			ShowPrint		 = "1"			
			PrintCallback 	 = "$('##ticketViewWidgetContainer').attr('style','width:100%;'); $('##ticketViewWidgetContainer').parent('div').attr('style','width:100%;');">		
			
			<!--- AutoRefreshSpan	 = "60000" --->
	
</cf_pane>
