<cfquery name="getElement" 
	datasource="AppsMaterials">	
		SELECT 	*
		FROM 	Item
		WHERE	ItemNo = '#url.reference#'
</cfquery>

<cfoutput>
	<div class="clearfix">
		<div class="pull-left" style="padding-right:20px;">
			<a href="javascript:enlargePicture('.elementPicture_#getElement.itemNo#');">
				<cfset vName = getElement.itemNo>
				<cfinclude template="getPicture.cfm">
		        <cf_tl id="Zoom in/out" var="1">
		        <div 
					title="#lt_text#" 
					class="img-circle clsRoundedPicture clsEnableTransition elementPicture_#getElement.itemNo#" 
					style="background-image:url('#vPhoto#'); height:75px; width:75px; border:3px solid ##808080;"></div>
		    </a>
		</div>
		<div class="clsElementHeader">
			[#getElement.ItemNo#] #getElement.ItemDescription#
			<div style="font-size:35%;"><b><cf_tl id="Classification">:</b> #getElement.Classification# | <b><cf_tl id="Color">:</b> #getElement.ItemColor# | <b><cf_tl id="Shipment">:</b> #getElement.ItemShipmentMode#</div>
		</div>
	</div>
</cfoutput>