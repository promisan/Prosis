<cfparam name="url.title" default="Nova Modification Management">
<cfparam name="attachment" default="">
<cfparam name="fileattachment" default="">
<cfparam name="url.msg" default="">


<cfoutput>
	<cfif attachment neq "">	
		<cffile action="upload"
			filefield="attachment"
			destination="d:\uploads\"
			nameconflict="err">	
		<cfset fileattachment = "d:\uploads\#file.serverfile#">
	</cfif>

    <cfquery name="Parameter"  datasource="AppsInit">
		SELECT SystemContactEmail
		FROM   Parameter
		WHERE  HostName = '#CGI.HTTP_HOST#'
    </cfquery>		

    <cfset mailto = Parameter.SystemContactEmail>
	
	<cfif IsValid("email",#mailfrom#) AND cbody is not "">
		<cfmail to = "#mailto#" from = "#mailFrom#" subject = "#infoabout#">
		
			<cfsilent>
				<cfif fileattachment neq "">
					<cfmailparam file="#fileattachment#">
				</cfif>
				<cfmailparam name = "Importance" value = "#Priority#">
			</cfsilent>
			
	This is an automatic mail from the #url.title# Portal
	= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
	
	#fname# with IndexNo. #indexno#<cfif account neq "">, System account "#account#"</cfif> <cfif telephone neq "">and Telephone number #telephone#,</cfif> wrote the following in regard to "#infoabout#" in Server: #system# and Module: #module#.
	
	#cbody#
	
	_____________________________________________
	#fname# email is #mailFrom#, (you can also just reply to this mail).
		</cfmail>    
		<cfset url.msg = "no">
	<cfelse>
		<cfset url.msg = "yes">
	</cfif>    
	
	
	<script>
		ColdFusion.navigate ('#SESSION.root#/System/Portal/Support/SupportView.cfm?msg=#url.msg#','menucontent')
	</script>


</cfoutput>

