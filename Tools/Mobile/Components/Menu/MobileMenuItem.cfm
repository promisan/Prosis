<cfparam name="attributes.active"		default="0">
<cfparam name="attributes.parent"		default="0">
<cfparam name="attributes.reference"	default="##">
<cfparam name="attributes.description"	default="--">
<cfparam name="attributes.badge"		default="">
<cfparam name="attributes.style"		default="">
<cfparam name="attributes.badgeColor"	default="label-success">


<cfset vActive = "">
<cfif trim(lcase(attributes.active)) eq "1" or trim(lcase(attributes.active)) eq "yes">
	<cfset vActive = "active">
</cfif>

<cfif thisTag.ExecutionMode is "start">

	<cfoutput>
	
		<li class="#vActive#" style="#attributes.style#">
		
		<a href="#attributes.reference#">
			<cfif trim(lcase(attributes.Parent)) eq "1" or trim(lcase(attributes.Parent)) eq "yes">
				<span class="nav-label">#attributes.description#</span><span class="fa arrow"></span>
			<cfelse>
				#attributes.description# 
				<cfif trim(attributes.badge) neq "">
					<span class="label #attributes.badgeColor# pull-right">#attributes.badge#</span>
				</cfif>
			</cfif>
		</a>
  
	</cfoutput>

<cfelse>
	</li>
</cfif>	