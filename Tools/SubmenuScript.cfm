<!--
    Copyright © 2025 Promisan B.V.

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
<cfoutput>

<cfif CGI.HTTPS eq "off">
	<cfset tpe = "http">
<cfelse>	
	<cfset tpe = "https">
</cfif>

<cfajaximport>

<script language="JavaScript">
	
	function modulelog(id,mis) {	    
		 ptoken.navigate('#SESSION.root#/Tools/SubmenuLog.cfm?systemfunctionid='+id+'&mission='+mis,'modulelog')
	}
	
	ie = document.all?1:0
	ns4 = document.layers?1:0
	
	w = 0
	h = 0
	if (screen) {
		w = #CLIENT.width# - 55
		h = #CLIENT.height# - 120
	}
	
	function hl(itm,fld,name){	
		
	     if (ie){
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentElement;}
	     }else{
	          while (itm.tagName!="TABLE")
	          {itm=itm.parentNode;}
	     }
		 	 	 		 	
		 if (fld != false){
			
			 itm.className = "highLight1 formpadding";
			 itm.style.cursor = "pointer";
			 self.status = name;
			 
		 }else{
			
		     itm.className = "regularZ formpadding";		
			 itm.style.cursor = "";
			 self.status = name;
		 }
	  }
	  
	function recordedit(id1,mis) {
		ptoken.open("#SESSION.root#/System/Modules/Functions/RecordEdit.cfm?ID=" + id1 + "&mission=" + mis, "functionsetting"+id1);	
	}
	
	function logging(id1,mis) {
		var w = 1024;
		var h = 900;
		var left = (#CLIENT.widthfull#/2)-(w/2);
		var top = (#CLIENT.height#/2)-(h/2);
		ptoken.open('#SESSION.root#/System/Modules/Functions/Logging/RecordListing.cfm?ID=' + id1 + '&mission=' + mis + '&ts=' + new Date().getTime(), '_blank', 'top=' + top + ', left='+left + ', width=' + w + ', height=' + h + ', status=no, center=yes, toolbar=no, scrollbars=yes, resizable=yes');
	}
	
	function favorite(act,id,mis,own,con) {
	    ptoken.navigate('#SESSION.root#/Tools/Favorite.cfm?action='+act+'&systemfunctionid='+id+'&mission='+mis+'&owner='+own+'&condition='+con,'fav_'+id+'_'+mis)
	}  
	    
	function loadformI(name,cond,target,dir,idmenu,idrefer,reload,vir,host) { 	
					 
	   if (target != "newfull") {	 
	     w = #CLIENT.width# - 60;
		 full = "no";
	   } else {
	     w = #CLIENT.widthfull# - 70;
		 full = "yes"
	   }   
	            
	   h = #CLIENT.height# - 120;      
	   ih = document.body.offsetHeight-50   
	         
	   if (target == "right") { target = "portalright" }
	      
	   if (host == "") {
	       
		   if (dir == "") { 
		  	   if (vir == "default") { 
			   loc = name 
			   } else {
			   loc = "#tpe#://#CGI.HTTP_HOST#/"+vir+"/"+name }	   
		   } else { 
		      if (vir == "default") { 
			   loc = "#SESSION.root#/"+dir+"/"+name 
			   } else {
			   loc = "#tpe#://#CGI.HTTP_HOST#/"+vir+"/"+dir+"/"+name
			   }
		   }	  
		   
		} else {	
		
		   if (dir == "") { 
		  	   if (vir == "default") { 
			   loc = host+"/"+name		 
			   } else {
			   loc = host+"/"+vir+"/"+name
			   }	   
		   } else { 
		      if (vir == "default") { 
			   loc = host+"/"+dir+"/"+name	
			   } else {
			   loc = host+"/"+vir+"/"+dir+"/"+name			  
			   }
		   }	  	   
		
		}				
			   	  
	   if (reload == 1) {  
	           	   		  
		   if (cond == "") {  
		       if (target != "portalright") {		      		      
			      if (target == "_new") {
				    ptoken.open(loc+"?idmenu="+idmenu+"&ts="+new Date().getTime()+"&idrefer="+idrefer+"&height="+h, "_blank") 			
				  } else {
			        ptoken.open(loc+"?idmenu="+idmenu+"&ts="+new Date().getTime()+"&idrefer="+idrefer+"&height="+h, "_blank","left=20, top=20, width=" + w + ", height= " + h + ", fullscreen=" + full+ ",status=yes, toolbar=no, scrollbars=yes, resizable=yes") 
				  }
		       } else {
			  
			 
			   
		       ptoken.open(loc+"?idmenu="+idmenu+"&ts="+new Date().getTime()+"&idrefer="+idrefer+"&height="+h, target) 
			   }
			   
		   } else {  
		 		  	  	  	  	
			   if (target != "portalright" && target != "_new") {		  
		    	   ptoken.open(loc+"?idmenu="+idmenu+"&"+cond+"&ts="+new Date().getTime()+"&idrefer="+idrefer+"&height="+h, "_blank","left=20, top=20, width=" + w + ", height= " + h + ", fullscreen=" + full+ ", status=yes, toolbar=no, scrollbars=yes, resizable=yes")    
			   } else {		
		    	   ptoken.open(loc+"?idmenu="+idmenu+"&"+cond+"&idrefer="+idrefer+"&height="+h, idmenu) 
			   }   
		   }   
		   
	   } else { 	     
			 
	    if (cond == "") {  
		   ptoken.open(loc+"?idmenu="+idmenu+"&idrefer="+idrefer+"&height="+ih, target,"left=20, top=20, width=" + w + ", height= " + h + ", fullscreen=" + full+", status=yes, toolbar=no, scrollbars=yes, resizable=yes") 
		} else {	 
		   ptoken.open(loc+"?idmenu="+idmenu+"&"+cond+"&idrefer="+idrefer+"&height="+ih, target,"left=20, top=20, width=" + w + ", height= " + h + ", fullscreen=" + full+", status=yes, toolbar=no, scrollbars=yes, resizable=yes") }
	   }   
	   
	 } 
 
</script> 

</cfoutput> 