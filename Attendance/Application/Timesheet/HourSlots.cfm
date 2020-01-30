<cfparam name="attributes.slot"     default="1">
<cfparam name="attributes.hourslots" default="1">

<cfset hourslots = attributes.hourslots>
<cfset slot      = attributes.slot>

<cfswitch expression="#hourslots#">

		<cfcase value="1">														
			00-:59							
		</cfcase>
		
		<cfcase value="2">														
		
			<cfif slot eq "1">
			00-:29		
			<cfelse>
			30-:59	
			</cfif>
									
		</cfcase>
		
		<cfcase value="3">														
		
			<cfif slot eq "1">
			00-:19		
			<cfelseif slot eq "2">
			20-:39	
			<cfelse>
			40-:59
			</cfif>
									
		</cfcase>
		
		<cfcase value="4">														
		
			<cfif slot eq "1">
			00-:14		
			<cfelseif slot eq "2">
			15-:29	
			<cfelseif slot eq "3">
			30-:44
			<cfelse>
			45-:59
			</cfif>
									
		</cfcase>
		
</cfswitch>