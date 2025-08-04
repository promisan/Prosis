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

<cfoutput>
	
	<script language="JavaScript">
	
		function reload(src) {
			  ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingTreeDetail.cfm?search='+src+'&id=#URL.ID#','treedet')  
		}
			
		function del(access,id,con,mis,man,mod,box,src) {		     
			  _cf_loadingtexthtml='';	
		      ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingDelete.cfm?box='+box+'&id='+id+'&id1='+con+'&mis='+mis+'&man='+man+'&mod='+mod+'&search='+src+'&accessid='+access,box)  
		}		
		
		function sync(grp,id,con,mis,man,mod,box,src) {
		      ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingSyncGroup.cfm?box='+box+'&id='+id+'&id1='+con+'&mis='+mis+'&man='+man+'&mod='+mod+'&search='+src+'&group='+grp,box)  
		}		
		
		function clearno() { 
		      document.getElementById("find").value = "" 
		}
	
		function search() {
			  se = document.getElementById("find")
			  if (window.event.keyCode == "13") {
			     document.getElementById("locate").click()
			  }				
	    }
		
		function more(bx,con,mis,man,mod,src) {    
		  
		   icM  = document.getElementById(con+bx+"Min");
		   icE  = document.getElementById(con+bx+"Exp");
		   box  = document.getElementById("i"+con+bx);
		   if (icM.className == "hide") {
			     icM.className = "regular";
				 icE.className = "hide";
				 box.className = "regular"
				 ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingDetail.cfm?box=i'+con+bx+'&id=#URL.ID#&id1='+con+'&mis=' + mis + '&man=' + man + '&mod=' + mod + '&search='+src,'i'+con+bx)  
		    } else {
			     icM.className = "hide";
				 icE.className = "regular"; 
				 box.className = "hide"     
		       }
		    }	
	
	    function restore(accessid,id,id1,search,mod,mis,man,box) {
		    ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessGroupReinstate.cfm?accessid='+accessid+"&id="+id+"&id1="+id1+"&search="+search+"&mod="+mod+"&mis="+mis+"&man="+man+"&box="+box,box)
		}
		
	    function showrole(role) {
			w = #CLIENT.width# - 200;
			h = #CLIENT.height# - 250;
			ptoken.open("#SESSION.root#/System/Access/Global/OrganizationRolesView.cfm?Class=" + role, "_blank", "left=40, top=40, width=" + w + ", height= " + h + ", toolbar=no, status=yes, scrollbars=yes, resizable=no")
		}
		
		var tmis = ""
		var tman = ""
		var torg = ""		
		var tcon = ""	
		var tbox = ""	
		var tmod = ""	
		var tsrc = ""	
				
		function process(mis,org,role,con,box,man,mod,src) {
		
		    tmis = mis
			tman = man
			torg = org			
			tcon = con		    
			tmod = mod
			tbox = box
			tsrc = src
								         
			ProsisUI.createWindow('myaccess', 'Access', '',{x:100,y:100,height:document.body.clientHeight-110,width:document.body.clientWidth-110,maxWidth:800,modal:true,center:true})    							
			ptoken.navigate(root + '/System/Organization/Access/UserAccessView.cfm?box='+box+'&ID2='+org+'&Mission='+mis+'&ACC=#URL.ID#&ID='+role+'&ID1='+con,'myaccess') 		
		}  
		
		function refreshaccess() {			   		   
 		   ptoken.navigate('#SESSION.root#/System/Organization/Access/UserAccessListingDetail.cfm?box='+tbox+'&id=#URL.ID#&id1='+tcon+'&mis=' + tmis + '&man=' + tman + '&mod=' + tmod + '&search='+tsrc,tbox)  
    	}
		
				  
	</script>
	
</cfoutput>
