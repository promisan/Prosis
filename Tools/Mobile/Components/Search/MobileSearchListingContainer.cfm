<cfparam name="Attributes.recordCount"			default="1">
<cfparam name="Attributes.ElementsPerRow"		default="3">
<cfparam name="Attributes.ElementsLabel"		default="items">

<cfif thisTag.ExecutionMode is "start">

	<cfif Attributes.recordCount gt 0>

		<div class="row">
			<div class="input-group" style="width:100%; padding-left:5%;">
				<cf_tl id="Search over the" var="lblSearch1">
				<cf_tl id="#Attributes.ElementsLabel# found..." var="lblSearch2">
				<cfoutput>
					<input class="form-control" type="text" placeholder="#lblSearch1# #Attributes.recordCount# #lblSearch2#" style="width:95%;" onkeyup="_mobile_searchElement(this.value, '.elementContainer', event);">
					<div class="clsSearchSpinner" style="text-align:center; padding-top:75px; display:none;">
						<i class="fa fa-cog fa-3x fa-spin text-success"></i>
					</div>
				</cfoutput>
			</div>
			<br>
		</div>
		
	<cfelse>

		<cfinclude template="MobileSearchInstructions.cfm">
		
	</cfif>

	<div class="clsListingContainer">

		<div class="row clsListingContainerRow"> 
		<cfset Attributes.ElementsCount = 0>

<cfelse>
	
		</div>

	</div>

</cfif>