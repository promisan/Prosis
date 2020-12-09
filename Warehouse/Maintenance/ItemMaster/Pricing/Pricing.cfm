
<!--- container --->

<table width="100%" height="99%">
<tr><td>

	<cfparam name="url.mid" default="">
	
	<cfoutput>
	<iframe src="#SESSION.root#/Warehouse/Maintenance/ItemMaster/Pricing/PricingData.cfm?mission=#url.mission#&id=#url.id#&mid=#url.mid#"
        width="100%"
        height="99%"
        scrolling="no"
        frameborder="0"
        border="0"></iframe>
	</cfoutput>
	
</td></tr></table>