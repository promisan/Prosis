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

<cf_tl id="Result" var="vResult">

<cf_UItree id="root" title="<span style='font-size:16px;color:gray;padding-bottom:3px'>#vResult#</span>" expand="Yes">
	
  <cf_tl id="Gender" var="vGender">	

  <cf_UItreeitem value="gender"
			        display="<span style='font-size:17px;height:25px;padding-top:4px' class='labelit'>#vGender#</span>"												
					parent="root" expand="Yes">		

	  <cf_UItreeitem value="male"
			        display="<span style='font-size:14px' class='labelit'>Male</span>"						
					href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=M&ID3=NONE&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="gender">	
								
	<cf_UItreeitem value="female"
			        display="<span style='font-size:14px' class='labelit'>Female</span>"						
					href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=F&ID3=NONE&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="gender">	
		
	<cf_UItreeitem value="both"
			        display="<span style='font-size:14px';class='labelit'>Both</span>"						
					href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=B&ID3=NONE&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="gender">	
					
							
	
	<cfquery name="Class" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_ApplicantClass
	</cfquery>
	
	 <cf_UItreeitem value="class"
			        display="<span style='font-size:17px;height:25px;padding-top:4px' class='labelit'>Class</span>"						
					href="ResultListing.cfm?ID=CLS&ID1=#URL.ID1#&ID2=B&ID3=GEN&docno=#url.docno#&mode=#url.mode#"				
					parent="root"  expand="no">		
		
		<cfloop query="class">
		
		<cf_UItreeitem value="#ApplicantClassId#"
			        display="<span style='font-size:14px' class='labelit'>#Description#</span>"						
					href="ResultListing.cfm?ID=CLS&ID1=#URL.ID1#&ID2=#ApplicantClassId#&ID3=NONE&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="class">			
	
		</cfloop>
		
		<cf_UItreeitem value="status"
			        display="<span style='font-size:17px;;height:25px;padding-top:4px' class='labelit'>Candidate</span>"						
					href="ResultListing.cfm?ID=STA&ID1=#URL.ID1#&ID2=B&ID3=GEN&docno=#url.docno#&mode=#url.mode#"				
					parent="root">				
		
			<cfquery name="Status" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM Ref_PersonStatus
				WHERE RosterHide = '0'
			</cfquery>

		<cfloop query="status">
		
		<cf_UItreeitem value="class_#Code#"
			        display="<span style='font-size:14px' class='labelit'>#Description#</span>"						
					href="ResultListing.cfm?ID=STA&ID1=#URL.ID1#&ID2=#Code#&ID3=NONE&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="status">			
				
		</cfloop>
						
		<cf_UItreeitem value="age"
			        display="<span style='font-size:17px;height:25px;padding-top:4px' class='labelit'>Age</span>"						
					href="ResultListing.cfm?ID=CLS&ID1=#URL.ID1#&ID2=B&ID3=GEN&docno=#url.docno#&mode=#url.mode#"				
					parent="root"  expand="Yes">		
						
				<cfloop index="itm" list="0,20,30,40,50,60" delimiters=",">		
				
				<cfswitch expression="#itm#">
				<cfcase value="0">
					<cfset des = "Below 20">
				</cfcase>
				<cfcase value="20">
					<cfset des = "20 - 29">
				</cfcase>
				<cfcase value="30">
					<cfset des = "30 -39">
				</cfcase>
				<cfcase value="40">
					<cfset des = "40 -49">
				</cfcase>
				<cfcase value="50">
					<cfset des = "50- 59">
				</cfcase>
				<cfcase value="60">
					<cfset des = "Above 60">
				</cfcase>
				</cfswitch>
								
				<cf_UItreeitem value="range_#itm#"
			        display="<span style='font-size:14px' class='labelit'>#Des#</span>"						
					href="ResultListing.cfm?ID=AGE&ID1=#URL.ID1#&ID2=#itm#&ID3=GEN&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="age">							
									
				</cfloop>	
				
		<cf_UItreeitem value="region"
			        display="<span style='font-size:17px;height:25px;padding-top:4px' class='labelit'>Region</span>"						
					href="ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=all&ID3=CO&docno=#url.docno#&mode=#url.mode#"				
					parent="root">				
							
			<cfquery name="Region" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT  DISTINCT N.Continent
				  FROM    RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
				  WHERE   R.PersonNo = A.PersonNo
				  AND     A.Nationality = N.Code
				  AND     R.SearchId = '#URL.ID1#'
			 </cfquery>

			<cfloop query = "Region">
			
			<cf_UItreeitem value="#Continent#"
			        display="<span style='font-size:15px' 'class='labelit'>#Continent#</span>"						
					href="ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=#Continent#&ID3=COU&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="region"  expand="No">
							 
			  <cfset Continent = Region.Continent>
		   
		  	<cfquery name="Country" 
				datasource="AppsSelection" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				  SELECT DISTINCT N.Name, N.Code
				  FROM   RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
				  WHERE  R.PersonNo = A.PersonNo
				  AND    A.Nationality = N.Code
				  AND    N.Continent = '#Continent#'
				  AND    R.SearchId = #URL.ID1#
				  AND    N.Name > ''
			</cfquery>
		
		 <cfloop query="Country">
		 
		 <cf_UItreeitem value="#Code#"
			        display="<span style='font-size:13px' class='labelit'>#Name#</span>"						
					href="ResultListing.cfm?ID=COU&ID1=#URL.ID1#&ID2=#Code#&ID3=NONE&docno=#url.docno#&mode=#url.mode#"		
					target="center"		
					parent="#Continent#">		
		
		 </cfloop>
               
	  </cfloop>	  
  
</cf_UItree>	
  
</cfoutput>

