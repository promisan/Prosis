<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->

<script language="JavaScript">
	  
	 function hlx(itm,fld) {			 
	 	try {
			var pp = $(itm);
			if (fld) {
				pp.not(".selectedhl").attr("class", "highlight");
			}
			else {
				pp.not(".selectedhl").attr("class", "regular1");
			}
		}catch(e){}		
	  }
	  
	function check(s,template)  {  	    	
	    alert(template)		
	  }
	  
	function loadform(template,target,option,idmenu)  { 
		if (template.indexOf("?") >= 0) 	    	
	    	ptoken.open(template+"&ts="+new Date().getTime()+"&idmenu="+idmenu, target)
	    else
	    	ptoken.open(template+"?ts="+new Date().getTime()+"&idmenu="+idmenu, target)  
	  }


	function selected(opt) { 
		var se = $(".selectedhl");
		
		se.each(function() {
			se.attr("class", "regular1");				
			});
	    opt.className = "selectedhl"
	    
	  }
	  
	function subMenuLeftToggle(id, idTwistie, collapseImg, expandImg) {
		$('#'+id).toggle(function(){ 
			if ($('#'+id).is(':visible')) { 
				$('#'+idTwistie).attr('src',collapseImg); 
			} else { 
				$('#'+idTwistie).attr('src',expandImg); 
			} 
		});
	}

</script>

<cfoutput>

<style>

	table.highLight {
		BACKGROUND-COLOR: C9D3DE;
		color : black;
		border : Black;
		font-weight : bolder;
		background-position:top right; 
		background-repeat:repeat-y;
	}
	
	table.selectedhl {
		color: red;
		Background-image:url(#SESSION.root#/Images/Options_bg.png);
		Background-position: right;
		Background-repeat:no-repeat;
		font-weight : bolder;
	}
	
	table.regular1 {
		background-position:top right; 
		background-repeat:repeat-y;
		}

	
</style>

</cfoutput>