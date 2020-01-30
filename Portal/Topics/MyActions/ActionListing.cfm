<cf_screentop html="no" jquery="yes">

<cf_ListingScript>

<cfoutput>
<script>
function process(id) {
	   window.open("#SESSION.root#/ActionView.cfm?id=" + id, "_blank", "left=20, top=20, width=" + w + ", height= " + h + ", toolbar=no, menubar=no, status=no, scrollbars=no, resizable=yes");	   
	}
</script>
</cfoutput>

<cfinclude template="ActionListingContent.cfm">



	