<cfparam name="Attributes.Months" default="0">

		<cfif Attributes.Months gte "12">
		
		    <cfset sy = int(Attributes.Months/12)>

			<cfset Caller.years = sy>
			
			<cfset sm = Attributes.Months-(sy*12)>
			 <cfif sm neq "0">
			 	<cfset Caller.months = sm>
			</cfif>
			
		<cfelse>
		
			<cfset Caller.years  = 0>
			<cfset Caller.months = Attributes.Months>
		
		</cfif>