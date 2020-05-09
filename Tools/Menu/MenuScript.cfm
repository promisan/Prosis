<cfparam name= "attributes.Library" default="No">

<cfif attributes.Library eq "Yes">
	
	<script>
	
	disabled = false;
	
	function set_style() {
	
			vdata = $(".dbutton");
			$(vdata).each(function() {	
	
			  var oname = $(this).attr('name');
			  
			  oname = oname.substr(1,oname.length);
			  
			  var id = $('#id_'+oname).val();  		  
			  
			  $('#'+oname).removeClass('bactive');
			  $('#'+oname).removeClass('binactive');	

			  if ($('#'+oname).attr('disabled') == 'disabled') {
					  
				  $('#'+oname).removeClass('bactive');
				  $('#'+oname).addClass('binactive');	
				  
				  $('#'+oname+'_text').removeClass('tactive');
				  $('#'+oname+'_text').addClass('tinactive');
				  
				  $('#'+id).removeClass('highlight');
				  $('#'+id).removeClass('regular');

				  $('#'+id).unbind('mouseover');
				  $('#'+id).unbind('mouseout');
				  
 					  $('#i'+oname).removeClass('iactive');
 					  $('#i'+oname).addClass('iinactive');
				
			 } else {

				  $('#'+oname).removeClass('binactive');
				  $('#'+oname).addClass('bactive');	
				  
				  $('#'+oname+'_text').removeClass('tinactive');
				  $('#'+oname+'_text').addClass('tactive');				  

				  $('#'+id).bind('mouseover',function(){

					$(this).removeClass('regular');
					$(this).addClass('highlight');					
						
					});

				   $('#'+id).bind('mouseout',function() {
						$(this).removeClass('highlight');
						$(this).addClass('regular');
					});		
					
 					  $('#i'+oname).addClass('iactive');
 					  $('#i'+oname).removeClass('iinactive');
							 
			 }
			});		
	}
	
	$(document).ready(function() {
		set_style(); 
	});
	</script>

</cfif>

<script language="JavaScript1.1">
	
	function mainmenu(base,baseitem,target,targetitem,classsel) {					

		    if (targetitem != "") {						 			    		 
			 cnt=1 			 
			 se = document.getElementsByName(base+cnt)	  
		 				 
		     while (se[0]) {		 
			 		 			      
				  if (cnt == baseitem) {			   		  	
				    document.getElementById(base+cnt).className = "highlight"
				  } else {			  	
				    document.getElementById(base+cnt).className = "regular"
				  }		      
				  cnt++				  
				  se = document.getElementsByName(base+cnt)	  	 
			 }		 
					
			 cnt=1 
			 	  
			 se = document.getElementsByName(target+cnt)			 		 
			 while (se[0]) {		   		 							  		  
				  if (cnt == targetitem) {				  	
				    document.getElementById(target+cnt).className = "regular"
				  } else {
				    document.getElementById(target+cnt).className = "hide"
				  }				      
				  cnt++				  			  
				  se = document.getElementsByName(target+cnt)				    	 
			 }  			 
			}  	
		}	
			
		function selectrow(itm,row,tot) {		
			var cnt = 0	
			while (cnt != tot) {
			   cnt++	 
			   se = document.getElementById(itm+cnt)
			   if (se.className == "highlight1") {
			       se.className = "regular"
			    }	   
			}
			document.getElementById(itm+row).className = "highlight1"   	
			
		}
		
		function menutab(id,vis) {
		  if (vis == 0) {
		    document.getElementById(id).className = "hide"
			} else {
			document.getElementById(id).className = "regular"
			}
		}				
				
		function drilldownbox(element,url,vir,mode) {
					
			box = document.getElementById(element+'_box')
			cnt = document.getElementById(element+'_content')
			img = document.getElementById(element+'_twistie')		
			
			if   (box.className == "regular" && mode != 'force') {		
			
			     box.className = "hide"		
		         _cf_loadingtexthtml='';	
			     ptoken.navigate(vir+'/tools/empty.cfm',element+'_content')  		   
			     img.src = vir+"/Images/arrowright.gif"		   
			     _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
			
			} else {		
			
			     box.className = "regular"	   
			     _cf_loadingtexthtml='';	
			     ptoken.navigate(vir+'/'+url,element+'_content')  
			     img.src = vir+"/Images/arrowdown.gif"		   
			     _cf_loadingtexthtml="<div><img src='<cfoutput>#SESSION.root#</cfoutput>/images/busy11.gif'/>";
				 
			}
			
		}
			
</script>

<style>

.bactive {
	background-color:transparent; 
	border:0px solid silver; 
	padding:3px;
	cursor: pointer;
	width:150px;
}

.binactive {
	background-color:transparent; 
	border:0px solid f9f9f9; 
	padding:3px;
	cursor: default;
	width:150px;
}

.tinactive {
	color : silver;
}

.tactive { 
}

.iinactive {
	filter: alpha ( opacity = 30 ); 
	opacity: 0.3; 
	-moz-opacity:0.3;
}

.iactive {
	filter: alpha ( opacity = 100 ); 
	opacity: 1; 
	-moz-opacity:1;
}

</style>