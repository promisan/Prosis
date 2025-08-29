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
<cfquery name="Last" 
datasource="AppsProgram" 
maxrows=1
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT  Pe.Period 
FROM    ProgramPeriod Pe
WHERE   Pe.ProgramCode = '#URL.ProgramCode#'
AND     Pe.Period      <= '#URL.Period#'
ORDER BY Period DESC
</cfquery>

<script language="JavaScript">
 
<cfoutput>
		
function listing(row,act,filter) {
 	
	icM  = document.getElementById("d"+row+"Min");
    icE  = document.getElementById("d"+row+"Exp");
	se1   = document.getElementById("d1"+row);
	se2   = document.getElementById("d2"+row);
	frm  = document.getElementById("i"+row);
	 		 
	if (se1.className == "hide")  {
	 		 
     icM.className = "regular";
	 icE.className = "hide";
     se1.className  = "regular";
	 se2.className  = "regular";
	 window.open("ActivityProgressOutput.cfm?now=#now()#&row=" + row + "&ActivityId=" + filter, "i"+row)		
	 } else {	 	     
     	 icM.className = "hide";
	     icE.className = "regular";
     	 se1.className  = "hide";
		 se2.className  = "hide";
		 frm.height = "0";
	 }
		 		
  }
		
function show(itm) {

	 icM  = document.getElementById(itm+"Min")
	 icM.className = "regular";
	 icM  = document.getElementById(itm+"Min2")
	 icM.className = "regular";
     icE  = document.getElementById(itm+"Exp")
	 icE.className = "hide";
		 	  
	 var loop=0;
	 
	 while (loop<100){
	     
		 loop=loop+1
		 
		 if (loop<10)
		 { sel = ".0"+loop }
		 else
		 { sel = "."+loop }
		 
		 se = document.getElementsByName("T"+itm+sel);
		 count=0
		 
		 while (se[count]) { se[count].className = "regular"; 
		                    count=count+1;
						  }
		 		 	 		 	 
		 se   = document.getElementById(itm+sel);
		 if (se) {se.className = "regular";}
		 else {loop=100}
		 		 		 
		}	 	 	 
		
  }
  
function hide(itm,len,lv) {

     icM  = document.getElementById(itm+"Min")
	 icM  = document.getElementById(itm+"Min")
     icE  = document.getElementById(itm+"Exp")
	 if (icM) {
     	 icM.className = "hide";
		 icM  = document.getElementById(itm+"Min2")
		 icM.className = "hide";
	     icE.className = "regular";
	 }
		 	  
	 var loop=0;
	 
	 while (loop<100){
	 	 
	     loop=loop+1
		 
		 if (loop<10)
		    { sel = ".0"+loop }
		 else
		    { sel = "."+loop }
			
		 se = document.getElementsByName("T"+itm+sel);
		 count=0
		 
		 while (se[count]) { se[count].className = "hide"; 
		                    count=count+1;
						  }
						 		 
      	 se   = document.getElementById(itm+sel);
		 if (se) {se.className = "hide";}
		 else {loop=100}
				 		 							 
		}	 	
  }  
  
</cfoutput>   

</script> 	