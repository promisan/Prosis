<cfparam name="attributes.id"		default="tblDataTable">
<cfparam name="attributes.length"	default="10">

<cfif thisTag.ExecutionMode is "start">
	<cfoutput>
		<div class="table-responsive">
			<table id="#attributes.id#" class="table table-striped table-bordered table-hover" data-page-length="#attributes.length#">
	</cfoutput>
<cfelse>
	<cfoutput>
			</table>	
		</div>
	</cfoutput>
</cfif>	