<cfparam name="URL.Option"	 		default="">
<cfparam name="Attributes.Option" 	default="#URL.Option#">

<cfparam name="URL.Page" 			default="">
<cfparam name="Attributes.page" 	default="#URL.Page#">

<cfparam name="URL.Position" 		default="">
<cfparam name="Attributes.Position" default="#URL.Position#">


<cfif Attributes.page neq "">
	<cfif NOT IsDefined("SESSION.BreadCrumb")>
		<cfset SESSION.BreadCrumb = ArrayNew(1) >
	</cfif>
	
	<cfset l = ArrayLen(SESSION.BreadCrumb)>
	<cfif l gt 50>
		<!--- if our breadcrumb list is greater than 50 then we remove the very first 20--->
		<cfloop from="1" to="30" index="i">
			<cfset ArrayDeleteAt(SESSION.BreadCrumb, 1)>		
		</cfloop>
	
	</cfif>
	<cfset ArrayAppend(SESSION.BreadCrumb,"#attributes.page#")>	
</cfif>


<cfif Attributes.Position neq "">
	<cfoutput>
	<input type="hidden" id="callbacktype" name="callbacktype" value="#Attributes.Position#">
	<cfswitch expression="#Attributes.Position#">
		<cfcase value="Last">
			<cfif IsDefined("SESSION.BreadCrumb")>
				<cfset l = ArrayLen(SESSION.BreadCrumb)>
				<input type="hidden" id="callback" name="callback" value="#URLDecode(Session.BreadCrumb[l])#">
			<cfelse>
				<input type="hidden" id="callback" name="callback" value="">	
			</cfif>				 							
		</cfcase> 
		<cfcase value="SelectedOption">
			<cfif IsDefined("SESSION.BreadCrumbOption")>
				<cfset l = ArrayLen(SESSION.BreadCrumbOption)>
				<input type="hidden" id="callback" name="callback" value="#URLDecode(Session.BreadCrumbOption[l])#">
			<cfelse>
				<input type="hidden" id="callback" name="callback" value="">	
			</cfif>				 							
		</cfcase>			
	</cfswitch>
	</cfoutput>
</cfif>

<cfif Attributes.Option neq "">
	<cfif NOT IsDefined("SESSION.BreadCrumbOption")>
		<cfset SESSION.BreadCrumbOption = ArrayNew(1) >
	</cfif>
	<cfset l = ArrayLen(SESSION.BreadCrumbOption)>
	<cfif l gt 50>
		<!--- if our breadcrumbOption list is greater than 50 then we remove the very first 20--->
		<cfloop from="1" to="30" index="i">
			<cfset ArrayDeleteAt(SESSION.BreadCrumbOption, 1)>		
		</cfloop>
	</cfif>
	<cfset ArrayAppend(SESSION.BreadCrumbOption,"#attributes.Option#")>
</cfif>


