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

<cf_tl id="Result" var="vResult">

<cf_UItree id="root" title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#vResult# #URL.ID1#</span>" expand="Yes">
	   	
  <cf_tl id="Gender" var="vGender">	

  <cf_UItreeitem value="gender"
		        display="<span style='font-size:17px;height:25px;padding-top:4px' class='labelit'>#vGender#</span>"												
				parent="root" expand="Yes">		
	
	 <cf_UItreeitem value="male"
		        display="<span style='font-size:14px' class='labelit'>Male</span>"						
				href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=M&ID3=NONE"		
				target="right"		
				parent="gender">	
							
	<cf_UItreeitem value="female"
		        display="<span style='font-size:14px' class='labelit'>Female</span>"						
				href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=M&ID3=NONE"		
				target="right"		
				parent="gender">	
	
	<cf_UItreeitem value="both"
		        display="<span style='font-size:14px';class='labelit'>Both</span>"						
				href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=B&ID3=GEN"		
				target="right"		
				parent="gender">	
				
						
	
   <cfquery name="Region" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT DISTINCT N.Continent
		  FROM   PersonSearchResult R, Person A, System.dbo.Ref_Nation N
		  WHERE  R.PersonNo = A.PersonNo
		  AND    A.Nationality = N.Code
		  AND    R.SearchId = #URL.ID1#
  </cfquery>
			
  <cf_tl id="Region" var="vRegion">	

  <cf_UItreeitem value="region"
		        display="<span style='font-size:17px;height:25px;padding-top:4px' class='labelit'>#vRegion#</span>"												
				parent="root" expand="Yes">		
		
					
	<cfloop query = "Region">
	 
	   <cfset Cont = Continent>
	  
	   <cf_UItreeitem value="#cont#"
			        display="<span style='font-size:15px;' class='labelit'>#Cont#</span>"		
					href="ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=#Cont#&ID3=COU" target="right"													
					parent="region" expand="No">	
										   
		 <cfquery name="Country" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			  SELECT DISTINCT N.Name, N.Code
			  FROM PersonSearchResult R 
			       INNER JOIN Person A ON R.PersonNo  = A.PersonNo
			       INNER JOIN System.dbo.Ref_Nation N ON A.Nationality = N.Code
			  WHERE N.Continent   = '#Continent#'
			  AND   R.SearchId    = #URL.ID1#   
		</cfquery>
		
		<cfloop query="Country">
		
		      <cf_UItreeitem value="#code#"
			        display="<span style='font-size:13px' class='labelit'>#Name#</span>"		
					href="ResultListing.cfm?ID=COU&ID1=#URL.ID1#&ID2=#Code#&ID3=NONE" target="right"													
					parent="#cont#" expand="Yes">	
	
		</cfloop> 
		
		
  </cfloop>
      
</cf_UItree>	  
  
