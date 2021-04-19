
<cfoutput>

<cfparam name="URL.Mode"    default="Lookup">
<cfparam name="URL.occ"     default="">		
<cfparam name="url.param1"  default="">
<cfparam name="url.edition" default="#url.param1#">


<!--- helper to reload the buckets --->

<input type="hidden" id="scope" value="#url.occ#">		

<cf_tl id="Functional Title" var="1">

<table width="100%" height="100%" class="formspacing">
	<tr>
		<td valign="top" width="270" style="padding:10px">
										
		<cfif URL.Mode eq "Lookup">					
		  <cfset link = "#session.root#/Staffing/Application/Function/Lookup/FunctionTree.cfm?Edition=#url.edition#&Occ=#url.occ#&FormName=#URL.formname#&fldfunctionno=#URL.fldfunctionno#&fldfunctiondescription=#URL.fldfunctiondescription#&Owner=#URL.Owner#&Mode=#URL.Mode#">
		<cfelse>				
		  <cfset link = "#session.root#/Staffing/Application/Function/Lookup/FunctionTree.cfm?Edition=#url.edition#&Occ=#url.occ#&Owner=#URL.Owner#&Mode=#URL.Mode#">
		</cfif>
				
		<iframe src="#link#"
	        name="left" id="left" width="100%" height="99%" scrolling="no" frameborder="0"></iframe>			
					
		</td>
		<td valign="top" height="100%" style="padding:10px;border-left: 1px solid Silver;" id="rightme"></td>
	</tr>
</table>

</cfoutput>