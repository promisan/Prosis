
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterView#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewT#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewL#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewTmp#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewTmp1_#FileNo#">

<cfquery name="Owner" 
	 datasource  = "AppsSelection" 	
	 username    = "#SESSION.login#" 
	 password    = "#SESSION.dbpw#">
     SELECT * 
     FROM   Ref_ParameterOwner
	 WHERE  Owner = '#URL.Owner#'
</cfquery>

<cfquery name="Steps" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_StatusCode
		WHERE    Owner      = '#URL.Owner#'
		AND      Id         = 'FUN'
		AND      ShowRoster = '1' 
		ORDER BY Status 
</cfquery>	

<cfset list = "">
<cfloop query="steps">
  <cfif list eq "">
    <cfset list = "#status#">
  <cfelse>
    <cfset list = "#list#,#status#">
  </cfif>
</cfloop>

<cfquery name="Create"
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	CREATE TABLE dbo.#SESSION.acc#RosterView#FileNo# (
    [OccupationalGroup] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	 <cfloop query="resource">
	     [Grade_#currentRow#] [float] NULL , 
	     <cfset rw = CurrentRow>
		 <cfloop query="steps">
		    [Grade#status#_#rw#] [float] NULL , 
		 </cfloop>
	 </cfloop>
	 <cfloop query="steps">
		 [Total#Status#] [float] NULL CONSTRAINT [DF_#SESSION.acc#RosterView_Total#status##FileNo#] DEFAULT (0),
	 </cfloop>
	 [Total] [float] NULL CONSTRAINT [DF_#SESSION.acc#RosterView_Total#FileNo#] DEFAULT (0))
</cfquery>

<!---
<cfoutput>1. #cfquery.executionTime#  </cfoutput>	
--->

<!--- ----------------------------------------------------------------- --->
<!--- base summary queries, limited to buckets to which you have access --->
<!--- -----------------  total buckets -------------------------------- --->


<cftransaction isolation="READ_UNCOMMITTED">

<cfquery name="RosterSum" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT      F.OccupationalGroup, 
	            R.PostGradeBudget, 
				R.PostGradeParent, 
				COUNT(*) AS Total
	INTO        userQuery.dbo.#SESSION.acc#RosterViewTmp1_#FileNo#		
		
    FROM        FunctionOrganization Fo, 
	            FunctionTitle F, 
				Ref_GradeDeployment R 
	WHERE       Fo.FunctionNo = F.FunctionNo 
	   
	    <cfif URL.Inquiry eq "No" and SESSION.isAdministrator eq "No" and not findNoCase(url.owner,SESSION.isOwnerAdministrator)>
		
			<!--- limit access --->		
			AND 	Fo.FunctionId  IN (SELECT FunctionId 
			                           FROM    RosterAccessAuthorization 
									   WHERE   FunctionId = Fo.FunctionId
									   AND     UserAccount = '#SESSION.acc#')  
									   
								  
		</cfif>
		AND     R.GradeDeployment = Fo.GradeDeployment  
		
		AND Fo.Status != '9'		
				
		<cfif URL.Edition eq "All">
		
			<cfif Owner.HidePostSpecific eq "1">
			AND 	Fo.PostSpecific = 0
			</cfif>
			AND		Fo.SubmissionEdition IN (SELECT SubmissionEdition 
		                                 FROM   Ref_SubmissionEdition 
                                 		 WHERE  EnableAsRoster = '1'
										 <cfif URL.Owner neq "">
										 AND Owner='#URL.Owner#'
									     </cfif>
										 <cfif url.exerciseclass neq "">
										 AND ExerciseClass = '#url.exerciseclass#'
										 </cfif>
										 )
		<cfelse>
		
			<cfif Owner.DefaultRosterShow eq "0">
			AND		Fo.SubmissionEdition IN ('#URL.Edition#') 
		    <cfelse>
		    <!--- not sure if this is a good idea 
		    AND		Fo.SubmissionEdition IN ('#URL.Edition#','#Owner.DefaultRoster#') 
			--->
			AND		Fo.SubmissionEdition IN ('#URL.Edition#')
		    </cfif>	
		
		</cfif>
		
		<cfif Owner.HideEmptyBucket eq "1">		
		AND    Fo.FunctionId IN (SELECT FunctionId 
		                         FROM   ApplicantFunction 
								 WHERE  FunctionId = Fo.FunctionId)
		</cfif>
		GROUP BY  F.OccupationalGroup, R.PostGradeBudget, R.PostGradeParent 			
		
	</cfquery>
	
	<!---
	<cfoutput>1. #cfquery.executionTime#  </cfoutput>	
	--->
						
	<!--- ----------------------------------------------------------------- --->
	<!--- base summary queries, limited to buckets to which you have access --->
	<!--- -----------------  stuatus       -------------------------------- --->
	
		
	<cfquery name="RosterStep" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	
	   SELECT   F.OccupationalGroup, 
	            R.PostGradeBudget, 
				R.PostGradeParent, 
				Ap.Status, 
				ISNULL(COUNT(*),0) AS Total			
				
	   INTO     userQuery.dbo.#SESSION.acc#RosterViewTmp#FileNo# 

	   FROM     FunctionOrganization AS Fo INNER JOIN
                FunctionTitle AS F ON Fo.FunctionNo = F.FunctionNo INNER JOIN
                ApplicantFunction AS Ap ON Fo.FunctionId = Ap.FunctionId INNER JOIN
                Ref_GradeDeployment AS R ON Fo.GradeDeployment = R.GradeDeployment

	  WHERE     1=1
						
		<cfif URL.Inquiry eq "No" and SESSION.isAdministrator eq "No" and not findNoCase(url.owner,SESSION.isOwnerAdministrator)>
		
		<!--- limit access --->
		AND 	Fo.FunctionId  IN (SELECT FunctionId 
		                          FROM    RosterAccessAuthorization
								  WHERE   FunctionId = Fo.FunctionId
								  AND     UserAccount = '#SESSION.acc#')  
		</cfif>
		 
		<!--- we areno looking at the field which is showing it
		AND     Ap.Status IN (SELECT Status
							  FROM   Ref_StatusCode
							  WHERE  Owner        = '#URL.Owner#'
							  AND    Id           = 'FUN'
							  AND    RosterAction = '1')
							  
							  --->
							 
		
		<cfif URL.Edition eq "All">
			
			AND   Fo.SubmissionEdition IN (SELECT SubmissionEdition 
			                               FROM   Ref_SubmissionEdition 
									       WHERE  EnableAsRoster = '1'
										<cfif URL.Owner neq "">
										   AND    Owner='#URL.Owner#'
									    </cfif>
										<cfif url.exerciseclass neq "">
										   AND    ExerciseClass = '#url.exerciseclass#'
										</cfif>)
										
			<cfif Owner.HidePostSpecific eq "1">
			AND   Fo.PostSpecific = 0
			</cfif>
										
		<cfelse>
		
			<cfif Owner.DefaultRosterShow neq "1">
				AND		Fo.SubmissionEdition IN ('#URL.Edition#') 
			<cfelse>
			    <!---
			    AND		Fo.SubmissionEdition IN ('#URL.Edition#','#Owner.DefaultRoster#') 
				--->
				AND		Fo.SubmissionEdition IN ('#URL.Edition#') 
			</cfif>	
			
		</cfif>
									 
	    GROUP BY   F.OccupationalGroup, 
	               R.PostGradeBudget, 
				   R.PostGradeParent, 
				   Ap.Status 
				  
	</cfquery>		
	
	</cftransaction>
					
<cfloop query="resource">
    
	<cfquery name="RosterCandidated" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO dbo.#SESSION.acc#RosterView#FileNo#
	           (OccupationalGroup, Grade_#currentRow#)
    SELECT      OccupationalGroup, Total
    FROM        #SESSION.acc#RosterViewTmp1_#FileNo#
  	<cfif PostGradeBudget neq "Subtotal">
   	WHERE      PostGradeBudget = '#PostGradeBudget#' 
	<cfelse>
	WHERE      PostGradeParent = '#Code#'
	</cfif>		
	</cfquery>
	
	<cfset rw = CurrentRow>
	<cfset pg = PostGradeBudget>
	<cfset cd = Code>

	<cfoutput query="steps">
				
		<cfquery name="RosterCandidated" 
		datasource="AppsQuery" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO dbo.#SESSION.acc#RosterView#FileNo#
		           (OccupationalGroup, Grade#status#_#rw#)
	    SELECT      OccupationalGroup, SUM(Total) AS Total
	    FROM        #SESSION.acc#RosterViewTmp#FileNo#
		  	<cfif pg neq "Subtotal">
	    	WHERE   PostGradeBudget = '#pg#' 
			<cfelse>
			WHERE   PostGradeParent = '#cd#'
			</cfif>
			AND Status = '#Status#'
	    GROUP BY    OccupationalGroup
		</cfquery>
			
	</cfoutput>
	  	
</cfloop>

<cfquery name="OccGroupTotal" 
datasource="AppsQuery" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT OccupationalGroup, 
     <cfloop query="resource">
     SUM(Grade_#currentRow#) as Grade_#currentRow#, 
	     <cfset rw = CurrentRow>
		 <cfloop query="steps">
		 SUM(Grade#status#_#rw#) as Grade#status#_#rw#, 
		 </cfloop>
     </cfloop>0 as Total, 
	 <cfloop query="steps">
		 0 as Total#status#, 
	 </cfloop>
	 1 as Show
	 INTO   dbo.#SESSION.acc#RosterView1_#FileNo#	
	 FROM   #SESSION.acc#RosterView#FileNo#	 
	 GROUP BY OccupationalGroup
</cfquery>

<cfloop query="resource">

     <cfif PostGradeBudget neq 'Subtotal'>
	
		  <cfquery name="Total" 
		   datasource="AppsQuery" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   UPDATE #SESSION.acc#RosterView1_#FileNo#	
		   SET    Total = Total + Grade_#currentRow#
		   WHERE  Grade_#currentRow# is not NULL
		  </cfquery>	
		
		  <cfset rw = CurrentRow>
		  
		  <cfloop query="steps">
		  	  
			  <cfquery name="Status" 
			   datasource="AppsQuery" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
			   UPDATE #SESSION.acc#RosterView1_#FileNo#	
			   SET    Total#Status# = Total#Status# + Grade#status#_#rw# 
			   WHERE  Grade#Status#_#rw# is not NULL
			  </cfquery>			  
		  
		  </cfloop>
		  	  
	  </cfif>
	
</cfloop>

<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterView#FileNo#"> 
			
	<cfquery name="OccGroup" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    Occ.ListingOrder, 
	          Occ.Description, 
			  Occ.OccupationalGroup, 			  	
	          <cfloop query="resource">
			  
		          SUM(Grade_#currentRow#) as Grade_#currentRow#, 			  
				  <cfset rw = CurrentRow>				  
				  <cfloop query="steps">
				  SUM(Grade#Status#_#rw#) as Grade#Status#_#rw#, 
				  </cfloop>
				   			  
	          </cfloop>
			  
			  <cfloop query="steps">
				  SUM(Total#Status#) as Total#Status#, 
			  </cfloop>
			  SUM(Total) as Total, 
			  '1' as Show
	INTO 	  UserQuery.dbo.#SESSION.acc#RosterViewL#FileNo#
	FROM      OccGroup Occ 
			  LEFT OUTER JOIN userquery.dbo.#SESSION.acc#RosterView1_#FileNo# AP ON AP.OccupationalGroup = Occ.OccupationalGroup
	WHERE     Occ.Status = 1		  
	GROUP BY  Occ.ListingOrder, Occ.Description, Occ.OccupationalGroup
	ORDER BY  Occ.ListingOrder, Occ.Description 	
    </cfquery>
		
	
	<!---
	<cfoutput>6. #cfquery.executionTime#  </cfoutput>	
	--->
		
    <!--- cumulate roster level --->
	<cfquery name="Cum" 
	datasource="AppsQuery" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    '#URL.Edition#' as Roster, 
		          '#URL.Edition#' as OccupationalGroup,
		          <cfloop query="resource">
			          Sum(Grade_#currentRow#) as Grade_#currentRow#, 
					  <cfset rw = CurrentRow>
			  		  <cfloop query="steps">
					  Sum(Grade#status#_#rw#) as Grade#status#_#rw#,
					  </cfloop>
		          </cfloop>
				  <cfloop query="steps">
				  SUM(Total#status#) as Total#status#, 
				  </cfloop>
				  SUM(Total) as Total  
		INTO 	  dbo.#SESSION.acc#RosterViewT#FileNo#		
		FROM      #SESSION.acc#RosterViewL#FileNo# 		
	</cfquery>				
		
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterView1_#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewTmp#FileNo#">
<cf_droptable dbname="AppsQuery" tblname="#SESSION.acc#RosterViewTmp1#FileNo#"> 