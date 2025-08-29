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
<cfset Mission        = "#Attributes.Mission#">
<cfset MandateDefault = "#Attributes.MandateDefault#">

<cfoutput>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_Mandate
	WHERE  Mission = '#Attributes.Mission#'
	AND    MandateNo = '#Attributes.MandateDefault#'
</cfquery>

<cf_UItree
	id="base"
	title="<span style='font-size:16px;color:gray;padding-bottom:3px'>Filter and views</span>"	
	expand="Yes"
	Root="no">
	
	<cf_tl id="Filter" var="1">   
	
	<cf_UItreeitem value="Root"
	        display="<span style='font-size:15px;padding-top:1px;;padding-bottom:1px;font-weight:500' class='labelit'>#lt_text#</span>"
			parent="base" target="right"		
			href="MandateViewOpen.cfm?ID=&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"					
	        expand="No">	
	
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   DISTINCT P.LocationCode, L.LocationName, L.ListingOrder 
      FROM     userQuery.dbo.#SESSION.acc#Post P, 
	           Location L
	  WHERE    P.LocationCode = L.LocationCode
	  ORDER BY ListingOrder, LocationName
  </cfquery>
    
 <cfif Level01.recordcount gte "1">
 
	 <cf_tl id="location" var="1">     
	
	 <cf_UItreeitem value="location"
	        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
			href="MandateViewOpen.cfm?ID=Loc&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
			parent="Root" target="right"							
	        expand="No">	
				
	  <cfloop query="level01">
		
		<cf_UItreeitem value="#LocationCode#"
	        display="<span style='font-size:13px' class='labelit'>#LocationName#</span>"
			parent="location"						
			target="right"
			href="MandateViewOpen.cfm?ID=Loc&ID1=#LocationCode#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	
	  	  
	  </cfloop>
  
 </cfif> 
 
 <cf_tl id="Job Family" var="1">     
	
  <cf_UItreeitem value="function"
	        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
			parent="Root" target="right"		
			href="MandateViewOpen.cfm?ID=OCG&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"					
	        expand="No">	
    
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT Description, OccupationalGroup
      FROM userQuery.dbo.#SESSION.acc#Post P
   	  ORDER BY Description
  </cfquery>
  
  <cfloop query="level01">
  
    <cf_UItreeitem value="#OccupationalGroup#"
	        display="<span style='font-size:13px' class='labelit'>#Description#</span>"
			parent="function"						
			target="right"
			href="MandateViewOpen.cfm?ID=OCG&ID1=#OccupationalGroup#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	 
      
  </cfloop>
  
  <cf_tl id="Post gade" var="1">     
	
  <cf_UItreeitem value="grade"
        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root"		
		href="MandateViewOpen.cfm?ID=GRP&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"					
        expand="No">	  
 
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT   DISTINCT ParentDescription, ViewOrder, PostGradeParent
      FROM     userQuery.dbo.#SESSION.acc#Post P
	  ORDER BY ViewOrder
  </cfquery>

  <cfloop query="level01">
  
  	<cf_UItreeitem value="p#PostGradeParent#"
	      display="<span style='font-size:13px' class='labelit'>#ParentDescription#</span>"
		  parent="grade"						
		  target="right"
		  href="MandateViewOpen.cfm?ID=GRP&ID1=#PostGradeParent#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	 	 
  
	    <cfquery name="Level02" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT DISTINCT PostGrade, PostOrder
	      FROM userQuery.dbo.#SESSION.acc#Post P
	   	  WHERE P.PostGradeParent = '#PostGradeParent#'
	      ORDER BY PostOrder 
		</cfquery>
		  
		<cfset par = "p#PostGradeParent#">
  
      	<cfloop query="level02">	
		
			<cf_UItreeitem value="#PostGrade#"
		      display="<span style='font-size:12px' class='labelit'>#PostGrade#</span>"
			  parent="#par#"						
			  target="right"
			  href="MandateViewOpen.cfm?ID=GRD&ID1=#PostGrade#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	 	 
				       	   	  	  
		</cfloop>  
		
  </cfloop>
   
 <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT L.Code, L.Description, L.ListingOrder 
      FROM    userQuery.dbo.#SESSION.acc#Post P, 
	          Ref_VacancyActionClass L
	  WHERE P.VacancyActionClass = L.Code
	  ORDER BY ListingOrder
  </cfquery> 
  
 <cfif Level01.recordcount gte "1">
 
	 <cf_tl id="Vacancy class" var="1">     
	
	  <cf_UItreeitem value="vacclass"
        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root" target="right"		
		href="MandateViewOpen.cfm?ID=vcl&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"					
        expand="No">	
	
	  <cfloop query="level01">
	  
		  <cf_UItreeitem value="#Code#"
		      display="<span style='font-size:13px' class='labelit'>#Description#</span>"
			  parent="vacclass"						
			  target="right"
			  href="MandateViewOpen.cfm?ID=vcl&ID1=#Code#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	  
		  
	  </cfloop>
  
 </cfif>  
 
 <cf_tl id="Post Type" var="1">     
	
 <cf_UItreeitem value="posttype"
        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root" target="right"		
		href="MandateViewOpen.cfm?ID=ptp&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"					
        expand="No">	
     
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT Posttype
      FROM userQuery.dbo.#SESSION.acc#Post P
	  
	    <cfif SESSION.isAdministrator eq "No">
		  WHERE P.PostType IN (SELECT ClassParameter 
					            FROM    Organization.dbo.OrganizationAuthorization 
					            WHERE   UserAccount    = '#SESSION.acc#' 
					            AND     Mission        = '#Attributes.Mission#'
							    AND     ClassParameter = P.PostType) 
	  </cfif>	
	  
  </cfquery>

  <cfloop query="level01">
  
  	   <cf_UItreeitem value="#PostType#"
		      display="<span style='font-size:13px' class='labelit'>#PostType#</span>"
			  parent="posttype"						
			  target="right"
			  href="MandateViewOpen.cfm?ID=PTP&ID1=#Posttype#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	  
	     
  </cfloop>
  		
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT *
      FROM  Ref_Group
	  WHERE GroupDomain = 'Position'	
	  AND   GroupCode IN (SELECT GroupCode 
					      FROM   Ref_GroupMission 
						  WHERE  Mission = '#Attributes.Mission#' )
  </cfquery>
  
  <cfif Level01.recordcount eq "0">
    
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT *
      FROM  Ref_Group
	  WHERE GroupDomain = 'Position'		 
  </cfquery>
    
  </cfif>
  
  <cfif Level01.recordcount gte "1">
 
	 <cf_tl id="Classification" var="1">     
	
	  <cf_UItreeitem value="group"
        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root" target="right"	
		href="MandateViewOpen.cfm?ID=PGP&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"						
        expand="No">	

	  <cfloop query="level01">
	  
	      <cf_UItreeitem value="#GroupCode#"
		      display="<span style='font-size:13px' class='labelit'>#Description#</span>"
			  parent="group"						
			  target="right"
			  href="MandateViewOpen.cfm?ID=PGP&ID1=#GroupCode#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	  
	  	   
	  </cfloop>
	  
  </cfif>
  
  <cfquery name="Loan" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  SELECT DISTINCT P.PostGrade, G.PostOrder
      FROM    Position P, PositionParent PP, Organization.dbo.Organization O, Ref_PostGrade G
   	  WHERE   P.Mission <> P.MissionOperational
	  AND     PP.PositionParentId = P.PositionParentId
	  AND     PP.OrgUnitOperational = O.OrgUnit
	  AND     O.Mission     = '#Attributes.Mission#'
	  AND     O.MandateNo   = '#MandateDefault#'
	  AND     G.PostGrade = P.PostGrade
	  </cfquery>
   
   <cfif Loan.recordcount gt 0>
   
   	   <cf_tl id="Interoffice Loan" var="1">     
	
	  <cf_UItreeitem value="group"
	        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
			parent="Root" target="right"	
			href="MandateViewOpen.cfm?ID=GRD&ID1=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"						
	        expand="No">	   
   
	   <cfloop query="loan">
	   
	   		<cfset pgrade = PostGrade>
			
			 <cf_UItreeitem value="io#PostGrade#"
		        display="<span style='font-size:13px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#PostGrade#</span>"
				parent="loan"							
		        expand="No">	
	   	          
	       <cfquery name="Mission" 
		      datasource="AppsEmployee" 
		      username="#SESSION.login#" 
		      password="#SESSION.dbpw#">
				  SELECT DISTINCT MissionOperational as Mission
			      FROM Position P, PositionParent PP, Organization.dbo.Organization O
			   	  WHERE P.Mission <> P.MissionOperational
				  AND PP.PositionParentId = P.PositionParentId
				  AND PP.OrgUnitOperational = O.OrgUnit
				  AND O.Mission     = '#Attributes.Mission#'
				  AND O.MandateNo   = '#MandateDefault#'
				  AND P.Postgrade   = '#pgrade#'
		   	   </cfquery>
	  
		   <cfloop query="mission">
		   
		   		 <cf_UItreeitem value="#Mission#"
			      display="<span style='font-size:13px' class='labelit'>#Mission#</span>"
				  parent="io#pgrade#"					
				  target="right"
				  href="MandateViewOpen.cfm?ID=GRD&ID1=#pgrade#&ID4=#Mission.Mission#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	
		   		    
		   </cfloop>
	
	   </cfloop>
  
  </cfif>
      
  <cfquery name="Borrow" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	      SELECT DISTINCT P.PostGrade, G.PostOrder
	      FROM   Position P, Ref_PostGrade G
	   	  WHERE  P.Mission != P.MissionOperational
		  AND    P.Postgrade = G.PostGrade
		  AND    P.MissionOperational = '#Attributes.Mission#'
		  AND    P.DateEffective <= '#DateFormat(Mandate.DateExpiration,client.dateSQL)#'
		  AND    P.DateExpiration >= '#DateFormat(Mandate.DateEffective,client.dateSQL)#' 	 
   </cfquery>
        
   <cfif Borrow.recordcount gt 0>
   
   	 <cf_tl id="Borrowed position" var="1">     
   
     <cf_UItreeitem value="borrow"
        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#lt_text#</span>"
		parent="Root"							
        expand="No">	   
       
   <cfloop query="borrow">
   
	  <cfset pgrade = PostGrade>
   
      <cf_UItreeitem value="bo#PostGrade#"
		        display="<span style='font-size:13px;padding-top:1px;;padding-bottom:1px;font-weight:bold' class='labelit'>#PostGrade#</span>"
				parent="borrow"				
	 	        expand="No">	   
    
	      <cfquery name="Mission" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
			  SELECT DISTINCT O.Mission
		      FROM   Position P, PositionParent PP, Organization.dbo.Organization O
		   	  WHERE  P.Mission != P.MissionOperational
			  AND    P.Postgrade = '#pgrade#'
			  AND    PP.PositionParentId = P.PositionParentId
			  AND    PP.OrgUnitOperational = O.OrgUnit
			  AND    P.MissionOperational = '#Attributes.Mission#'
		      AND    P.DateEffective <= '#DateFormat(Mandate.DateExpiration,client.dateSQL)#'
			  AND    P.DateExpiration >= '#DateFormat(Mandate.DateEffective,client.dateSQL)#'
	      </cfquery>
   
	   <cfloop query="mission">
	   
		   <cfquery name="BorrowDefault" 
			datasource="AppsOrganization" 
			maxrows=1 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Ref_Mandate
				WHERE    Mission = '#Mission.Mission#'
				AND      DateEffective <= '#DateFormat(Mandate.DateExpiration,client.dateSQL)#' 
				AND      DateExpiration >= '#DateFormat(Mandate.DateEffective,client.dateSQL)#' 
				ORDER BY MandateDefault DESC, MandateNo DESC
			</cfquery>
			
			 <cf_UItreeitem value="#Mission#"
			      display="<span style='font-size:13px' class='labelit'>#Mission#</span>"
				  parent="bo#pgrade#"					
				  target="right"
				  href="MandateViewOpen.cfm?ID=BOR&ID1=#pgrade#&ID4=#Attributes.Mission#&ID2=#Mission.Mission#&ID3=#BorrowDefault.MandateNo#">	
			    
	   </cfloop>
    
   </cfloop>
  
  </cfif>
    
 <!--- ------------------- --->
 <!--- AUTHORISED POSITION --->
 <!--- -------------------   
 
 Removed by Hanno
 
