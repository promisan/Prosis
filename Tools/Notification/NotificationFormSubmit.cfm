
<cfparam name="url.action" default="">

<cfif url.action eq "delete">
	
	<cfquery name="EventInsert" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	
		DELETE
		FROM   SystemEvent
		WHERE  EventId = '#Form.EventId#'
		
	</cfquery>
	
	<cfoutput>
	
		<script>		  
		    try {				
				parent.opener.applyfilter('','','content');
				parent.window.close();
			} catch(e) {}    	
    	</script>	
	
	</cfoutput>
	
<cfelse>

	<cfparam name="title" default="">
	
	<cfif form.uom eq "hours">
		<cfset eventduration = form.notificationduration>
	<cfelseif form.uom eq "days">
		<cfset eventduration = form.notificationduration * 24>
	<cfelseif form.uom eq "weeks">
		<cfset eventduration = form.notificationduration * 168>
	</cfif>
	
	<cfset eventduration = NumberFormat(eventduration,'_')>
	
	
	<cfif isDefined ("form.dateeffectivestart")>
		<!--- NORMALIZING the calendar date --->
		
		
		<cfset dateValue = ""> 
		<CF_DateConvert Value="#form.dateeffectivestart#"> 
		<cfset DEFF = dateValue>	
		
		<cfset  EFDATE = DateAdd("h", form.dateeffectivestarttime, DEFF)>		
	
	</cfif>
		
	<cfif isDefined ("form.dateeffectiveend")>	
		<!--- NORMALIZING the calendar date --->
		<cfset dateValue = ""> 
		<CF_DateConvert Value="#form.dateeffectiveend#"> 
		<cfset DEXP = dateValue>		
		
		<cfset  EXDATE = DateAdd("h", form.dateeffectiveendtime, DEXP)>		
	</cfif>
	
	<cfif isDefined("form.Create")>
	
		<cf_AssignId>
		
		<cfquery name="EventInsert" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">				 
					 
				INSERT INTO SystemEvent
			           (EventId
					   ,Description
					   ,Title
			           ,Type
			           ,Layout
			           ,EventDateEffective
			           ,EventDateExpiration
			           ,EventDisplayDuration
			           ,AuthenticationRequired
			           ,Persistent
			           ,OfficerUserId
			           ,OfficerLastName
			           ,OfficerFirstName
					   )
			     VALUES
			           ('#rowguid#',
					    '#message#',
						'#title#',
			            '#messagetype#',
			            '#messagedisplay#',
			             #EFDATE#,
			             #EXDATE#,
			            '#eventduration#',
			            '#authenticationrequired#',
			            '#removeafter#',
			           	'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#'
						)
		</cfquery>	
		
		<cfset slist = appserver>
		
		<cfloop list="#slist#" index="i">	
																			
			<cfquery name="EventServerInsert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
			
					INSERT INTO SystemEventServer
				           (EventId
				           ,Hostname
				           ,OfficerUserId
				           ,OfficerLastName
				           ,OfficerFirstName)
				     VALUES
				           ('#rowguid#',
				           '#i#',
				           '#SESSION.acc#',
				           '#SESSION.last#',
						   '#SESSION.first#'
						   )
			</cfquery>
			
		</cfloop>
		
		<cfoutput>
		
			<script>		  
			    try {				
					parent.opener.applyfilter('','','content');
					parent.window.location = 'NotificationEditTab.cfm?drillid=#rowguid#'
				} catch(e) {}    	
	    	</script>	
		
		</cfoutput>
	
	<cfelseif isDefined("form.update")>
	
		<cfquery name="UpdateEvent" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">					 
			UPDATE SystemEvent
			SET    Description            = '#message#',
				   Title	              = '#title#',
				   Type		              = '#messagetype#',
				   Layout	              = '#messagedisplay#',
				   EventDateEffective     =  #EFDATE#,
		           EventDateExpiration    =  #EXDATE#,
		           EventDisplayDuration   = '#eventduration#',
		           AuthenticationRequired = '#authenticationrequired#',
		           Persistent             = '#removeafter#'
			WHERE  EventId = '#Form.EventId#'
		</cfquery>	
		
		<cfset slist = appserver>
		
		<cfquery name="Clean" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
				DELETE FROM SystemEventServer
				WHERE  EventId = '#Form.EventId#'
		</cfquery>
	
		<cfloop list="#slist#" index="i">	
																			
			<cfquery name="EventServerInsert" 
				datasource="AppsSystem" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">	
			
					INSERT INTO SystemEventServer
				           (EventId
				           ,Hostname
				           ,OfficerUserId
				           ,OfficerLastName
				           ,OfficerFirstName)
				     VALUES
				           ('#Form.EventId#',
				           '#i#',
				           '#SESSION.acc#',
				           '#SESSION.last#',
						   '#SESSION.first#'
						   )
			</cfquery>
			
		</cfloop>
		
		<cfoutput>
		
			<script>	
			     
			    try {		
				    
					parent.opener.applyfilter('0','','#Form.EventId#');					
					
				} catch(e) {}   
				window.close()	  	
	    	</script>	
		
		</cfoutput>
		
	</cfif>

</cfif>