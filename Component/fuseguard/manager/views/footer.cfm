<cfparam name="request.isAuthenticated" default="false">
</div>
<cfif IsBoolean(request.isAuthenticated) AND request.isAuthenticated>
<div id="footer">
	Copyright &copy; <a href="http://foundeo.com/">Foundeo Inc.</a> 2009-<cfoutput>#Year(Now())#</cfoutput>. Icons by <a href="http://glyphish.com/">Glyphish</a> &amp; <a href="http://www.famfamfam.com/lab/icons/silk/">FamFamFam</a>
	| <cfoutput><a href="#request.urlBuilder.createDynamicURL('logout')#">Logout</a></cfoutput>
</div>
</cfif>
<cfsilent>
	<cfset js = StructNew()>
	<cfset js.excanvas = "views/scripts/excanvas.compiled.js">
	<cfset js.all = "views/scripts/all.js">
	<cfif StructKeyExists(request, "urlBuilder")>
		<!--- there may be cases where footer is called but urlBuilder is not defined due to misconfiguration --->
		<cfset js.excanvas = request.urlBuilder.createStaticURL(js.excanvas)>
		<cfset js.all = request.urlBuilder.createStaticURL(js.all)>
		
	</cfif>
</cfsilent>
<cfoutput>
<!--[if IE]><script type="text/javascript" src="#XmlFormat(js.excanvas)#"></script><![endif]-->
<script type="text/javascript" src="#XmlFormat(js.all)#"></script>
</cfoutput>
</body></html>