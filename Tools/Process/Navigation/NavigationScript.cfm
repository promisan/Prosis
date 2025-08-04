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

<cf_systemscript>

<cfoutput>
		
	<script language="JavaScript">		
	     
		function  change(obj,nid) {
			obj.className=nid;
		}		   
				
		function doNext(fn,mis,owner,code,alias,tablename,object,objectid,id,id1,listingorder,moveto,group)	{
		
		  var result = window[fn](); 		
		  if (result)	{ 
			  nextstep(mis,owner,code,alias,tablename,object,objectid,id,id1,listingorder,moveto,group);
	      }				  
	   }	
	   
	   function nextstep(mis,owner,code,alias,tablename,object,objectid,id,id1,listingorder,moveto,group) {	
			ptoken.location("#SESSION.root#/tools/Process/Navigation/NavigationNext.cfm?mission="+mis+"&owner="+owner+"&code="+code+"&alias="+alias+"&tablename="+tablename+"&object="+object+"&objectid="+objectid+"&id="+id+"&id1="+event+"&prior="+listingorder+"&move="+moveto+"&group="+group) 
		}					  
					
	</script>

</cfoutput>