<cftry>
	
	<cfquery name="Authorised" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT DISTINCT SourcePostNumber
		  FROM stPostnumber P
		  WHERE P.Mission = '#Attributes.Mission#'
	</cfquery>
	 
	<cfif Authorised.recordcount gt 0>
	 
	    <cftreeitem value="aut"
		        display="<span style='padding-bottom:3px' class='labelmedium'>Authorised posts</span>"
				parent="root"																
		        expand="No">	
	  
		 <cfquery name="Source" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			  SELECT DISTINCT Source
			  FROM   stPostnumber P
			  WHERE  P.Mission = '#Attributes.Mission#'
		 </cfquery>
	
		 <cfloop query="Source">
		
		    <cfset Src = Source>
		 
		    <cftreeitem value="#src#"
		        display="#src#"
				parent="aut"					
				expand="no">	
		  
			   <cfquery name="Grade" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					  SELECT DISTINCT G.PostOrder, P.PostGrade
					  FROM stPostnumber P, Ref_PostGrade G
					  WHERE P.Mission = '#Attributes.Mission#'
						AND G.PostGrade = P.PostGrade
						AND P.Source = '#Source#'
						GROUP BY G.PostOrder, P.PostGrade
						ORDER BY G.PostOrder
			   </cfquery>
		
			   <cfloop query="Grade">
			  
			     <cfset Grd = PostGrade>
					
				 <cftreeitem value="#GRD#"
				        display="#GRD#"
						parent="#src#"	
						target="right"			
						img="#SESSION.root#/Images/select.png"		
						href="#SESSION.root#/Staffing/Application/PostMatching/PostListing.cfm?ID=GRD&Mission=#Attributes.Mission#&Mandate=#Attributes.MandateDefault#&ID2=#Grd#"
				        expand="No">	
			         
			    </cfloop>	   
				
		   </cfloop>

	 </cfif> 
 
	 <cfcatch></cfcatch>
	 
 </cftry>
 
 --->
  
 <!--- ------- --->
 <!--- VACANCY --->
 <!--- ------- --->
 
 	
	<cf_tl id="Views" var="1">   
	
	<cf_UItreeitem value="view"
	        display="<span style='font-size:15px;padding-top:1px;;padding-bottom:1px;font-weight:500' class='labelit'>#lt_text#</span>"
			parent="base"							
	        expand="No">	
        
  <cf_tl id="Arrival confirmation" var="1">
  
  <cf_UItreeitem value="arrival"
			      display="<span style='font-size:14px' class='labelit'>#lt_text#</span>"
				  parent="view"					
				  target="right"
				  href="../../VAArrival/ArrivalConfirmation.cfm?ID=ARR&ID1=#Attributes.Mission#&ID2=0&IDArea=">	
  
     
      
  <!--- ---------- --->
  <!--- -CONTRACT- --->
  <!--- ---------- --->
  
