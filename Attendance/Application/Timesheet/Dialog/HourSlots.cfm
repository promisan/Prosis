<cfparam name="attributes.slot"     default="1">
<cfparam name="attributes.hourslots" default="1">
<cfparam name="attributes.icon" default="No">

<cfset hourslots = attributes.hourslots>
<cfset slot      = attributes.slot>

<cfoutput>

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
			    <cfif attributes.icon eq "Yes">
				<img src="#Client.VirtualDir#/images/logos/attendance/time/twenty1.png" alt="" border="0">
				<cfelse>
				00-:19
				</cfif>
			<cfelseif slot eq "2">
				  <cfif attributes.icon eq "Yes">
				  <img src="#Client.VirtualDir#/images/logos/attendance/time/twenty2.png" alt="" border="0">
				<cfelse>
				20-:39
				</cfif>
			<cfelse>
			   <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/twenty3.png" alt="" border="0">
				<cfelse>
				40-:59
				</cfif>			
			</cfif>
									
		</cfcase>
		
		<cfcase value="4">														
		
			<cfif slot eq "1">
			  <cfif attributes.icon eq "Yes">
			    <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter1.png" alt="" border="0">
			  <cfelse>
				00-:14		
			  </cfif>	
			<cfelseif slot eq "2">
			  <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter2.png" alt="" border="0">
			  <cfelse>
				15-:29		
			  </cfif>	
			<cfelseif slot eq "3">
			  <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter3.png" alt="" border="0">
			  <cfelse>
				30-:44		
			  </cfif>	
			<cfelse>
			  <cfif attributes.icon eq "Yes">
			   <img src="#Client.VirtualDir#/images/logos/attendance/time/quarter4.png" alt="" border="0">
			  <cfelse>
				45-:59		
			  </cfif>				
			</cfif>
									
		</cfcase>
		
</cfswitch>

</cfoutput>