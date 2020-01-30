<cfcomponent>

	<cffunction name="getFormTime" access="remote" returnFormat="plain" output="false">
	
	    <cfargument name="date" type="string" required="false" default="#DateFormat(now(), CLIENT.DateFormatShow)#">
		<cfargument name="hour" type="string" required="false" default="#TimeFormat(now(), 'HH')#">
		<cfargument name="minu" type="string" required="false" default="#TimeFormat(now(), 'MM')#">
				
		<cfset dateValue = "">
		<CF_DateConvert Value="#date#">
		<cfset dte = dateValue>
		<cfset dte = DateAdd("h","#hour#", dte)>
		<cfset dte = DateAdd("n","#minu#", dte)>
		
		<cfreturn dte>
		
	</cffunction>
		
	<cffunction name="getLocationTime" access="remote" returnFormat="json" output="false">
	
		<!--- get the current local time of a store --->
		
		<cfargument name="whs" type="string" required="false" default="">
	
		<cfset s = getTime("#DateFormat(now(), CLIENT.DateFormatShow)#","#TimeFormat(now(), 'HH:MM')#",whs)>
	
	    <cfset hour  = "#timeformat(s.localtime,'HH')#">
		<cfset minu  = "#timeformat(s.localtime,'MM')#">
		<cfset time  = "#hour#,#minu#">		
	
		<cfreturn time>
		
	</cffunction>
	
	<cffunction name="getTime" returnType="Struct">
		<cfargument name="ddate"   type="date" required="true" default="#DateFormat(now(), CLIENT.DateFormatShow)#">
		<cfargument name="dtime"   type="date" required="true" default="#TimeFormat(now(), 'HH:MM')#">	
		<cfargument name="whs"     type="string" required="true" default="">
				
		<cfset dateValue = "">
		<CF_DateConvert Value = "#ddate#">
		<cfset dte = dateValue>
	
		<cfset dte = DateAdd("h","#TimeFormat(dtime, 'HH')#", dte)>
		<cfset dte = DateAdd("n","#TimeFormat(dtime, 'MM')#", dte)>
	
		<cfquery name="Param"
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * 
			FROM   System.dbo.Parameter 	
		</cfquery>
					
		<!--- database server timezone --->
			
		<cfquery name="WarehouseZone"
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT TOP 1 * 
			FROM   WarehouseTimeZone
			WHERE  Warehouse = '#whs#'
			AND    DateEffective <= #dte# 
			ORDER BY DateEffective DESC 	
		</cfquery>
		
		<cfif WarehouseZone.recordcount eq "0">
		
			<cfquery name="WarehouseZone"
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * 
			FROM   Warehouse
			WHERE  Warehouse = '#whs#'			
		    </cfquery>
		
			<cfset timezone = WarehouseZone.TimeZone>
		
		<cfelse>
		
			<cfset timezone = WarehouseZone.TimeZone>
				
		</cfif>
			
		<!--- if server is in brindisi the time is 7 hours earlier --->
		
		<cfif timezone neq "">
			
			<cfset correction = (Param.DatabaseServerTimeZone - WarehouseZone.TimeZone)*-1>		
			<cfset dte      = DateAdd("h",correction,dte)>
			<cfset timezone = "#WarehouseZone.TimeZone#:00">
			
		<cfelse>	
		
			<cfset timezone   = "#Param.DatabaseServerTimeZone#:00">
			<cfset correction = timezone>
			
		</cfif>	
	
	    <cfset s = StructNew()> 
		<cfset s.localtime    = dte>
		<cfset s.timezone     = timezone>
		<cfset s.tzcorrection = correction>
	
		<cfreturn s>
	
	</cffunction>

</cfcomponent>
