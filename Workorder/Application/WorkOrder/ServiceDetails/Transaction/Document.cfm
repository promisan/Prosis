
<cfparam name="url.scope" default="edit">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
  <cfif url.scope eq "entry">
	<iframe src="#session.root#/workorder/application/workorder/ServiceDetails/Transaction/DocumentForm.cfm?scope=entry&mission=#url.mission#&workorderid=#url.workorderid#&workorderline=#url.workorderline#" 
	  width="100%" height="100%" frameborder="0"></iframe>
  <cfelse>
   <iframe src="#session.root#/workorder/application/workorder/ServiceDetails/Transaction/DocumentForm.cfm?scope=edit&drillid=#url.drillid#" 
	  width="100%" height="100%" frameborder="0"></iframe>  
  </cfif>	  
</td></tr>
</table>
</cfoutput>