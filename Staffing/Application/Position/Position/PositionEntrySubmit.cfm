
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfquery name="Parameter" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM Parameter
</cfquery>

<cfparam name="Form.Remarks" default="">

<cfif Len(Form.Remarks) gt 200>
	 <cf_alert message = "You entered remarks that exceeded the allowed size of 200 characters."  return = "back">	  
	 <cfabort>
</cfif>

<cfif ParameterExists(Form.LocationCode)> 
  <cfset loc = "#Form.LocationCode#">
<cfelse>   
  <cfset loc = "">
</cfif>   

<cfset dateValue = "">
<CF_DateConvert Value="#Form.DateEffective#">
<cfset STR = #dateValue#>

<cfset dateValue = "">
<cfif Form.DateExpiration neq ''>
    <CF_DateConvert Value="#Form.DateExpiration#">
    <cfset END = #dateValue#>
<cfelse>
    <cfset END = 'NULL'>
</cfif>	

<cfquery name="Mandate" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT *
		 FROM Ref_Mandate
		 WHERE Mission = '#Form.Mission#'
     	 AND   MandateNo = '#Form.MandateNo#'
</cfquery>

<cfoutput>

<cfif STR lt Mandate.DateEffective>

	<cf_alert message="Problem, the effective date may not lie prior to #DateFormat(Mandate.DateEffective, CLIENT.DateFormatShow)#" return="back">
	<cfabort>

</cfif>

<cfif END gt Mandate.DateExpiration>

	<cf_alert message="Problem, the expiration date may not lie after to #DateFormat(Mandate.DateExpiration, CLIENT.DateFormatShow)#" return="back">
	<cfabort>

</cfif>

</cfoutput>

<cfquery name="Current" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM Ref_Mission
	WHERE Mission = '#URL.Mission#'
</cfquery>

<cfquery name="PostType" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT     PostType
	FROM         Ref_PostGrade G INNER JOIN
                 Ref_PostGradeParent GP ON G.PostGradeParent = GP.Code
	WHERE G.PostGrade = '#Form.PostGrade#'			 
</cfquery>

<!--- external linkage IMIS, SA-IT etc. --->
	
<cfif Parameter.SourcePostNumber eq "PositionParent">

	<cfif Form.SourcePostNumber neq "">
	
			<cfquery name="Check" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   PositionParent
				 WHERE  SourcePostNumber = '#Form.SourcePostNumber#'
				 AND    Mission          = '#Form.Mission#'
				 AND    MandateNo        = '#Form.MandateNo#'
			</cfquery>	
			
			<cfif Check.recordcount gte "1">
			  <cf_alert message = "You are trying to register an external post Number <cfoutput>[#Form.SourcePostNumber#]</cfoutput> which is already in use. Operation not allowed."
		       return = "back">
		      <cfabort>
			</cfif>
		
		</cfif>
	
