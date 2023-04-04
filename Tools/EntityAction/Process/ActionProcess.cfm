
<cfparam name="url.header" default="0">

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>  

<cfif url.header eq "1">
	
	<cfquery name="get" 
		datasource="AppsOrganization"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT      R.ActionDescription
			FROM        OrganizationObjectAction AS OOA INNER JOIN
			            Ref_EntityActionPublish AS R ON OOA.ActionPublishNo = R.ActionPublishNo AND OOA.ActionCode = R.ActionCode
			WHERE       OOA.ActionId = '#url.id#'
	</cfquery>		
	
	<cf_screenTop height="100%" 
	      band="No" 
		  layout="webapp" 	   
		  banner="gray" 
		  bannerforce="Yes"	 
		  scroll="no" 
	      label="#get.ActionDescription#">
		  
</cfif>	  

<table height="100%" width="100%"><tr><td style="padding-top:10px;height:100%">
	  
<cfoutput>
<iframe src="#SESSION.root#/Tools/EntityAction/ProcessAction.cfm?windowmode=#url.windowmode#&ajaxid=#url.ajaxid#&process=#url.process#&id=#url.id#&myentity=#url.myentity#&mid=#mid#"
width="100%" height="100%" scrolling="no" frameborder="0"></iframe>
</cfoutput>

</td></tr>

<tr><td align="center" style="padding-bottom:8px"><input class="button10g" style="width:200px;height:25px" onclick="parent.window.close()" value="Close" type="button" name="Close"></td></tr>

</table>