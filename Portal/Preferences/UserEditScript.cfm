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

	<script>
	
		function task(val,fld) {
		 if (val == false) {
		   document.getElementById(fld).disabled = true
		 } else {
		   document.getElementById(fld).disabled = false
		 }  		
		}
		
		function _userlocate(ret,params) {
		
			 if (ret) {	
			    val = ret.split(";") 
				document.getElementById(params[0]).value = val[0];
			    document.getElementById(params[1]).value = val[1];
				document.getElementById(params[2]).value = val[2];
				document.getElementById(params[3]).value = val[3];				     	
		    }		
		}
				
		function pref(id) {
		  _cf_loadingtexthtml='';	
		  Prosis.busy('yes')
		  ptoken.navigate(id,'contentbox1')
		}		
	
		function prefsubmit(val) {				
			document.formsetting.onsubmit() 			
			if( _CF_error_messages.length == 0 ) {  
			   Prosis.busy('yes')           
			   ptoken.navigate('UserEditSubmit.cfm?showLDAPMailbox=#url.showLDAPMailbox#&id='+val,'process','','','POST','formsetting')
			}   
		}	 
		
		function passwordsubmit(id,lnk,win,pic,bck) {
		
			document.passwordform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {  
			   ptoken.navigate('#SESSION.root#/Portal/Selfservice/SetInitPasswordSubmit.cfm?id='+id+'&link='+lnk+'&window='+win+'&showPicture='+pic+'&showBack='+bck,'contentbox1','','','POST','passwordform')
			}   
			
		}	
		
</script>

</cfoutput>	