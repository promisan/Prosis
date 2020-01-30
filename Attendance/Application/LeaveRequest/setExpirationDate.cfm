
<cfset dateValue = "">
<CF_DateConvert Value="#url.selected#">
<cfset STR = dateValue>

<CF_DateConvert Value="#url.val#">
<cfset END = dateValue>

<cfparam name="session.agentrun" default="">
<cfset prior = session.agentrun>

<cfset session.agentrun = now()>

<cfoutput>

	<cfif STR gt END and url.mde eq "1">
	
		<script>
		 document.getElementById('#url.fld#').value = '#dateformat(STR+1,client.dateformatshow)#'			 	 				 
		</script>
		
					
	</cfif>
		
	<cfif prior eq session.agentrun>
	
	      <!--- nada --->
	
	<cfelse>
		
	<script>			    
		getinformation('#url.id#')
	</script>
	
	</cfif>

</cfoutput>


