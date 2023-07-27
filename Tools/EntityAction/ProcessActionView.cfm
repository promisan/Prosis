
<cfparam name="url.header" default="0">

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cfif url.header eq "1">
	
	<cfquery name="get" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT      OOA.ActionStatus, R.ActionDescription
			FROM        OrganizationObjectAction AS OOA INNER JOIN
			            Ref_EntityActionPublish AS R ON OOA.ActionPublishNo = R.ActionPublishNo AND OOA.ActionCode = R.ActionCode
			WHERE       OOA.ActionId = '#url.id#'
	</cfquery>	
				
	<cf_screenTop height="100%" 
	      band="No" 
		  layout="webapp" 	   
		  banner="gray" 
		  bannerforce="Yes"	 
		  jquery="Yes"
		  scroll="no" 
	      label="#get.ActionDescription#">
		  
		  
		  
</cfif>	  

<cfoutput>
	  
<table style="width:100%;height:100%">
	
	<tr><td style="height:100%;width:100%">  
	
	<iframe src="#SESSION.root#/Tools/EntityAction/ProcessAction.cfm?windowmode=#url.windowmode#&ajaxid=#url.ajaxid#&process=#url.process#&id=#url.id#&myentity=#url.myentity#&mid=#mid#"
	width="100%" height="100%" scrolling="no" frameborder="0"></iframe>	
	
	</td></tr>
	
	<cfif url.header eq "1">
	
		<cf_tl id="Close" var="1">
		<tr><td align="right" style="border-top:1px solid silver;padding-bottom:4px;padding-right:4px;height:30px;padding-top:4px;">
		<input class="button10g" style="width:200px;height:25px" onclick="window.close()" value="#lt_text#" type="button" id="closeactiondialog" name="Close">
		</td></tr>
		
	</cfif>

</table>

</cfoutput>