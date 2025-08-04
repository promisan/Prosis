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

<cfparam name="url.action" default="">

<cfoutput>

<cfif url.action is "purge">
		
		<script>
		
		 if (confirm("Do you want to delete selected positions ?")) {
			 
			 se = document.getElementsByName("position")
			 cnt = 0
			 pos = 0
			 
			 while (se[cnt]) {
			  if (se[cnt].checked) {
			      pos++ 
			      ColdFusion.navigate('../PositionBatchPurge.cfm?positionparentid='+se[cnt].value,'processbatchaction')
			  }
			  cnt++
			 }
			 if (pos == 0) {
			     alert("No postion(s) were removed.") 
			 } else {
				 alert(pos + " postion(s) were removed.")
				 <!--- reload the content --->
				 ColdFusion.navigate('MandateViewList.cfm?Mission=#URL.Mission#&ID=#url.ID#&ID1=#url.ID1#&Page=#url.Page#&Sort=#url.Sort#&Lay=#url.Lay#&Mandate=#URL.Mandate#&Act=1','list')	
			 }	 
	 	 }
		 
		</script>	
 
</cfif>  

<!--- ------------------------ --->
<!--- process the batch action --->
<!--- ------------------------ --->
	
	
<cfif url.action is "insert"> 
		
		<script>
		 se = document.getElementsByName("position")
		 cnt = 0
		 pos = 0
		 str = ''
		 while (se[cnt]) {
		  if (se[cnt].checked) {	
		      pos++	
			  str=str+','+se[cnt].value			  
		  }
		  cnt++
		 }
		 
		   if (pos == 0) {
		   
			   alert("No postions were selected to be moved.") 
			   
		  } else {	   
		 
			  if (confirm("Do you want to move the selected "+pos+" positions ?")) {
			 
		      ColdFusion.navigate('../PositionBatchMove.cfm?orgunit=#url.orgunit#&positionparentid='+str,'processbatchaction')			 
	
			  if (pos == 0) {
				   alert("No postions were selected to be moved.") 
				 } else {				  
			  	   <!--- reload the content --->
				   ColdFusion.navigate('MandateViewList.cfm?Mission=#URL.Mission#&ID=#url.ID#&ID1=#url.ID1#&Page=#url.Page#&Sort=#url.Sort#&Lay=#url.Lay#&Mandate=#URL.Mandate#&Act=1','list')	
				}   
				
			 }	
			 
			} 
		 
		</script>
		
</cfif>	


<cfif ParameterExists(Form.Unlink)> 

	<cfparam name="FORM.Position" default="''">
	
	<cfquery name="Delete" 
	 datasource="AppsEmployee" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Position
	 SET    Source = NULL, 
	        SourcePostNumber = NULL 
	 WHERE  PositionNo  IN (#PreserveSingleQuotes(FORM.Position)#) 
	 </cfquery>
	 	 
	 <script language="JavaScript">
	     window.location="../PostMatching/PostListing.cfm?#form.link#";
	 </script>
	 
</cfif>      

</cfoutput>



