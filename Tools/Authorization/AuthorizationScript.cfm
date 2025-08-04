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
		
		function openauthorization(mis,sys,obj,cls) {
			ProsisUI.createWindow('authorizationwindow', 'Authorization','',{x:100,y:100,height:135,width:400,modal:true,center:true,resizable:false})   
					 
	        ptoken.navigate('#SESSION.root#/Tools/Authorization/AuthorizationEntry.cfm?mission='+mis+'&systemfunctionid='+sys+'&object='+obj+'&objectclass='+cls, 'authorizationwindow');	
		}
		
		function setauthorization(mis,sys,obj,cls,val) {	     
		     ptoken.navigate('#SESSION.root#/Tools/Authorization/AuthorizationSubmit.cfm?mission='+mis+'&systemfunctionid='+sys+'&object='+obj+'&objectclass='+cls+'&val='+val, 'authorizationwindow');	
		}
		
		function search(e) {
		  	      
		   keynum = e.keyCode ? e.keyCode : e.charCode;	   	 							  
		   if (keynum == 13) {
		      document.getElementById("autsubmit").click();
		   }		
		   
		  } 				    
				
	</script>

</cfoutput>