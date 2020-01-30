
<!--- script for highlight and select of lines --->

<cfoutput>
    
	<!--- removed by hann0 as we have it differently 
	<script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script>
	--->
	
	<script>
	
		var __ProsisPresentation_currentLine = 1;
		
		function __ProsisPresentation_RGBtoHEX(color){
			if (color.substr(0, 1) === '##') {
		        return color;
		    }
		    rgb = color.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
 			return "##" +
				  ("0" + parseInt(rgb[1],10).toString(16)).slice(-2) +
				  ("0" + parseInt(rgb[2],10).toString(16)).slice(-2) +
				  ("0" + parseInt(rgb[3],10).toString(16)).slice(-2);
		}
	
		function __ProsisPresentation_HighlightRow(prefix, id, color){
			$('##'+prefix+id).attr('bgColor', '##'+color);
		}
		
		function __ProsisPresentation_PreventScrolling(e){
			var key = e.keyCode ? e.keyCode : e.charCode;
			if (key == 40 || key == 38) { 
				return false;
			}
			return true;
		}
		
		function __ProsisPresentation_HighlightNextRow(tableList, prefix, id, color, e){
			var vTest = 0;
			var key = e.keyCode ? e.keyCode : e.charCode;
			
			if (key == 40 || key == 38) { 
				if (key == 40) { vTest = __ProsisPresentation_currentLine + 1; }
				if (key == 38) { vTest = __ProsisPresentation_currentLine - 1; }
				if ($('##'+prefix+vTest).length > 0) { __ProsisPresentation_currentLine = vTest; }
				
				$('##'+tableList+' tr').css('background-color', '');
				$('##'+prefix+__ProsisPresentation_currentLine).css('background-color', '##'+color);
			}
		}
		
		function __ProsisPresentation_ClearHighlightRow(prefix, id){
			$('##'+prefix+id).attr('bgColor', '');
		}
		
		function __ProsisPresentation_SelectRow(tableList, multiselect, prefix, id, color){
			__ProsisPresentation_currentLine = parseInt(id);
			if (__ProsisPresentation_RGBtoHEX($('##'+prefix+id).css('background-color')).toUpperCase() == '##'+color.toUpperCase()) {
				$('##'+prefix+id).css('background-color', '');
			}else{
				if (multiselect == 0) { $('##'+tableList+' tr').css('background-color', ''); }
				$('##'+prefix+id).css('background-color', '##'+color);
			}
		}
		
		/*To support Chrome*/
		//document.getElementById("myListing").addEventListener("keyup", __ProsisPresentation_HighlightNextRow);
        //document.getElementById("myListing").focus();
		
	</script>
</cfoutput>