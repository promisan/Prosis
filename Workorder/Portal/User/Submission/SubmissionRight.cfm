
<cfif url.serviceitem neq "">

	<cfparam name="url.scope" default="">
	<cfset url.scope = "portal">
	<cfinclude template="../../../Application/WorkOrder/ServiceDetails/Action/ClosingListing.cfm">

<cfelse>
			  
	  <cfquery name="Parameter" 
		datasource="AppsInit">
			SELECT * 
			FROM   Parameter
			WHERE  HostName = '#CGI.HTTP_HOST#'
	  </cfquery>

	  <cfparam name="path" default="#SESSION.root#/Custom/Logon/#Parameter.ApplicationServer#/watermark.png">
		
	  <cfoutput>
		
		
<style>
	td.watermark {
		background-image:url('#path#');
		background-position:top center;
		background-repeat:no-repeat;
		width:100%;
		height:100%;
		background-color:transparent;
		padding-top:20px;
	}
</style>	
		
		<cfif fileExists('#path#')>
			<table cellpadding="0" cellspacing="0" border="0" width="100%" height="80%">
				<tr>				
					<td class="watermark" style="background-image:url('#path#'); background-repeat:no-repeat; background-position:center center">		
									
					</td>
				</tr>
			</table>
		</cfif>
		
	  </cfoutput>

</cfif>

