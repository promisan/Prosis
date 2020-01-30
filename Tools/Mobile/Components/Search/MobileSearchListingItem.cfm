<cfparam name="Attributes.id"				default="">
<cfparam name="Attributes.searchText"		default="">
<cfparam name="Attributes.animation"		default="yes">

<cfset vAnimation = "">
<cfif trim(attributes.animation) eq "yes" or trim(attributes.animation) eq "1">
	<cfset vAnimation = "clsNoAnimation">
</cfif>

<cfif trim(attributes.id) neq "">
	<cfset vOnClick = "_mobile_showElement('#Attributes.id#');">
</cfif>

<cfset vColorArray = ['hyellow','hred','hgreen','hblue','hviolet','horange','hreddeep','hnavyblue']>
<cfset vColor = vColorArray[RandRange(1, 8, "SHA1PRNG")]>

<cfset rootMobileSearchListingContainerTag = getbasetagdata("CF_MOBILESEARCHLISTINGCONTAINER")>
<cfset Attributes.ElementsPerRow = rootMobileSearchListingContainerTag.attributes.ElementsPerRow>

<cfif thisTag.ExecutionMode is "start">

	<cfoutput>
		<div class="col-lg-#12/Attributes.ElementsPerRow# animated-panel zoomIn elementContainer" onclick="#vOnClick#">
			<div class="searchable" style="display:none;">#Attributes.searchText#</div>
			<div class="hpanel #vColor# contact-panel" style="cursor:pointer;">
		        <div class="panel-body #vAnimation#">		
	</cfoutput>
    
<cfelse>

	        </div>
	    </div>
	</div>

	<cfset rootMobileSearchListingContainerTag.attributes.ElementsCount = rootMobileSearchListingContainerTag.attributes.ElementsCount + 1>
	<cfif rootMobileSearchListingContainerTag.attributes.ElementsCount eq Attributes.ElementsPerRow>
		<cfset rootMobileSearchListingContainerTag.attributes.ElementsCount = 0>
		</div>
		<div class="row clsListingContainerRow">
	</cfif>

</cfif>