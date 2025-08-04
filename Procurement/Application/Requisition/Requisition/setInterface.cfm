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


<!--- determine item master --->

<cfparam name="url.itemmaster" default="0">
<cfparam name="url.item"       default="">
<cfparam name="url.access"     default="view">
<cfparam name="url.init"       default="1">
<cfparam name="url.option"     default="itm">

<cfquery name="Check" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT * 
		 FROM   ItemMaster I, Ref_EntryClass R
		 WHERE  I.EntryClass = R.Code
		 AND    I.Code = '#URL.ItemMaster#' 
</cfquery>

<cfquery name="get" 
     datasource="AppsPurchase" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT *
		 FROM   Ref_ParameterMission
		 WHERE  Mission IN (SELECT Mission  
							FROM   RequisitionLine
							WHERE  RequisitionNo = '#URL.Id#')		 	 
</cfquery>

<span id="iservice">

<cfif url.init eq "0">

	<!--- this is the mode where we have both stock and service visible --->
	<cfif get.RequestDescriptionMode neq "0">	
	<cfinclude template="../Service/ServiceItem.cfm">
	</cfif>
					
	<script>	
	     document.getElementById("itemtypeselect").className  = "regular" 		
		 <cfif get.RequestDescriptionMode eq "0">
			 document.getElementById("uombox").className         = "regular"         
			 document.getElementById("quantitybox").className     = "regular"         
			 document.getElementById("pricebox").className        = "regular"      
		 <cfelse>	  
			 document.getElementById("uombox").className          = "hide"         
			 document.getElementById("quantitybox").className     = "hide"         
			 document.getElementById("pricebox").className        = "hide"         
		 </cfif>
	</script>	
	
	<cfset custom = Check.customdialog>	    

<cfelseif Check.CustomForm eq "1">
    <cfset custom = Check.customdialog>	    
<cfelse>
	<cfset custom = Check.customDialogOverwrite>	
</cfif>		
	
<cfif custom eq "Materials">	
		
		<cfinclude template="RequisitionEntryWarehouse.cfm">	
			
		<script>			     
		     document.getElementById("itemtypeselect").className  = "regular" 
			 document.getElementById("uombox").className          = "regular"         
			 document.getElementById("quantitybox").className     = "regular"         
			 document.getElementById("pricebox").className        = "regular"   
			 document.getElementById('requesttype').checked       = true
		</script>	
		
		<cfset ajaxonload("hidedescription")>		
		
<cfelseif custom eq "Travel">		

		<cfinclude template="../Travel/TravelItem.cfm">		
						
		<script>		    		     
		     document.getElementById("itemtypeselect").className  = "hide" 
			 document.getElementById("uombox").className          = "hide"         
			 document.getElementById("quantitybox").className     = "hide"         
			 document.getElementById("pricebox").className        = "hide"         
			 document.getElementById('regulartype').checked       = true
		</script>			
		
<cfelseif custom eq "Contract">	

	    <cfinclude template="../Position/PositionSelect.cfm">	
		
		<script>
		     document.getElementById("itemtypeselect").className  = "hide" 			 
			 document.getElementById("uombox").className          = "regular"         
			 document.getElementById("quantitybox").className     = "regular"         
			 document.getElementById("pricebox").className        = "regular" 
			 document.getElementById('regulartype').checked       = true        
		</script>	
		
<cfelse>	
		
		<cfif get.RequestDescriptionMode neq "0">
			<cfinclude template="../Service/ServiceItem.cfm">
		</cfif>
						
		<script>
			document.getElementById("itemtypeselect").className    = "hide" 					
			<cfif get.RequestDescriptionMode eq "0">			
				document.getElementById("uombox").className       = "regular"         				 
				document.getElementById("quantitybox").className  = "regular"    				     
				document.getElementById("pricebox").className     = "regular"    
				
			 <cfelse>	  
				 document.getElementById("uombox").className       = "hide"         
				 document.getElementById("quantitybox").className  = "hide"         
				 document.getElementById("pricebox").className     = "hide"         
			 </cfif>
			document.getElementById('regulartype').checked = true					
		 </script>
						
</cfif>	


<cfif check.enforcewarehouse eq "1">
	<script>
	document.getElementById('itemtypeselect').className  = "hide" 		
	</script>
<cfelse>
	<script>
	 try {
	 document.getElementById('requesttypereg').className = "regular" } catch(e) {}
	</script>
</cfif>

</span>