
 <cfquery name="Get" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserNames 
		WHERE  Account = '#SESSION.acc#'
	</cfquery>
	
	<cfloop index="itm" from="1" to="6">
	
		<cfquery name="Check" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   UserDashboard
			WHERE  Account = '#SESSION.acc#'
			AND    DashboardFrame = '#itm#'
		</cfquery>
		
		<cfif Check.recordcount eq "0">
		
			<cfquery name="Settings" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserDashboard
			(Account, DashboardFrame, Scrolling, Width)
			VALUES ('#SESSION.acc#','#itm#','No','33')
			</cfquery>
			
		</cfif>
				
	</cfloop>
	
	<!--- gets the defined frames by the user --->
	
	<cfquery name="Frame" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   UserDashboard
		WHERE  Account = '#SESSION.acc#'
	</cfquery>
	
	<cfloop query="frame">
	
		<cfset scroll[DashboardFrame] = Scrolling>
		<cfif width gt "">
			<cfset w[DashboardFrame] = Width>
		</cfif>
		<!---
		<cfif height gt "">
			<cfset h[DashboardFrame] = Height>
		</cfif>
		--->
	
	</cfloop>
			 
	<cfset h = 200>
			  
	<cfset attrib = {type="Border",name="box1",fitToWindow="Yes"}>	
	
	<cf_layout attributeCollection="#attrib#">
		
		<cf_layoutarea 
	          position="header"	        	 
			  name="itemheader1" 		 
			  overflow="hidden"					  
			  collapsible="true"
	          splitter="true">	
			  
			  <cfinclude template="DashboardMenu.cfm">
			  
		</cf_layoutarea>	  	
				
		<cf_DashboardTopicName frm="1">
		
			<cfif get.Pref_DashBoard eq "1:1">
			 <cfset h = 400>
			</cfif>
		
			<!--- The 100% height style ensures that the background color fills
			the area. --->
			<cf_layoutarea 
	          position="top"
	          size="#h#"
			  source="DashboardGadgetItem.cfm?frm=1&loc=itemtop1" 
			  name="itemtop1" 			 
			  overflow="hidden"
			  collapsible="true"
	          splitter="true"/>	
						
		<cfif get.Pref_DashBoard eq "1:3:1">
			
			<cf_DashboardTopicName frm="2">
							
				<cf_layoutarea 
				 position    = "left"
				 collapsible = "true" 
				 source      = "DashboardGadgetItem.cfm?frm=2&loc=itemleft1"
				 name        = "itemleft1" 				
				 size        = "#h#" 
				 overflow    = "hidden"				 
				 splitter    = "true"/>			 			
							
		</cfif>		
			
		<cf_DashboardTopicName frm="3">
			
			<cf_layoutarea 
			  position   = "center" 
			  source     = "DashboardGadgetItem.cfm?frm=3&loc=itemcenter1"
			  name       = "itemcenter1"
			  overflow   = "hidden"/>
						
		<cfif get.Pref_DashBoard eq "1:3:1">	
			
		<cf_DashboardTopicName frm="4">
			
			<cf_layoutarea 
			position    = "right" 
			collapsible = "true" 					
			source      = "DashboardGadgetItem.cfm?frm=4&loc=itemright1"
			splitter    = "true" 
			name        = "itemright1"
			size        = "#h#" 
			overflow    = "hidden"/>
						
		</cfif>	
			
		<cfif get.Pref_DashBoard neq "1:1">
					
			<cf_DashboardTopicName frm="5">
				
				<cf_layoutarea 
	             position    = "bottom" 
			     size        = "#h#"				 
				 source      = "DashboardGadgetItem.cfm?frm=5&loc=itembottom1"
				 name        = "itembottom1"			     
	             collapsible = "true"
				 overflow    = "hidden"	
	             splitter    = "true"/>
									
			</cfif>	
			
	</cf_layout>