
<cfset Mission        = "#Attributes.Mission#">
<cfset MandateDefault = "#Attributes.MandateDefault#">

<cfoutput>

<cfquery name="Mandate" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Mandate
	WHERE Mission = '#Attributes.Mission#'
	AND MandateNo = '#Attributes.MandateDefault#'
</cfquery>

<cftree name="root"
   font="Calibri"
   fontsize="13"		
   bold="No"   
   style="color:green"
   format="html"    
   required="No">   	
	
  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT P.LocationCode, L.LocationName, L.ListingOrder 
      FROM    userQuery.dbo.#SESSION.acc#Post P, 
	          Location L
	  WHERE P.LocationCode = L.LocationCode
	  ORDER BY ListingOrder, LocationName
  </cfquery>
    
 <cfif Level01.recordcount gte "1">
 
 <cftreeitem value="location"
	        display="<span style='padding-bottom:3px;' class='labelmedium'>Geographical Location</span>"
			parent="root"															
	        expand="No">	
			
  <cfloop query="level01">
  
  <cftreeitem value="#Level01.LocationCode#"
        display="#Level01.LocationName#"
		parent="location"	
		target="right"					
		href="MandateViewOpen.cfm?ID=Loc&ID1=#LocationCode#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
        expand="No">	
  
  </cfloop>
  
 </cfif> 
  
 <cftreeitem value="function"
	        display="<span style='padding-bottom:3px;' class='labelmedium'>Occupational Group</span>"
			parent="root"														
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
  
  	<cftreeitem value="#OccupationalGroup#"
        display="#Description#"
		parent="Function"	
		target="right"						
		href="MandateViewOpen.cfm?ID=OCG&ID1=#Level01.OccupationalGroup#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
        expand="No">	
    
  </cfloop>
   
  <cftreeitem value="grade"
	        display="<span style='padding-bottom:3px;' class='labelmedium'>Post grade</span>"
			parent="root"								
	        expand="No">	 

  <cfquery name="Level01" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT DISTINCT ParentDescription, ViewOrder, PostGradeParent
      FROM userQuery.dbo.#SESSION.acc#Post P
	  ORDER BY ViewOrder
  </cfquery>

  <cfloop query="level01">
  
  	 <cftreeitem value="#PostGradeParent#"
        display="#ParentDescription#"
		parent="grade"	
		target="right"					
		href="MandateViewOpen.cfm?ID=GRP&ID1=#Level01.PostGradeParent#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
        expand="No">	
  
	       <cfquery name="Level02" 
	      datasource="AppsEmployee" 
	      username="#SESSION.login#" 
	      password="#SESSION.dbpw#">
	      SELECT DISTINCT PostGrade, PostOrder
	      FROM userQuery.dbo.#SESSION.acc#Post P
	   	  WHERE P.PostGradeParent = '#PostGradeParent#'
	      ORDER BY PostOrder 
		  </cfquery>
		  
		  <cfset par = PostGradeParent>
  
      	<cfloop query="level02">	  
	  
	  <cftreeitem value="#PostGrade#"
        display="#PostGrade#"
		parent="#par#"	
		target="right"					
		href="MandateViewOpen.cfm?ID=GRD&ID1=#PostGrade#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
        expand="No">	
	       	   	  	  
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
	 
	 <cftreeitem value="vacclass"
		        display="<span style='padding-bottom:3px;' class='labelmedium'>Vacancy class</span>"
				parent="root"																	
		        expand="No">		
		  
	  <cfloop query="level01">
	  
	  <cftreeitem value="#Level01.Code#"
	        display="#Level01.Description#"
			parent="vacclass"	
			target="right"						
			href="MandateViewOpen.cfm?ID=vcl&ID1=#Code#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
	        expand="No">	
	  
	  </cfloop>
  
 </cfif>  
    
 <cftreeitem value="posttype"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Post type</span>"
			parent="root"												
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
	  
	  <cftreeitem value="#PostType#"
	        display="#PostType#"
			parent="PostType"	
			target="right"						
			href="MandateViewOpen.cfm?ID=PTP&ID1=#Posttype#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
	        expand="No">			
    
  </cfloop>
  
   <cftreeitem value="group"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Classification</span>"			
			parent="root"														
	        expand="No">	
			
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

  <cfloop query="level01">
  
   <cftreeitem value="#GroupCode#"
        display="#Description#"
		parent="Group"	
		target="right"					
		href="MandateViewOpen.cfm?ID=PGP&ID1=#GroupCode#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
        expand="No">	
   
  </cfloop>
  
  <cfquery name="Loan" 
      datasource="AppsEmployee" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  SELECT DISTINCT P.PostGrade, G.PostOrder
      FROM Position P, PositionParent PP, Organization.dbo.Organization O, Ref_PostGrade G
   	  WHERE P.Mission <> P.MissionOperational
	  AND PP.PositionParentId = P.PositionParentId
	  AND PP.OrgUnitOperational = O.OrgUnit
	  AND O.Mission     = '#Attributes.Mission#'
	  AND O.MandateNo   = '#MandateDefault#'
	  AND G.PostGrade = P.PostGrade
	  </cfquery>
   
   <cfif Loan.recordcount gt 0>
   
    <cftreeitem value="loan"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Loaned postion</span>"
			parent="root"											
	        expand="No">	  
 
   <cfloop query="loan">
   
   		<cfset pgrade = PostGrade>
   
	   <cftreeitem value="#PostGrade#"
        display="#PostGrade#"
		parent="loan"
		expand="no">	
          
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
	   
		   <cftreeitem value="#Mission#"
		        display="#Mission#"
				parent="#pgrade#"	
				target="right"						
				href="MandateViewOpen.cfm?ID=GRD&ID1=#pgrade#&ID4=#Mission.Mission#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"
		        expand="No">	
	    
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
   
    <cftreeitem value="borrow"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Borrowed position</span>"
			parent="root"				
			target="right"													
	        expand="No">	
    
   <cfloop query="borrow">
   
   <cfset pgrade = PostGrade>
   
   <cftreeitem value="#pgrade#"
        display="#pgrade#"
		parent="borrow"							
		expand="no">	
   
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
		
		 <cftreeitem value="#Mission#"
		        display="#Mission#"
				parent="#pgrade#"	
				target="right"									
				href="MandateViewOpen.cfm?ID=BOR&ID1=#pgrade#&ID4=#Attributes.Mission#&ID2=#Mission.Mission#&ID3=#BorrowDefault.MandateNo#"
		        expand="No">	
	    
	   </cfloop>
    
   </cfloop>
  
  </cfif>
    
 <!--- ------------------- --->
 <!--- AUTHORISED POSITION --->
 <!--- ------------------- --->  
 
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
  
 <!--- ------- --->
 <!--- VACANCY --->
 <!--- ------- --->
   
   <cfquery name="Status" 
	datasource="AppsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT DISTINCT R.*
	  FROM Ref_Status R, Document D
	  WHERE Class = 'Document'
	  AND D.Status = R.Status
	  AND D.Mission = '#Attributes.Mission#'
	</cfquery>

  <cfif #Status.recordcount# gt 0>
  
    <cftreeitem value="vac"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Recruitment</span>"
			parent="root"														
	        expand="No">	
  
  <cfloop query="Status">
  
  <cfset Sta = Status>
  
  <cfif Sta neq "0">
  
		  <cftreeitem value="#sta#"
		        display="#Description#"
				parent="vac"	
				target="right"							
				href="#SESSION.root#/Vactrack/Application/ControlView/ControlListing.cfm?ID=MIS&Mission=#Attributes.Mission#&ID2=#Sta#&IDArea="
		        expand="No">	
 
  <cfelse>
  
  		 <cftreeitem value="#sta#"
		        display="#Description#"
				parent="vac"	
				target="right"							
				href="#SESSION.root#/Vactrack/Application/ControlView/ControlListing.cfm?ID=MIS&Mission=#Attributes.Mission#&ID2=#Sta#&IDArea="
		        expand="No">		
  
  </cfif>
      
  </cfloop>
   
  <cftreeitem value="arrival"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Arrivals</span>"
			parent="root"	
			target="right"			
			href="../../VAArrival/ArrivalConfirmation.cfm?ID=ARR&ID1=#Attributes.Mission#&ID2=0&IDArea="		      														
	        expand="No">	
   
  </cfif> 
  
  <!--- ---------- --->
  <!--- -CONTRACT- --->
  <!--- ---------- --->
  
