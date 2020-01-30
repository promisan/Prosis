<cfoutput>

<cftree name="root"
   font="calibri"
   fontsize="13"		
   bold="No"   
   format="html"    
   required="No">

	<cftreeitem value="Gender"
	            display="Gender"
				parent="root">	
				
	<cftreeitem value="Male"
        display="Male"
		parent="Gender"
		target="center"
		img="#SESSION.root#/Images/refresh.jpg"
		href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=M&ID3=NONE&docno=#url.docno#&mode=#url.mode#"
        expand="Yes">		
		
	<cftreeitem value="Female"
        display="Female"
		parent="Gender"
		target="center"
		img="#SESSION.root#/Images/option2.jpg"
		href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=F&ID3=NONE&docno=#url.docno#&mode=#url.mode#">	
		
	<cftreeitem value="Both"
        display="Both"
		parent="Gender"
		target="center"
		img="#SESSION.root#/Images/option2.jpg"
		href="ResultListing.cfm?ID=GEN&ID1=#URL.ID1#&ID2=B&ID3=NONE&docno=#url.docno#&mode=#url.mode#">			

	<cfquery name="Class" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
	    FROM Ref_ApplicantClass
	</cfquery>
	
	<cftreeitem value="Class"
	            display="Class"
				parent="root"
				target="center"
				href="ResultListing.cfm?ID=CLS&ID1=#URL.ID1#&ID2=B&ID3=GEN&docno=#url.docno#&mode=#url.mode#">	

		<cfloop query="class">
		
		<cftreeitem value="#ApplicantClassId#"
	        display="#Description#"
			parent="Class"
			target="center"
			img="#SESSION.root#/Images/option2.jpg"
			href="ResultListing.cfm?ID=CLS&ID1=#URL.ID1#&ID2=#ApplicantClassId#&ID3=NONE&docno=#url.docno#&mode=#url.mode#">	
	
		</cfloop>
		
		<cftreeitem value="Status"
	            display="Candidate"
				parent="root"
				target="center"
				expand="No"
				href="ResultListing.cfm?ID=STA&ID1=#URL.ID1#&ID2=B&ID3=GEN&docno=#url.docno#&mode=#url.mode#">	

			<cfquery name="Status" 
			datasource="AppsSelection" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT * 
			    FROM Ref_PersonStatus
				WHERE RosterHide = '0'
			</cfquery>

		<cfloop query="status">
		
		<cftreeitem value="class_#Code#"
		        display="#Description#"
				parent="Status"
				target="center"
				img="#SESSION.root#/Images/option2.jpg"
				href="ResultListing.cfm?ID=STA&ID1=#URL.ID1#&ID2=#Code#&ID3=NONE&docno=#url.docno#&mode=#url.mode#"
		        expand="No">	
		
		</cfloop>

		<cftreeitem value="Age"
	       display="Age"
		   parent="root"
		   target="center"
		   href="ResultListing.cfm?ID=CLS&ID1=#URL.ID1#&ID2=B&ID3=GEN&docno=#url.docno#&mode=#url.mode#">	
				
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
				
		<cftreeitem value="range_#itm#"
	        display="#Des#"
			parent="Age"
			target="center"
			img="#SESSION.root#/Images/option2.jpg"
			href="ResultListing.cfm?ID=AGE&ID1=#URL.ID1#&ID2=#itm#&ID3=GEN&docno=#url.docno#&mode=#url.mode#"
	        expand="Yes">	
			
		</cfloop>	
		
		<cftreeitem value="Region"
	            display="Region"
				parent="root"
				target="center"
				href="ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=all&ID3=CO&docno=#url.docno#&mode=#url.mode#">	
			
		<cfquery name="Region" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT DISTINCT N.Continent
		  FROM RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
		  WHERE R.PersonNo = A.PersonNo
		  AND A.Nationality = N.Code
		  AND R.SearchId = #URL.ID1#
		</cfquery>

		<cfloop query = "Region">

		<cftreeitem value="#Continent#"
	        display="#Continent#"
			parent="Region"
			target="center"
			href="ResultListing.cfm?ID=CON&ID1=#URL.ID1#&ID2=#Continent#&ID3=COU&docno=#url.docno#&mode=#url.mode#"
	        expand="No">	
 
		  <cfset Continent = Region.Continent>
		   
		  <cfquery name="Country" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT DISTINCT N.Name, N.Code
		  FROM RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
		  WHERE R.PersonNo = A.PersonNo
		  AND A.Nationality = N.Code
		  AND N.Continent = '#Continent#'
		  AND R.SearchId = #URL.ID1#
		  AND N.Name > ''
		</cfquery>
		
		 <cfloop query="Country">
		
		<cftreeitem value="#Name#"
	        display="#Name#"
			parent="#Continent#"
			target="center"
			img="#SESSION.root#/Images/option2.jpg"
			href="ResultListing.cfm?ID=COU&ID1=#URL.ID1#&ID2=#Code#&ID3=NONE&docno=#url.docno#&mode=#url.mode#"
	        expand="No">	 

		 </cfloop>
               
  </cfloop>
  
</cftree>  

  
</cfoutput>