<!---
  
  <cfif Mandate.DateExpiration gt now()>
  
  --->
  
  	<cf_tl id="Contractual status" var="1">
  
    <cf_UItreeitem value="contract"
        display="<span style='font-size:14px;padding-top:1px;;padding-bottom:1px;' class='labelit'>#lt_text#</span>"
		parent="view"	
		href="../../Contract/ContractListing.cfm?header=1&ID=PAR&ID1=&Mission=#Attributes.Mission#&MandateNo=#MandateDefault#"						
        expand="No">	
		
	<cf_tl id="Category" var="1">	   
		
	 <cf_UItreeitem value="appcat"
        display="<span style='font-size:13px;padding-top:1px;;padding-bottom:1px;' class='labelit'>#lt_text#</span>"
		parent="contract"	
		href="../../Contract/ContractListing.cfm?header=1&ID=PAR&ID1=&Mission=#Attributes.Mission#&MandateNo=#MandateDefault#"						
        expand="No">		   
			
	   <cfquery name="Parent" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM  Ref_Postgradeparent
		WHERE Code IN (
						SELECT DISTINCT R.PostGradeParent
					    FROM         PersonContract AS P INNER JOIN
					                      Ref_PostGrade AS R ON P.ContractLevel = R.PostGrade
					    WHERE     (P.Mission = '#Attributes.Mission#')	
						OR P.Personno IN (SELECT PersonNo 
						                  FROM   PersonAssignment PA, Position P
										  WHERE  PA.PositionNo = P.PositionNo
										  AND    P.Mission = '#Attributes.Mission#')
						)
		 				
		ORDER BY Vieworder
	   </cfquery>
      
   <!--- adjustment to take mission based on the assignment records or adjust the DTS --->
   
   <cfloop query="Parent">
   
   		 <cf_UItreeitem value="appcat#Code#"
			      display="<span style='font-size:13px' class='labelit'>#Description#</span>"
				  parent="appcat"					
				  target="right"
				  href="../../Contract/ContractListing.cfm?header=1&ID=PAR&ID1=#Code#&Mission=#Attributes.Mission#&MandateNo=#MandateDefault#">	   
		   
   </cfloop>
   
   <cf_tl id="Other" var="1">	   
		
	 <cf_UItreeitem value="appspec"
        display="<span style='font-size:13px;padding-top:1px;;padding-bottom:1px;' class='labelit'>#lt_text#</span>"
		parent="contract"	
		href="../../Contract/ContractExpiration.cfm?ID=&ID2=#Attributes.Mission#&ID3=#MandateDefault#"						
        expand="No">	
		
		  <cf_UItreeitem value="appexp1"
			      display="<span style='font-size:13px' class='labelit'>Contract Expiration</span>"
				  parent="appspec"					
				  target="right"
				  href="../../Contract/ContractExpiration.cfm?ID=CTR&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	   
  						
		  <cf_UItreeitem value="appexp1a"
			      display="<span style='font-size:13px' class='labelit'>Assignment Expiration</span>"
				  parent="appspec"					
				  target="right"
				  href="../../Contract/AssignmentExpiration.cfm?ID=ASS&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	   	
   	
		  <cf_UItreeitem value="appexp2"
			      display="<span style='font-size:13px' class='labelit'>Contract w/o Assignment</span>"
				  parent="appspec"					
				  target="right"
				  href="../../Contract/ContractNoAssignment.cfm?ID=CNA&ID2=#Attributes.Mission#&ID3=#MandateDefault#">	
				  
		  <cf_UItreeitem value="appexp3"
			      display="<span style='font-size:13px' class='labelit'>Assignments w/o Contract</span>"
				  parent="appspec"					
				  target="right"
				  href="../../Contract/AssignmentNoContract.cfm?ID=ANC&ID2=#Attributes.Mission#&ID3=#MandateDefault#">			     		
										
				 <cfloop query="Parent">
				 				 
				 	 <cf_UItreeitem value="appexp3#Code#"
				      display="<span style='font-size:12px' class='labelit'>#Description#</span>"
					  parent="appspec3"					
					  target="right"
					  href="../../Contract/AssignmentNoContract.cfm?ID=ANC&ID1=#Code#&ID2=#Attributes.Mission#&ID3=#MandateDefault#">				  
				 
				 </cfloop>					

		 <cf_UItreeitem value="appexp9"
			      display="<span style='font-size:13px' class='labelit'>Contract extensions files</span>"
				  parent="appspec"					
				  target="right"
				  href="../../Contract/Files.cfm?ID=#Attributes.Mission#&ID1=#MandateDefault#">			   				  		 	
		
  <!---			
  
  </cfif>
  
  --->
   
  </cf_UItree>
    
  </cfoutput>