<cfelse>

	<cfif Form.SourcePostNumber neq "">
		
			<cfquery name="Check" 
			     datasource="AppsEmployee" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				 SELECT *
				 FROM   Position
				 WHERE  SourcePostNumber = '#Form.SourcePostNumber#'
				 AND    Mission          = '#Form.Mission#'
				 AND    MandateNo        = '#Form.MandateNo#'
				 AND    (
				         (DateExpiration   <= #END# AND DateExpiration >= #STR#)  
						      OR
				 		 (DateEffective    <= #END# AND DateEffective  >= #STR#)
						) 
			</cfquery>	
			
			
			<cfif Check.recordcount gte "1">
			  <cf_alert message = "You are trying to register an external post Number [#Form.SourcePostNumber#] which is already in use. Operation not allowed."
		       return = "back">
		      <cfabort>
			</cfif>
		
	</cfif>
	
</cfif>

<cftransaction action="BEGIN">

	<cfloop index="No" from="1" to="#Form.Number#" step="1">
	
	<cfquery name="InsertParent" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO PositionParent 
	         (Mission,
			 MandateNo, 
			 OrgUnitOperational,
			 OrgUnitAdministrative,
			 FunctionNo,
			 FunctionDescription,
			 ApprovalPostgrade,
			 PostGrade,
			 PostType,
			 Fund,
			 DateEffective,
			 DateExpiration,
			 <cfif Parameter.SourcePostNumber eq "PositionParent">
			 SourcePostNumber,
			 </cfif>
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Created)
	      VALUES ('#Form.Mission#',
	          '#Form.MandateNo#',
			  '#Form.OrgUnit#',
			  '#Form.OrgUnit1#',
			  '#Form.FunctionNo#',
			  '#Form.FunctionDescription#',
			  <cfif #Form.Classified# eq "0">
			  '',
			  <cfelse>
			  '#Form.ApprovalPostGrade#',
			  </cfif>
			  '#Form.PostGrade#',
			  '#Form.PostType#',
			  '#Form.Fund#',
			   #STR#,
			  #END#,
			  <cfif #Parameter.SourcePostNumber# eq "PositionParent">
			  '#Form.SourcePostNumber#',
			  </cfif>
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  getDate())
	</cfquery>
	
	<cfquery name="Last" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   TOP 1 PositionParentId 
	FROM     PositionParent 
	WHERE    Mission   = '#Form.Mission#'
	AND      MandateNo = '#Form.MandateNo#'
	ORDER BY PositionParentId DESC
	</cfquery>
		
	<cfset LastId = "#Last.PositionParentId#">
	
	<!--- position parent grouping --->
	
	<cfquery name="Topic" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT  *
	  FROM  Ref_PositionParentGroup
	  WHERE Code IN (SELECT GroupCode 
	                 FROM   Ref_PositionParentGroupList)
	</cfquery>
	  
	<cfloop query="topic">
				        
	     <cfset ListCode  = Evaluate("Form.ListCode_#Code#")>
					  
		   <cfquery name="Insert" 
			 datasource="AppsEmployee" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 INSERT INTO PositionParentGroup
				 (PositionParentId,
				  GroupCode,
				  GroupListCode, 
				  OfficerUserId,
				  OfficerLastName,
				  OfficerFirstName)
			 VALUES
			 ('#LastId#', '#Code#', '#ListCode#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')
			</cfquery>
		   
	</cfloop>
	
	<!--- disabled 
	<cfquery name="MandateUpdate" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	UPDATE Organization.dbo.Ref_Mandate
	SET _tsLastModified = #now()#
	WHERE Mission = '#Form.Mission#'
	AND MandateNo = '#Form.MandateNo#'
	</cfquery>	
	--->
	
	<cfquery name="InsertPosition" 
	     datasource="AppsEmployee" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO Position 
	         (PositionParentId,
			 Mission,
			 MandateNo, 
			 MissionOperational,
			 OrgUnitOperational,
			 OrgUnitAdministrative,
			 <cfif loc neq "">
			 LocationCode,
			 </cfif>
			 FunctionNo,
			 FunctionDescription,
			 PostGrade,
			 PostType,
			 PostClass,
			 PositionStatus,
			 PostAuthorised,
			 VacancyActionClass,
			 DateEffective,
			 DateExpiration,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName,	
			 Remarks,	
			 SourcePostNumber,
			 Created)
	      VALUES (#LastId#,
		      '#Form.Mission#',
	          '#Form.MandateNo#',
			  '#Form.Mission#',
			  '#Form.OrgUnit#',
			  '#Form.OrgUnit1#',
			  <cfif loc neq "">
			  '#loc#',
			  </cfif>
			  '#Form.FunctionNo#',
			  '#Form.FunctionDescription#',
			  '#Form.PostGrade#',
			  '#Form.PostType#',
			  '#Form.PostClass#',
			  '#Mandate.MandateStatus#',
			  '#Form.PostAuthorised#',
			  '#Form.VacancyActionClass#',
			  #STR#,
			  #END#,
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#',
			  '#Form.Remarks#',
			  '#Form.SourcePostNumber#',
			  getDate())
	</cfquery>
	
	<cfquery name="Last" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT TOP 1 PositionNo as LastId
	FROM      Position
	WHERE     Mission       = '#Form.Mission#'
	AND       MandateNo     = '#Form.MandateNo#'
	AND       OfficerUserId = '#SESSION.acc#'
	ORDER BY  PositionNo DESC
	</cfquery>
		
	<!--- update group --->
					
	<cfparam name="Form.PositionGroup" type="any" default="">
			
			<cfloop index="Item" 
			        list="#Form.PositionGroup#" 
			        delimiters="' ,">
						
				<cfquery name="InsertGroup" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO PositionGroup 
				         (PositionNo,
						 PositionGroup,
						 Status,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
				  VALUES ('#Last.LastId#',
				      	  '#Item#',
					      '1',
						  '#SESSION.acc#',
						  '#SESSION.last#',
						  '#SESSION.first#')
				</cfquery>
					
			</cfloop>		
		
		</cfloop>

</cftransaction>
  	
<script>
	 
	 returnValue = "1"
	 window.close()
 	 try {opener.document.getElementById("refresh").click() } catch(e) {   history.go() }
	 	 
</script>	
   