<!---
  
  <cfif Mandate.DateExpiration gt now()>
  
  --->
  
  <cftreeitem value="contract"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Contractual status</span>"
			parent="root"								
	        expand="No">	
			
 <cftreeitem value="appcat"
	        display="<span style='padding-bottom:3px' class='labelmedium'>Category</span>"
			parent="contract"									
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
   
		   <cftreeitem value="appcat#Code#"
			        display="<span class='labelit'>#Description#</span>"
					parent="appcat"	
					target="right"
					href="../../Contract/ContractListing.cfm?header=1&ID=PAR&ID1=#Code#&Mission=#Attributes.Mission#&MandateNo=#MandateDefault#"		      											
			        expand="No">	
   
   </cfloop>
   
   <cftreeitem value="appspec"
	        display="<span class='labelmedium'>Special views</span>"
			parent="contract"									
	        expand="No">		
				  
	      <cftreeitem value="appexp1"
		        display="<span class='labelit'>Contract Expiration</span>"
				parent="appspec"	
				target="right"
				href="../../Contract/ContractExpiration.cfm?ID=CTR&ID2=#Attributes.Mission#&ID3=#MandateDefault#"	
		        expand="No">	
				
		  <cftreeitem value="appexp1a"
		        display="<span class='labelit'>Assignment Expiration</span>"
				parent="appspec"	
				target="right"
				href="../../Contract/AssignmentExpiration.cfm?ID=ASS&ID2=#Attributes.Mission#&ID3=#MandateDefault#"	
		        expand="No">			
				
		 <cftreeitem value="appexp2"
		        display="<span class='labelit'>Contract w/o Assignment</span>"
				parent="appspec"	
				target="right"
				href="../../Contract/ContractNoAssignment.cfm?ID=CNA&ID2=#Attributes.Mission#&ID3=#MandateDefault#"										
		        expand="No">	
				
			 <cftreeitem value="appexp3"
		        display="<span class='labelit'>Assignments w/o Contract</span>"
				parent="appspec"	
				target="right"
				href="../../Contract/AssignmentNoContract.cfm?ID=ANC&ID2=#Attributes.Mission#&ID3=#MandateDefault#"	
		        expand="No">	
				
				 <cfloop query="Parent">
				 
				    <cftreeitem value="appexp#Code#"
			        display="#Description#"
					parent="appexp3"	
					target="right"
					href="../../Contract/AssignmentNoContract.cfm?ID=ANC&ID1=#Code#&ID2=#Attributes.Mission#&ID3=#MandateDefault#"											
			        expand="No">	
				 
				 
				 </cfloop>					

		 <cftreeitem value="appexp9"
	        display="<span class='labelit'>Contract extensions files</span>"
			parent="appspec"	
			target="right"
			href="../../Contract/Files.cfm?ID=#Attributes.Mission#&ID1=#MandateDefault#"										
	        expand="No">	
  <!---			
  
  </cfif>
  
  --->

  </cftree>
    
  </cfoutput>