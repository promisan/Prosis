<cfparam name="attributes.loadStyle" 	default="yes">
<cfparam name="attributes.loadScript" 	default="yes">

<cfif attributes.loadStyle eq "yes">

	<style>
		.pane_clsSummaryPanelContainer {
			width:							100%;
			padding:						10px;
			overflow:						auto;
			margin-top:						10px;
		}
		
		.pane_clsSummaryPanelItem {
			height:							225px;
			width:							15%;
			min-width:						250px;
			overflow:						auto;
			float:							left;
			position:						relative;
			padding:						10px;
			margin-left:					5px;
			margin-bottom:					5px;
			text-align:						center;
			border:							1px solid #C0C0C0;
			
			-webkit-transition: 			all .6s ease;
			-moz-transition: 				all .6s ease;
			-o-transition: 					all .6s ease;
    		transition: 					all .6s ease;
		}
		
		.pane_clsSummaryPanelItemRefresh {
			text-align:						right;
			padding-bottom:					5px;
		}
		
		.pane_clsSummaryPanelItemRefresh img {
			cursor:							pointer;
		}
		
		.pane_clsSummaryPanelItemPrint {
			text-align:						right;
			padding-bottom:					5px;
		}
		
		.pane_clsSummaryPanelItemPrint img {
			cursor:	pointer;
		}
	
	</style>

</cfif>

<cfif attributes.loadScript eq "yes">

	<script language="JavaScript">
	
		function _pane_resizeMenuItems(minItemSize, pOffSet) {
			var minMenuItemSize = minItemSize;
			var containerWidth = $('.pane_clsSummaryPanelContainer').first().width();
			var newMenuItemWidth = 1;
			var itemsInContainer = containerWidth / minMenuItemSize;
			var itemsInRow = Math.floor(itemsInContainer);
			
			if($('.pane_clsSummaryPanelItem').length < itemsInContainer) {
				itemsInRow = $('.pane_clsSummaryPanelItem').length;
			}
			
			//Recaluculate the new width
			if(itemsInContainer < 1) {
				newMenuItemWidth = minMenuItemSize;
			} else {
				if ((itemsInContainer % 1) === 0) {
					newMenuItemWidth = minMenuItemSize;
				}else {
					newMenuItemWidth = (containerWidth / itemsInRow) - pOffSet; 
				}
			}
			
			//Set the new width
			$('.pane_clsSummaryPanelItem').width(newMenuItemWidth);
		}
		
		function _pane_refresh(systemFunctionId,id) {		
			$('#content_'+systemFunctionId+'_'+id+'_refresh').click();
		}
		
	</script>

</cfif>